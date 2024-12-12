// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:fire/signin.dart';

import 'package:get/get.dart';

// ignore: non_constant_identifier_names
SignupUSer(String Email, String phone, String pwd, String cpwd) async {
  User? userId = FirebaseAuth.instance.currentUser;
  try {
    await FirebaseFirestore.instance.collection("users").doc(userId!.uid).set({
      'userEmail': Email,
      'userPhone': phone,
      'userPassword': pwd,
      'userConfirmPassword': cpwd,
      'createdAt': DateTime.now(),
      'userId': userId.uid
    }).then((value) => {
          FirebaseAuth.instance.signOut(),
          Get.to(() => SignIn()),
        });
  } on FirebaseAuthException catch (e) {
    print("Error $e");
  }
}

