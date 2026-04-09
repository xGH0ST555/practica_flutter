import 'package:practica_1/db/database_helper.dart';
import 'package:practica_1/models/user.dart';

class UsuarioService {
  //insertar un nuevo usuario
  static Future<int> insertar(User user) async {
    final db = await DatabaseHelper.database;
    return await db.insert('usuarios',
      {
        'nombre': user.name,
        'email': user.email,
        'password': user.password
      }
    );
  }

  //Registrar un nuevo usuario con validación
  static Future<User?> register(String name, String email, String password) async {
    try {
      //Verificar si el email ya existe
      final existingUser = await login(email, password);
      if (existingUser != null) {
        return null; //Email ya registrado
      }

      //Crear nuevo usuario
      final user = User(name: name, email: email, password: password);
      await insertar(user);
      return user;
    } catch (e) {
      //Manejar errores (ej: email duplicado)
      return null;
    }
  }

  //Login de usuario
  static Future<User?> login(String email, String password) async {
    final db = await DatabaseHelper.database;
    final result = await db.query(
      'usuarios',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password]
    );
    if(result.isNotEmpty){
      return User(
        name: result.first['nombre'] as String,
        email: result.first['email'] as String,
        password: result.first['password'] as String
      );
    }
    return null;
  }
  //obtener todos los usuarios
  static Future<List<User>> obtenerUsuarios() async {
    final db = await DatabaseHelper.database;
    final result = await db.query('usuarios');
    return result.map((u) => User(
      name: u['nombre'] as String,
      email: u['email'] as String,
      password: u['password'] as String
    )).toList();
  }
  //eliminar usuarios por email
  static Future<int> eliminarUsuario(String email) async{
    final db = await DatabaseHelper.database;
    await db.delete('usuarios', where: 'email = ?', whereArgs: [email]);
    return 1;
  }
}