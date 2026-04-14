import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _practica1 = 'practica1.db';
  static const int _version = 2;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), _practica1);
    return await openDatabase(
      path, 
      version: _version,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
      // Agregamos esto para evitar bloqueos si la base de datos está ocupada
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // Si la base de datos NO existe, se ejecuta esto:
  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        foto_perfil TEXT,
        fondo_perfil TEXT
      )
    ''');

    await db.execute(''' 
      CREATE TABLE productos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        description TEXT NOT NULL,
        thumbnail TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE carrito(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        producto_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        thumbnail TEXT,
        cantidad INTEGER NOT NULL DEFAULT 1
      )
    ''');
  }

  // Si la base de datos YA EXISTE pero con una versión menor, se ejecuta esto:
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Usamos bloques try-catch individuales por si las columnas ya existen de un intento fallido previo
      try {
        await db.execute('ALTER TABLE usuarios ADD COLUMN foto_perfil TEXT');
      } catch (e) { print("Columna foto_perfil ya existía"); }
      
      try {
        await db.execute('ALTER TABLE usuarios ADD COLUMN fondo_perfil TEXT');
      } catch (e) { print("Columna fondo_perfil ya existía"); }
    }
  }
}