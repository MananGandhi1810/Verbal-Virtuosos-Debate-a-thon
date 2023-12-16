import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_tark/presentation/register_user_info.dart';

import 'home.dart';
import 'phone.dart';

class main_page extends StatefulWidget {
  const main_page({Key? key}) : super(key: key);

  @override
  State<main_page> createState() => _main_pageState();
}

class _main_pageState extends State<main_page> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = FirebaseAuth.instance.currentUser;
          final _firestore = FirebaseFirestore.instance;
          var userExists = false;
          _firestore.collection("users").doc(user!.uid).get().then((value) {
            debugPrint("User exists: ${value.exists}");
            userExists = value.exists;
          });
          if (userExists) {
            return const MyHome();
          } else {
            return const RegisterUserInfo();
          }
        } else {
          return const MyPhone();
        }
      },
    );
  }
}
