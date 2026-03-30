import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
   
  const ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage('https://i.pinimg.com/736x/ee/04/d3/ee04d350b409e1f4caf9389275898ef6.jpg'),
          ),
          title: Text('John Doe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          subtitle: Text('john.doe@example.com'),
        ),
      );
  }
}