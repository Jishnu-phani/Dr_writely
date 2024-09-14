import 'package:flutter/material.dart';
import 'package:dr_writely/login/audio_recorder_page.dart';

class RecordView extends StatelessWidget {
  static String tag = 'record-page';
  const RecordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF9F9F9), // Same background color as previous code
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                width:
                    double.infinity, // Make the button as wide as the container
                height: 56, // Match height of login button
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AudioRecorderPage.tag);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xFF1C110A), // Same background color as the login button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8.0), // Same corner radius as the login button
                    ),
                  ),
                  child: const Text(
                    "Record",
                    style: TextStyle(
                        color: Colors.white), // White text for contrast
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
