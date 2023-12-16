import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    super.key,
    required this.projectName,
    required this.projectDescription,
    required this.projectLink,
    required this.projectTags,
    required this.username,
    required this.userUid,
    required this.name,
  });

  final String projectName;
  final String projectDescription;
  final String projectLink;
  final List projectTags;
  final String username;
  final String userUid;
  final String name;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, 'project_details', arguments: {
            "projectName": widget.projectName,
            "projectDescription": widget.projectDescription,
            "projectLink": widget.projectLink,
            "projectTags": widget.projectTags,
            "username": widget.username,
            "userUid": widget.userUid,
            "name": widget.name,
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    radius: 25,
                    child: Text(widget.name[0]),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name),
                    Text("@${widget.username}"),
                  ],
                ),
              ],
            ),
            ListTile(
              title: Text(
                widget.projectName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(widget.projectDescription),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Linkify(
                onOpen: (link) async {
                  await launchUrl(Uri.parse(link.url));
                },
                text: widget.projectLink,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 5,
                children: [
                  for (var tag in widget.projectTags)
                    Chip(
                      label: Text(tag),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
