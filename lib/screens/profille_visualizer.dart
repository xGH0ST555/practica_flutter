import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practica_1/services/usuario_service.dart';
import 'dart:io';
import '../themes/exports.dart';

class ProfilleVisualizer extends StatefulWidget {
  const ProfilleVisualizer({super.key});

  @override
  State<ProfilleVisualizer> createState() => _ProfilleVisualizerState();
}

class _ProfilleVisualizerState extends State<ProfilleVisualizer> {
  final _picker = ImagePicker();
  bool _isLoading = true;
  bool _isPickerActive = false;

  final List<String> _fondos = [
    'assets/fondos/fondo1.jpg',
    'assets/fondos/fondo2.jpg',
    'assets/fondos/fondo3.jpg',
    'assets/fondos/fondo4.jpg'
  ];

  String? _fotoPerfil;
  String? _fondoPerfil;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  // Cargar fondo y fondos guardados del usuario
  Future<void> _cargarDatosUsuario() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = AuthService.currentUser;
      if (user == null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
        return;
      }

      final usuarioActualizado = await UsuarioService.obtenerUsuario(user.email);

      if (mounted) {
        setState(() {
          _fotoPerfil = usuarioActualizado?.fotoPerfil;
          _fondoPerfil = usuarioActualizado?.fondoPerfil;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos: $e')),
        );
      }
    }
  }

  // Selecciona foto desde la galeria
  Future<void> _seleccionarFoto() async {
  if (_isPickerActive) return;

  setState(() => _isPickerActive = true);
  try {
    final XFile? imagen = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (imagen != null) {
      final user = AuthService.currentUser;
      await UsuarioService.actualizarFotoPerfil(user!.email, imagen.path);
      if (mounted) {
        setState(() => _fotoPerfil = imagen.path);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto de perfil actualizada')),
        );
      }
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al seleccionar la imagen')),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isPickerActive = false);
    }
  }
}

// Similar para _seleccionarFondoGaleria:
Future<void> _seleccionarFondoGaleria() async {
  if (_isPickerActive) return;
  setState(() => _isPickerActive = true);

  try {
    final XFile? imagen = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (imagen != null) {
      final user = AuthService.currentUser;
      await UsuarioService.actualizarFondoPerfil(user!.email, imagen.path);
      if (mounted) {
        setState(() => _fondoPerfil = imagen.path);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fondo de perfil actualizado')),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
      }
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al seleccionar la imagen')),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isPickerActive = false);
    }
  }
}

  // seleccionador de fondos
  void _mostrarSelectorFondos() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Elige un fondo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _fondos.length + 1,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    // OPCIÓN: GALERÍA (PERSONALIZADO)
                    if (index == _fondos.length) {
                      return GestureDetector(
                        onTap: _isPickerActive ? null : () => _seleccionarFondoGaleria(),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isPickerActive ? Colors.grey : Colors.deepPurple,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo,
                                      size: 30,
                                      color: _isPickerActive ? Colors.grey : Colors.deepPurple),
                                  const SizedBox(height: 5),
                                  const Text('Galería',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    // OPCIONES: FONDOS PREDEFINIDOS
                    final fondo = _fondos[index];
                    final seleccionado = fondo == _fondoPerfil;

                    return GestureDetector(
                      onTap: _isPickerActive ? null : () async {
                        final user = AuthService.currentUser;
                        if (user == null) return;

                        setState(() => _isPickerActive = true);

                        try {
                          await UsuarioService.actualizarFondoPerfil(user.email, fondo);
                          if (ctx.mounted) {
                            setState(() => _fondoPerfil = fondo);
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(content: Text('Fondo actualizado')),
                            );
                            if (Navigator.canPop(ctx)) Navigator.pop(ctx);
                          }
                        } catch (e) {
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(content: Text('Error al actualizar fondo: $e')),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() => _isPickerActive = false);
                          }
                        }
                      },
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: seleccionado ? Colors.deepPurple : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(fondo, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // Helper para obtener la imagen de fondo
  Widget _buildBackgroundImage() {
    if (_fondoPerfil == null || _fondoPerfil!.isEmpty) {
      // Fondo por defecto
      return Image.network(
        'https://i.pinimg.com/1200x/15/e9/46/15e946aa33ba278a6d60b479b2b99a2f.jpg',
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 250,
            color: Colors.deepPurple.shade100,
            child: const Icon(Icons.image, size: 100, color: Colors.deepPurple),
          );
        },
      );
    }

    // Si es una ruta de asset
    if (_fondoPerfil!.startsWith('assets/')) {
      return Image.asset(
        _fondoPerfil!,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 250,
            color: Colors.deepPurple.shade100,
            child: const Icon(Icons.image, size: 100, color: Colors.deepPurple),
          );
        },
      );
    }

    // Si es una ruta de archivo local
    final file = File(_fondoPerfil!);
    if (file.existsSync()) {
      return Image.file(file, width: double.infinity, height: 250, fit: BoxFit.cover);
    } else {
      // Si el archivo no existe, mostrar fondo por defecto
      return Container(
        width: double.infinity,
        height: 250,
        color: Colors.deepPurple.shade100,
        child: const Icon(Icons.image, size: 100, color: Colors.deepPurple),
      );
    }
  }

  // Helper para obtener la imagen de perfil
  ImageProvider _getProfileImage() {
    if (_fotoPerfil == null || _fotoPerfil!.isEmpty) {
      // Foto por defecto
      return const NetworkImage(
          'https://i.pinimg.com/1200x/80/ab/ae/80abaeeea9d3a1a161d3ff7067cef58a.jpg');
    }

    // Si es una ruta de archivo local
    if (!_fotoPerfil!.startsWith('http')) {
      final file = File(_fotoPerfil!);
      if (file.existsSync()) {
        return FileImage(file);
      } else {
        // Si el archivo no existe, retornar foto por defecto
        return const NetworkImage(
            'https://i.pinimg.com/1200x/83/6a/44/836a44d9f9362d4a993fe023c2f3cd50.jpg');
      }
    }

    // Si es una URL de red
    return NetworkImage(_fotoPerfil!);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = AuthService.currentUser;

    if (user == null) {
      Future.microtask(() {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Mostrar indicador de carga mientras se cargan los datos
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: 600,
          child: Stack(
            children: [
              // Fondo
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: BottomCurveClipper(),
                  child: _buildBackgroundImage(),
                ),
              ),

              // Botón cambiar fondo
              Positioned(
                top: 20,
                right: 20,
                child: FloatingActionButton(
                  heroTag: 'change_bg_btn',
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: _mostrarSelectorFondos,
                  child: const Icon(Icons.image, color: Colors.deepPurple),
                ),
              ),

              // Botón regresar
              Positioned(
                top: 20,
                left: 20,
                child: FloatingActionButton(
                  heroTag: 'back_btn',
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.deepPurple),
                ),
              ),

              // Foto de perfil
              Positioned(
                top: 180,
                left: 0,
                right: 0,
                child: Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: _getProfileImage(),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.deepPurple,
                          onPressed: _seleccionarFoto,
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Nombre
              Positioned(
                top: 315,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    user.name,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Email
              Positioned(
                top: 360,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    user.email,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Clase para el borde curvo inferior
class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}