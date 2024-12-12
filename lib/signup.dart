import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

TextEditingController userEmail = TextEditingController();
TextEditingController userPhone = TextEditingController();
TextEditingController userPassword = TextEditingController();
TextEditingController userConfirmP = TextEditingController();

class _SignUpState extends State<SignUp> {
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
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  width: double.infinity,
                  child: TextFormField(
                    controller: userEmail,
                    decoration: InputDecoration(
                      label: Text("Enter Your Email"),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  width: double.infinity,
                  child: TextFormField(
                    controller: userPhone,
                    decoration: InputDecoration(
                      label: Text("Phone Number"),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  width: double.infinity,
                  child: TextFormField(
                    controller: userPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text("Enter Your Password"),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  width: double.infinity,
                  child: TextFormField(
                    controller: userConfirmP,
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text("Confirm Password"),
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
                    onPressed: () {
                      var Email = userEmail.text.trim();
                      var phone = userPhone.text.trim();
                      var pwd = userPassword.text.trim();
                      var cpwd = userConfirmP.text.trim();

                      userEmail.clear();
                      userPhone.clear();
                      userPassword.clear();
                      userConfirmP.clear();
                      
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: Email, password: pwd)
                          .then((value) async {
                        log("User Created");
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(value.user?.uid)
                            .set({
                          'Email': Email,
                          'Phone': phone,
                          'Password': pwd,
                          'ConfirmPassword': cpwd
                        });
                        log("Data Created");
                      }).catchError((error) {
                        log("Error creating user: $error");
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[300],
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      "Sign Up",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
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
