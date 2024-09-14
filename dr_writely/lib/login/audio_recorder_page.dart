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
  TextEditingController _nameController = TextEditingController();
  String userName = '';

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
        SnackBar(content: Text('Microphone permission not granted')),
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
    if (recordedFilePath.isEmpty) return;

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File uploaded successfully')),
        );
        Navigator.of(context).pushNamed(RecordView.tag);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File upload failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File upload failed: $e')),
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
          SnackBar(content: Text('File deleted successfully')),
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
      appBar: AppBar(
        title: Text('Audio Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isRecording ? stopRecording : startRecording,
                      child: Text(
                          isRecording ? 'Stop Recording' : 'Start Recording'),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isPlaying ? null : playAudio,
                      child: Text('Play Audio'),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (recordedFilePath.isNotEmpty) {
                          sendFile();
                        }
                      },
                      child: Text('Send to Server'),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: recordedFilePath.isNotEmpty ? deleteFile : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red), // Red button for delete
                      child: const Row(
                        mainAxisSize: MainAxisSize
                            .min, // Adjust the size of the Row to fit its children
                        children: [
                          Icon(Icons.delete),
                          SizedBox(
                              width:
                                  8), // Add some space between the icon and the text
                          Text('Delete Recording'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (isRecording) ...[
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Recording in progress...'),
            ] else if (recordedFilePath.isNotEmpty) ...[
              Text('Recording complete. Ready to send or delete.'),
            ],
          ],
        ),
      ),
    );
  }
}
