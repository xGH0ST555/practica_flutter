import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _practica1 = 'practica1.db';
  static const int _version = 1;

  //sigleton: Instancia para la base de datos
  static Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  //inicializar la base de datos
  static Future<Database> _initDB() async{
    final path = join(await getDatabasesPath(), _practica1);
    return await openDatabase(path, version: _version, onCreate: _createTables);
  }

  static Future<void> _createTables(Database db, int version) async{
    await db.execute('''
      CREATE TABLE usuarios(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL
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
  

}