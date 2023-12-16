import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/project_card.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  var _firestore = FirebaseFirestore.instance;
  var _user = FirebaseAuth.instance.currentUser;
  var userDetails;
  var _isLoading = true;

  @override
  void initState() {
    _firestore.collection("users").doc(_user!.uid).get().then((value) {
      setState(() {
        userDetails = value.data();
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Feed"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'add_project');
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'profile',
                  arguments: FirebaseAuth.instance.currentUser!.uid);
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection("projects")
                  .where("tags", arrayContainsAny: userDetails["followedTags"])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final projects = snapshot.data!.docs;
                  if (projects.isEmpty) {
                    return const Center(
                      child: Text("No projects to show"),
                    );
                  }
                  return ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final projectData =
                          projects[index].data() as Map<String, dynamic>;
                      debugPrint(projectData.toString());
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ProjectCard(
                          projectName: projectData["name"],
                          projectDescription: projectData["description"],
                          projectLink: projectData["link"],
                          projectTags: projectData["tags"],
                          username: projectData["username"],
                          userUid: projectData["uid"],
                          name: projectData["user_name"],
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
    );
  }
}
