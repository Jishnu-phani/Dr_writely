import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dr_writely/login/record_view.dart';

class AudioRecorderPage extends StatefulWidget {
  static String tag = 'audio_recording-page';
  @override
  _AudioRecorderPageState createState() => _AudioRecorderPageState();
}

class _AudioRecorderPageState extends State<AudioRecorderPage> {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool isRecording = false;
  bool isPlaying = false;
  String recordedFilePath = '';

  final TextEditingController _nameController = TextEditingController();
  String userName = '';
  var audioSent = false;
  var patientNameSent = false;

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _player?.closePlayer();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> initRecorder() async {
    if (await Permission.microphone.request().isGranted) {
      _recorder = FlutterSoundRecorder();
      _player = FlutterSoundPlayer();

      await _recorder!.openRecorder();
      await _player!.openPlayer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission not granted')),
      );
    }
  }

  Future<void> startRecording() async {
    try {
      recordedFilePath = '${Directory.systemTemp.path}/audio_record.wav';
      await _recorder!.startRecorder(
        toFile: recordedFilePath,
        codec: Codec.pcm16WAV,
      );
      setState(() {
        isRecording = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting recording: $e')),
      );
    }
  }

  Future<void> stopRecording() async {
    try {
      await _recorder!.stopRecorder();
      setState(() {
        isRecording = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error stopping recording: $e')),
      );
    }
  }

  Future<void> sendFile() async {
    if (recordedFilePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file to send')),
      );
      return;
    }

    var uri = Uri.parse('http://172.16.128.130:5000/upload');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath(
        'audio',
        recordedFilePath,
        contentType: MediaType('audio', 'wav'),
      ),
    );

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        audioSent = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File uploaded successfully')),
        );
        await sendPatientName(); // Send patient name after file upload
        if (patientNameSent && audioSent) {
          Navigator.of(context).pushNamed(RecordView.tag);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File upload failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File upload failed: $e')),
      );
    }
  }

  Future<void> sendPatientName() async {
    var uri = Uri.parse('http://172.16.128.130:5000/patient');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'patient_name': _nameController.text});

    try {
      if (_nameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a patient name')),
        );
        return;
      }
      final response = await http.post(uri, headers: headers, body: body);
      if (response.statusCode == 200) {
        patientNameSent = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient name sent successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send patient name')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> playAudio() async {
    if (recordedFilePath.isNotEmpty) {
      try {
        await _player!.startPlayer(
          fromURI: recordedFilePath,
          codec: Codec.pcm16WAV,
          whenFinished: () {
            setState(() {
              isPlaying = false;
            });
          },
        );
        setState(() {
          isPlaying = true;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing audio: $e')),
        );
      }
    }
  }

  Future<void> deleteFile() async {
    try {
      final file = File(recordedFilePath);
      if (await file.exists()) {
        await file.delete();
        setState(() {
          recordedFilePath = '';
          isPlaying = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File deleted successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Match RecordView background
      appBar: AppBar(
        title: const Text(
          'Audio Recorder',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1C110A), // Match RecordView app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text Field for Patient Name Input
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Enter patient name',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor:
                      const Color(0xFF1C110A), // Match RecordView input field
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),

            // Record/Stop Button
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: isRecording ? stopRecording : startRecording,
                icon: Icon(
                  isRecording ? Icons.stop : Icons.mic,
                  size: 36.0,
                  color: const Color(0xFFF9F9F9),
                ),
                label: Text(
                  isRecording ? 'Stop Recording' : 'Start Recording',
                  style:
                      const TextStyle(fontSize: 18, color: Color(0xFFF9F9F9)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isRecording ? Colors.red : const Color(0xFF1C110A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Play Audio Button
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed:
                    isPlaying || recordedFilePath.isEmpty ? null : playAudio,
                icon:
                    const Icon(Icons.play_arrow, size: 28, color: Colors.white),
                label: const Text(
                  'Play Audio',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C110A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Send File Button
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: recordedFilePath.isNotEmpty ? sendFile : null,
                icon: const Icon(Icons.upload, size: 28, color: Colors.white),
                label: const Text(
                  'Send Audio',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C110A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Delete File Button
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: recordedFilePath.isNotEmpty ? deleteFile : null,
                icon: const Icon(Icons.delete, size: 28, color: Colors.white),
                label: const Text(
                  'Delete File',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C110A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
