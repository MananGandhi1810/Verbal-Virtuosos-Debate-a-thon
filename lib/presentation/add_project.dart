import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  var user = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _projectNameController = TextEditingController();
  TextEditingController _projectDescriptionController = TextEditingController();
  TextEditingController _projectLinkController = TextEditingController();
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
  final List<String> _projectTags = [];

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _projectNameController,
                    decoration: const InputDecoration(
                      labelText: "Project Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a project name";
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  TextFormField(
                    controller: _projectDescriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: "Project Description",
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a project description";
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  TextFormField(
                    controller: _projectLinkController,
                    decoration: const InputDecoration(
                      labelText: "Project Link",
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a project link";
                      }
                      final linkRegex = RegExp(
                          r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}");
                      if (!linkRegex.hasMatch(value)) {
                        return "Please enter a valid project link";
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  Wrap(
                    children: _allTags
                        .map(
                          (tag) => Padding(
                            padding:
                                const EdgeInsets.fromLTRB(2.0, 1.0, 2.0, 1.0),
                            child: ChoiceChip(
                              label: Text(tag),
                              selected: _projectTags.contains(tag),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _projectTags.add(tag);
                                  } else {
                                    _projectTags.remove(tag);
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
                        debugPrint("Validated");
                        debugPrint(_projectNameController.text);
                        debugPrint(_projectDescriptionController.text);
                        debugPrint(_projectLinkController.text);
                        debugPrint(_projectTags.toString());
                        _firestore
                            .collection("users")
                            .doc(user!.uid)
                            .get()
                            .then((value) {
                          var project = {
                            "name": _projectNameController.text,
                            "description": _projectDescriptionController.text,
                            "link": _projectLinkController.text,
                            "timestamp": DateTime.now(),
                            "tags": _projectTags,
                            "uid": user!.uid,
                            "username": user!.displayName,
                            "user_name": value.data()!["name"],
                          };
                          debugPrint(project.toString());
                          _firestore
                              .collection("projects")
                              .add(project)
                              .then((value) {
                            debugPrint("Project added");
                            Navigator.pop(context);
                          }).catchError((error) {
                            debugPrint("Failed to add project: $error");
                          });
                        });
                      }
                    },
                    child: const Text("Add Project"),
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
