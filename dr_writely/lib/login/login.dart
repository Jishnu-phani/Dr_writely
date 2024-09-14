import 'package:flutter/material.dart';
import 'package:dr_writely/login/record_view.dart';

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
          color: Color(0xFF1C110A), // Change the color of the logo to #1C110A
        ),
      ),
    );

    final name = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Name',
        hintStyle: const TextStyle(
          color: Color.fromARGB(104, 158, 158, 158),
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
          color: Color.fromARGB(104, 158, 158, 158),
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
                const Color(0xFF1C110A), // Set background color to #1C110A
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
          backgroundColor:
              const Color(0xFF5AA9E6), // Set background color to #5AA9E6
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
          Navigator.of(context).pushNamed(RecordView.tag);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xFF5AA9E6), // Set background color to #5AA9E6
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
      backgroundColor: const Color(0xFFF9F9F9), // Light gray background
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
