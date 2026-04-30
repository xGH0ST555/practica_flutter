import 'dart:io';
import 'package:flutter/material.dart';
import 'package:practica_1/models/user.dart';
import 'package:practica_1/screens/profille_visualizer.dart';
import 'package:practica_1/services/usuario_service.dart';
import '../themes/exports.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final user = AuthService.currentUser;
    if (user != null) {
      final usuarioActualizado = await UsuarioService.obtenerUsuario(user.email);
      if (mounted) {
        setState(() {
          _user = usuarioActualizado ?? user;
        });
      }
    } else if (mounted) {
      setState(() {
        _user = null;
      });
    }
  }

  ImageProvider _getProfileImage() {
    final fotoPerfil = _user?.fotoPerfil;
    
    if (fotoPerfil == null || fotoPerfil.isEmpty) {
      return const NetworkImage(
          'https://i.pinimg.com/1200x/80/ab/ae/80abaeeea9d3a1a161d3ff7067cef58a.jpg');
    }

    if (!fotoPerfil.startsWith('http')) {
      final file = File(fotoPerfil);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }

    return NetworkImage(fotoPerfil);
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    
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
                      radius: 30,
                      backgroundImage: _getProfileImage(),
                      child: user == null ? const Text('U') : null,
                    ),
                    title: Text(
                      user?.name ?? 'Usuario',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user?.email ?? 'correo@example.com'),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilleVisualizer(),
                        ),
                      );
                      if (mounted) {
                        await _cargarUsuario();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, size: 28),
                  onPressed: () {
                    AuthService.logout();
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, AppRoutes.register);
                    }
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