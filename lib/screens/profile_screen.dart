import 'package:flutter/material.dart';
import '../themes/exports.dart';

class ProfileScreen extends StatelessWidget {
   
  const ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    
    return Scaffold(
      body:ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      leading: CircleAvatar(
                      backgroundImage: NetworkImage('https://i.pinimg.com/1200x/83/6a/44/836a44d9f9362d4a993fe023c2f3cd50.jpg'),
                      ),
                      title: Text(user?.name ?? 'Usuario', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      subtitle: Text(user?.email ?? 'correo@example.com'),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.profileVisualizer);
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, size: 28),
                    onPressed: () {
                      AuthService.logout();
                      Navigator.pushReplacementNamed(context, AppRoutes.register);
                    },
                  ),
                ],
              ),
           ),
        ],
      ),
    );
  }
}        