import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterUserInfo extends StatefulWidget {
  const RegisterUserInfo({super.key});

  @override
  State<RegisterUserInfo> createState() => _RegisterUserInfoState();
}

class _RegisterUserInfoState extends State<RegisterUserInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _followedTags = [];
  final List<String> _allTags = [
    "Technology",
    "Business",
    "Entertainment",
    "Sports",
    "Science",
    "Health",
    "Politics",
    "Travel",
    "Fashion",
    "Food",
    "Education",
    "Lifestyle",
    "Culture",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Information"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a username";
                      }
                      final usernameRegex = RegExp(r"^[a-zA-Z0-9]+$");
                      if (!usernameRegex.hasMatch(value)) {
                        return "Please enter a valid username";
                      }
                      final user = _firestore
                          .collection("users").where('username', isEqualTo: value).get();
                      debugPrint(user.toString() );



                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      final emailRegex =
                          RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$");
                      if (!emailRegex.hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your description";
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  const Text("Follow Topics of Interest"),
                  Wrap(
                    children: _allTags
                        .map(
                          (tag) => Padding(
                            padding:
                                const EdgeInsets.fromLTRB(2.0, 1.0, 2.0, 1.0),
                            child: ChoiceChip(
                              label: Text(tag),
                              selected: _followedTags.contains(tag),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _followedTags.add(tag);
                                  } else {
                                    _followedTags.remove(tag);
                                  }
                                });
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final user = {
                          "username": _usernameController.text,
                          "name": _nameController.text,
                          "email": _emailController.text,
                          "description": _descriptionController.text,
                          "followedTags": _followedTags,
                        };
                        final currentUser = FirebaseAuth.instance.currentUser;
                        currentUser!
                            .updateDisplayName(_usernameController.text);
                        _firestore
                            .collection("users")
                            .doc(currentUser.uid)
                            .set(user);
                        Navigator.pushNamed(context, 'home');
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
