import 'package:flutter/material.dart';
import 'package:dr_writely/login/record_view.dart';
import 'package:dr_writely/login/patient_view.dart'; // New PatientView

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    const logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Icon(
          Icons.account_circle,
          size: 100.0,
          color: Color(0xFF4A90E2), // Lighter blue for better contrast
        ),
      ),
    );

    final name = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Name',
        hintStyle: const TextStyle(
          color: Color(0xFFB0BEC5), // Softer gray for placeholder text
        ),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0), // Squared input box
        ),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: const TextStyle(
          color: Color(0xFFB0BEC5), // Softer gray for placeholder text
        ),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0), // Squared input box
        ),
      ),
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: double.infinity, // Make button as wide as input fields
        height: 56, // Match height of input fields
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(RecordView.tag);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFF4A90E2), // Updated to a calming blue
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Squared corners
            ),
          ),
          child: const Text(
            'Log In',
            style: TextStyle(color: Colors.white), // White text for contrast
          ),
        ),
      ),
    );

    final registerAsDoctor = SizedBox(
      height: 56, // Match height of login button
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RecordView.tag);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007AFF), // Strong blue accent
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Squared corners
          ),
        ),
        child: const Text(
          'Register as Doctor',
          style: TextStyle(color: Colors.white), // White text for contrast
        ),
      ),
    );

    final registerAsUser = SizedBox(
      height: 56, // Match height of login button
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(PatientView.tag);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007AFF), // Strong blue accent
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Squared corners
          ),
        ),
        child: const Text(
          'Register as Patient',
          style: TextStyle(color: Colors.white), // White text for contrast
        ),
      ),
    );

    return Scaffold(
      backgroundColor:
          const Color(0xFF1A1A1A), // Darker background for better contrast
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            const SizedBox(height: 48.0),
            name, // Name field
            const SizedBox(height: 8.0),
            password, // Password field
            const SizedBox(height: 24.0),
            loginButton, // Login Button
            const SizedBox(height: 8.0),
            Row(
              children: <Widget>[
                // Two buttons in a row, each taking up 50% of the width
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 8.0), // Add space between buttons
                    child: registerAsDoctor,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0), // Add space between buttons
                    child: registerAsUser,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
