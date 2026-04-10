import 'package:flutter/material.dart';
import 'package:practica_1/screens/login_screen.dart';

import '../themes/exports.dart';

class ProfilleVisualizer extends StatelessWidget {
   
  const ProfilleVisualizer({super.key});
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = AuthService.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                ClipPath(
                  clipper: BottomCurveClipper(),
                  child: Image.network(
                    'https://i.pinimg.com/1200x/62/57/06/625706d04942c225e084551a24cf3973.jpg',
                    width: size.width,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 180),
              ],
            ),
            Positioned(
              top: 180,
              left: 0,
              right: 0,
              child: Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage('https://i.pinimg.com/1200x/83/6a/44/836a44d9f9362d4a993fe023c2f3cd50.jpg'),
                ),
              ),
            ),
            Positioned(
              top: 310,
              left: 0,
              right: 0,
              child: Center(
                child: Text(user?.name ?? 'Usuario', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Positioned(
              top: 355,
              left: 0,
              right: 0,
              child: Center(
                child: Text(user?.email ?? 'correo@example.com', style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}