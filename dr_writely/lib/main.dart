import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Recorder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudioRecorderPage(),
    );
  }
}

class AudioRecorderPage extends StatefulWidget {
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
    _nameController.dispose(); // Don't forget to dispose of the controller
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
    if (userName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter patient name before recording')),
      );
      return;
    }

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

    var uri = Uri.parse('http://192.168.1.14:5000/upload');
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
          recordedFilePath = ''; // Reset the file path
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
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
              ElevatedButton(
                onPressed: isRecording ? stopRecording : startRecording,
                child: Text(isRecording ? 'Stop Recording' : 'Start Recording'),
              ),
              ElevatedButton(
                onPressed: isPlaying ? null : playAudio,
                child: Text('Play Audio'),
              ),
              ElevatedButton(
                onPressed: recordedFilePath.isNotEmpty ? sendFile : null,
                child: Text('Send to Server'),
              ),
              ElevatedButton(
                onPressed: recordedFilePath.isNotEmpty ? deleteFile : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text('Delete Recording'),
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
      ),
    );
  }
}
