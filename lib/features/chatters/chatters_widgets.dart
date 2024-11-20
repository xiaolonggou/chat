// Reusable UI componentsimport 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class ChatterTile extends StatelessWidget {
  final String name;
  final String avatarUrl;

  const ChatterTile({required this.name, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
      title: Text(name),
    );
  }
}
