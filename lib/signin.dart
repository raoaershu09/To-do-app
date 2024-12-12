import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'homescreen.dart';
import 'forgpass.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

TextEditingController loginEmail = TextEditingController();
TextEditingController loginPassword = TextEditingController();

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signInUser(String email, String password) async {
    try {
      debugPrint("Attempting to sign in user...");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        debugPrint("User signed in: ${user.uid}");

        // Save or update user data in Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          debugPrint("Creating new user document in Firestore...");
          await _firestore.collection('users').doc(user.uid).set({
            'email': email,
            'lastSignIn': DateTime.now(),
          });
        } else {
          debugPrint("Updating lastSignIn for user in Firestore...");
          await _firestore.collection('users').doc(user.uid).update({
            'lastSignIn': DateTime.now(),
          });
        }

        // Navigate to HomeScreen
        debugPrint("Navigating to HomeScreen...");
        Get.off(() => HomeScreen());
      } else {
        debugPrint("User is null after signing in.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to sign in. Please try again.")),
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to sign in: ${e.message}")),
      );
    } catch (e) {
      debugPrint("Exception during sign-in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An unexpected error occurred: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        backgroundColor: Colors.teal[500],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.teal[100],
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Sign In",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: loginEmail,
                  decoration: InputDecoration(
                    label: Text("Email"),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: loginPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    label: Text("Password"),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Fpassword()),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String email = loginEmail.text.trim();
                    String password = loginPassword.text.trim();
                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please fill in all fields.")),
                      );
                    } else {
                      await signInUser(email, password);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[300],
                  ),
                  child: Text("Sign In"),
                ),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/signup');
                          },
                      ),
                    ],
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
