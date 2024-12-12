import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';

class Fpassword extends StatefulWidget {
  const Fpassword({super.key});

  @override
  State<Fpassword> createState() => _FpasswordState();
}

class _FpasswordState extends State<Fpassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyProject'),
        backgroundColor: Colors.teal[500],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.teal[100],
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            margin: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15),
                Text(
                  "Forgot Password",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  width: double.infinity,
                  child: TextFormField(
                    decoration: InputDecoration(
                      label: Text("Enter Your Email"),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[300],
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      "Reset Password",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: RichText(
                    text: TextSpan(
                      text: "Remembered your password? ",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}