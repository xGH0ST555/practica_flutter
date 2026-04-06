import 'package:flutter/material.dart';
import '../themes/exports.dart';

class ProfileScreen extends StatelessWidget {
   
  const ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage('https://i.pinimg.com/736x/ee/04/d3/ee04d350b409e1f4caf9389275898ef6.jpg'),
                ),
                title: Text(user?.name ?? 'Usuario', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                subtitle: Text(user?.email ?? 'correo@example.com'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.logout, size: 28),
              onPressed: () {
                AuthService.logout();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
          ],
        ),
      )
    );
  }
}