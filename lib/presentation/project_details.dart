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
            ],
          ),
        ),
      ),
    );
  }
}
