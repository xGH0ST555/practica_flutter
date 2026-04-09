import 'package:flutter/material.dart';
import '../themes/exports.dart';

class RegistrarUsuario extends StatefulWidget {
  const RegistrarUsuario({super.key});

  @override
  State<RegistrarUsuario> createState() => _RegistrarUsuarioState();
}

class _RegistrarUsuarioState extends State<RegistrarUsuario> {
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    final nombre = _nombreController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validaciones
    if (nombre.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe tener al menos 6 caracteres'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final user = await AuthService.registrar(nombre, email, password);

    setState(() => _isLoading = false);

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario registrado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: El email ya está registrado o ocurrió un error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: BottomCurveClipper(),
              child: Image.network(
                'https://i.pinimg.com/736x/f1/d0/1b/f1d01bb792981209894615870862021b.jpg',
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Crear Cuenta',
                style: GoogleFonts.calSans(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Nombre
                  TextField(
                    controller: _nombreController,
                    style: GoogleFonts.calSans(),
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: GoogleFonts.calSans(),
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Email
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.calSans(),
                    decoration: InputDecoration(
                      labelText: 'Correo',
                      labelStyle: GoogleFonts.calSans(),
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Contraseña
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: GoogleFonts.calSans(),
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: GoogleFonts.calSans(),
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off_rounded,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Confirmar Contraseña
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: GoogleFonts.calSans(),
                    decoration: InputDecoration(
                      labelText: 'Confirmar Contraseña',
                      labelStyle: GoogleFonts.calSans(),
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off_rounded,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Botón de registro
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _registrar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text('Registrarse', style: GoogleFonts.calSans()),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Texto para ir a login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿Ya tienes una cuenta? ',
                        style: GoogleFonts.calSans(),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, AppRoutes.login),
                        child: Text(
                          'Inicia sesión',
                          style: GoogleFonts.calSans(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
