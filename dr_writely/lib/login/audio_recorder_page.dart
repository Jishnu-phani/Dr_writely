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

  // Add a TextEditingController to manage the input for the user's name
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
    // Check for microphone permission
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
          isPlaying = false; // Stop any ongoing playback
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
      backgroundColor: const Color(0xFFF9F9F9), // Gray background color
      appBar: AppBar(
        title: const Text('Audio Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter patient name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    userName = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Start/Stop Recording Button
                  SizedBox(
                    width: double.infinity,
                    height: 56, // Match height of login button
                    child: ElevatedButton(
                      onPressed: isRecording ? stopRecording : startRecording,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF1C110A), // Same color as login button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // Squared corners
                        ),
                      ),
                      child: Text(
                        isRecording ? 'Stop Recording' : 'Start Recording',
                        style: const TextStyle(
                          color: Color(0xFFF9F9F9), // Updated text color
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Space between buttons

                  // Play Audio Button
                  SizedBox(
                    width: double.infinity,
                    height: 56, // Match height of login button
                    child: ElevatedButton(
                      onPressed: isPlaying ? null : playAudio,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF1C110A), // Same style as start recording button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // Squared corners
                        ),
                      ),
                      child: const Text(
                        'Play Audio',
                        style: TextStyle(
                          color: Color(
                              0xFFF9F9F9), // Same text color as start recording button
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Space between buttons

                  // Send to Server Button
                  SizedBox(
                    width: double.infinity,
                    height: 56, // Match height of login button
                    child: ElevatedButton(
                      onPressed: (recordedFilePath.isNotEmpty &&
                              _nameController.text.isNotEmpty)
                          ? sendFile
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF1C110A), // Same style as start recording button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // Squared corners
                        ),
                      ),
                      child: const Text(
                        'Send to Server',
                        style: TextStyle(
                          color: Color(
                              0xFFF9F9F9), // Same text color as start recording button
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Space between buttons

                  // Delete Recording Button (Stays with red color)
                  SizedBox(
                    width: double.infinity,
                    height: 56, // Match height of login button
                    child: ElevatedButton(
                      onPressed:
                          recordedFilePath.isNotEmpty ? deleteFile : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Red button for delete
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // Squared corners
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize
                            .min, // Adjust the size of the Row to fit its children
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(
                              width:
                                  8), // Add some space between the icon and the text
                          Text('Delete Recording',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (isRecording) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              const Text('Recording in progress...'),
            ] else if (recordedFilePath.isNotEmpty) ...[
              const Text('Recording complete. Ready to send or delete.'),
            ],
          ],
        ),
      ),
    );
  }
}
