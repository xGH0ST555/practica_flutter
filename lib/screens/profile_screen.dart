import 'package:flutter/material.dart';
import 'package:practica_1/screens/profille_visualizer.dart';
import '../themes/exports.dart';

class ProfileScreen extends StatelessWidget {
   
  const ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    
    return Scaffold(
      body: ListView(
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
                    title: Text(user?.name ?? 'Usuario', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    subtitle: Text(user?.email ?? 'correo@example.com'),
                    onTap: () async {
                      try {
                        // Usar pushNamed con await para manejar posibles errores
                        await Navigator.pushNamed(context, AppRoutes.profileVisualizer);
                      } catch (e) {
                        print("Error al navegar: $e");
                        // Fallback: usar push en lugar de pushNamed
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfilleVisualizer()),
                        );
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, size: 28),
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