
import 'package:practica_1/db/database_helper.dart';
import 'package:practica_1/models/productos.dart';

class CarritoService {
  //agregar producto al carrito
  static Future<void> agregar(Producto producto) async {
    final db = await DatabaseHelper.database;

    //Verificar si el producto ya está en el carrito
    final existe = await db.query(
      'carrito',
      where: 'producto_id = ?',
      whereArgs: [producto.id]

    );

    if (existe.isNotEmpty){
      // Si el producto ya existe, actualiza la cantidad
      await db.rawUpdate('''
        UPDATE carrito SET cantidad = cantidad + 1
        WHERE producto_id = ?
      ''', [producto.id]);
    } else {
      // Si el producto no existe, insertarlo
      await db.insert('carrito', {
        'producto_id': producto.id,
        'title': producto.nombre,
        'price': producto.precio,
        'thumbnail': producto.imagen,
        'cantidad': 1
      });
    }
  }

  //obtener productos del carrito
   static Future<List<Map<String, dynamic>>> obtenerCarrito() async {
    final db = await DatabaseHelper.database;
    return await db.query('carrito');
  }

  // Eliminar producto del carrito
  static Future<void> eliminar(int productoId) async {
    final db = await DatabaseHelper.database;
    await db.delete('carrito', where: 'producto_id = ?', whereArgs: [productoId]);
  }

  // Vaciar carrito completo
  static Future<void> vaciar() async {
    final db = await DatabaseHelper.database;
    await db.delete('carrito');
  }

  // Total del carrito
  static Future<double> total() async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(price * cantidad) as total FROM carrito'
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

}