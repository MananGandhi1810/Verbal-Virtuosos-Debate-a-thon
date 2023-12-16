import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/project_card.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.uid});

  final String uid;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _firestore = FirebaseFirestore.instance;
  var user;
  var loggedInUser = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    _firestore.collection("users").doc(widget.uid).get().then((value) {
      setState(() {
        user = value.data();
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(user!["name"]),
        actions: [
          if (widget.uid == loggedInUser!.uid)
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'edit_details', arguments: {
                  "uid": widget.uid,
                  "name": user!["name"],
                  "username": user!["username"],
                  "email": user!["email"],
                  "description": user!["description"],
                  "followedTags": user!["followedTags"],
                });
              },
              icon: const Icon(Icons.edit),
            ),
          if (widget.uid != loggedInUser!.uid)
            IconButton(
              onPressed: () {
                launchUrl(Uri.parse("mailto:${user!["email"]}"));
              },
              icon: const Icon(Icons.mail),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 20.0, 8.0),
                    child: CircleAvatar(
                      radius: 50,
                      child: Text(
                        user!["name"][0],
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user!["name"],
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        "@${user!["username"]}",
                        style: const TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                child: Divider(),
              ),
              Text(
                user["description"],
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              const Text(
                "Followed Tags",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Wrap(
                children: [
                  for (var tag in user["followedTags"])
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Chip(
                        label: Text(tag),
                      ),
                    ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                child: Divider(),
              ),
              const Text(
                "Projects",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("projects")
                    .where("uid", isEqualTo: widget.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final projects = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        final project = projects[index];
                        return ProjectCard(
                          projectName: project["name"],
                          projectDescription: project["description"],
                          projectLink: project["link"],
                          projectTags: project["tags"],
                          username: project["username"],
                          userUid: project["uid"],
                          name: project["user_name"],
                          id: project.id,
                          timestamp: project["timestamp"],
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
