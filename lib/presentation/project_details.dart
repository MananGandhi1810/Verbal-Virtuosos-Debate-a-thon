import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetails extends StatefulWidget {
  const ProjectDetails({super.key, required this.project});

  final Map<String, dynamic> project;

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  final TextEditingController _commentController = TextEditingController();
  final _firebase = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  var user_details;
  bool _isLoading = true;

  initState() {
    super.initState();
    _firebase.collection("users").doc(user!.uid).get().then((value) {
      setState(() {
        user_details = value.data();
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'profile',
                      arguments: widget.project["userUid"]);
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 20.0, 8.0),
                      child: CircleAvatar(
                        radius: 25,
                        child: Text(
                          widget.project["name"][0],
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.project["name"],
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          widget.project["username"],
                          style: const TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                child: Divider(),
              ),
              Text(
                widget.project["projectName"],
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(4.0),
              ),
              Text(
                widget.project["projectDescription"],
                style: const TextStyle(fontSize: 20),
              ),
              const Padding(
                padding: EdgeInsets.all(4.0),
              ),
              Linkify(
                text: widget.project["projectLink"],
                onOpen: (value) {
                  launchUrl(Uri.parse(value.url));
                },
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              Wrap(
                children: [
                  for (var tag in widget.project["projectTags"])
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
                      child: Chip(
                        label: Text(tag),
                      ),
                    ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        labelText: "Comment",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        setState(() {
                          var comment = {
                            "name": user_details["name"],
                            "username": user_details["username"],
                            "uid": user?.uid,
                            "timestamp": DateTime.now(),
                            "comment": _commentController.text,
                          };
                          _firebase
                              .collection("projects")
                              .doc(widget.project["id"])
                              .collection("comments")
                              .add(comment);
                          _commentController.clear();
                        });
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              StreamBuilder(
                stream: _firebase
                    .collection("projects")
                    .doc(widget.project["id"])
                    .collection("comments")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    debugPrint(snapshot.data.toString());
                    var comments = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        var comment = comments[index];
                        return Card(
                          child: ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  'profile',
                                  arguments: comment["uid"],
                                );
                              },
                              child: CircleAvatar(
                                child: Text(comment["name"][0]),
                              ),
                            ),
                            title: Text(comment["name"]),
                            subtitle: Text(comment["comment"]),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
