import 'package:fire/homescreen.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:fire/firebase_options.dart';

import 'package:fire/forgpass.dart';

import 'package:fire/signin.dart';

import 'package:fire/signup.dart';

import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(GetMaterialApp(
    routes: {
      '/': (context) => SignIn(),
      '/home': (context) => HomeScreen(),
      '/signup': (context) => SignUp(),
      '/fpassword': (context) => Fpassword(),
    },
    debugShowCheckedModeBanner: false,
  ));
}