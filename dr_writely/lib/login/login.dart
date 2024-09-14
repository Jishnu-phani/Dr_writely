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
          // color: Colors.grey,
        ),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: const TextStyle(color: Color.fromARGB(104, 158, 158, 158), ),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Color.fromARGB(104, 158, 158, 158), ),
        hintText: 'Password',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        // style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        onPressed: () {
          Navigator.of(context).pushNamed(RecordView.tag);
        },
        child: const Text('Log In', style: TextStyle(color: Colors.black)),
        ),
    );

    final registerAsDoctor = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        // style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        onPressed: () {
          Navigator.of(context).pushNamed(RecordView.tag);
        },
        child: const Text('Register as doctor', style: TextStyle(color: Colors.black)),
        ),
    );

    final registerAsUser = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        // style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        onPressed: () {
          Navigator.of(context).pushNamed(RecordView.tag);
        },
        child: const Text('Register as user', style: TextStyle(color: Colors.black)),
        ),
    );

    

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            const SizedBox(height: 48.0),
            email,
            const SizedBox(height: 8.0),
            password,
            const SizedBox(height: 24.0),
            loginButton,
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                registerAsDoctor,
                registerAsUser,
              ],
            ),
          ],
        ),
      ),
    );
  }
}