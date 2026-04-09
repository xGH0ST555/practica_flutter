
import 'package:practica_1/models/user.dart';
import 'package:practica_1/services/usuario_service.dart';

class AuthService {
  static User? _currentUser;

  //Retorna el usuario autenticado actual
  static User? get currentUser => _currentUser;

  //Login con SQLite
  static Future<User?> login(String email, String password) async {
    try {
      final user = await UsuarioService.login(email, password);
      if (user != null) {
        _currentUser = user;
      }
      return user;
    } catch (e) {
      return null;
    }
  }

  //Cierra la sesión del usuario actual
  static void logout() {
    _currentUser = null;
  }

  //Registro de nuevo usuario con SQLite
  static Future<User?> registrar(String nombre, String email, String password) async {
    try {
      final user = await UsuarioService.register(nombre, email, password);
      if (user != null) {
        _currentUser = user;
      }
      return user;
    } catch (e) {
      return null; // email duplicado u otro error
    }
  }
}

