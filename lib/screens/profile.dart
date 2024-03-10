import 'package:flutter/material.dart';
import 'login.dart'; // Importing the login component

class ProfileComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Profile Component', style: TextStyle(color: Colors.black)),
          SizedBox(
              height: 20), // Adding some space between the text and the button
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                  context, '/screens/login'); // Navigate to the login screen
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
