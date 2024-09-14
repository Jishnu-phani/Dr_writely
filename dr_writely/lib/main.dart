import 'package:flutter/material.dart';
import 'package:dr_writely/login/record_view.dart';
import 'package:dr_writely/login/login.dart';
import 'package:dr_writely/login/audio_recorder_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    RecordView.tag: (context) => RecordView(),
    AudioRecorderPage.tag: (context) => AudioRecorderPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dr_writely',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}