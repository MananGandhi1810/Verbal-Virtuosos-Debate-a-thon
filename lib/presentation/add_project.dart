import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    debugPrint(user!.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Project"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text("Add Project"),
        ),
      ),
    );
  }
}
