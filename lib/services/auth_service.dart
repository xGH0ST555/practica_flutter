
import 'package:practica_1/models/user.dart';

class AuthService {
  //simulacion del login
  static List<User> _users = [
    User(email: 'admin@gmail.com', password: 'admin123', name: 'Admin User'),
    User(email: 'user@gmail.com', password: 'user123', name: 'Normal User')
  ];
  
  static User? _currentUser;

  //Retorna el usuario autenticado actual
  static User? get currentUser => _currentUser;

  //Retorna el usuario de las credenciales correctas
  static User? login(String email, String password){
    try{
      final user = _users.firstWhere(
        (s) => s.email == email && s.password == password
        );
      _currentUser = user;
      return user;
    } catch (e) {
      return null;
    }
  }

  //Cierra la sesión del usuario actual
  static void logout() {
    _currentUser = null;
  }
}