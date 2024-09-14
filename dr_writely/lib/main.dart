import 'package:flutter/material.dart';
import 'package:dr_writely/login/record_view.dart';
import 'package:dr_writely/login/login.dart';
import 'package:dr_writely/login/audio_recorder_page.dart';
import 'package:dr_writely/login/patient_view.dart'; // Import the PatientView

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    RecordView.tag: (context) => RecordView(),
    AudioRecorderPage.tag: (context) => AudioRecorderPage(),
    PatientView.tag: (context) => const PatientView(), // Add PatientView route
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dr Writely',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Nunito',
      ),
      home: LoginPage(),
      routes: routes, // Pass the routes
    );
  }
}
