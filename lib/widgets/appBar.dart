import 'package:flutter/material.dart';

class AppBarMain extends StatelessWidget implements PreferredSizeWidget {
  final String title; // Add a title parameter

  const AppBarMain({Key? key, required this.title})
      : super(key: key); // Constructor to initialize the title

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title), // Use the title parameter here
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
