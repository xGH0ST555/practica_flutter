import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/productos.dart';

class ProductsService {
  static const String baseUrl = 'https://dummyjson.com';

  /// Obtener todos los productos de dummyjson
  static Future<List<Producto>> getProductos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> productsJson = jsonData['products'];
        
        return productsJson
            .map((productJson) => Producto.fromJson(productJson))
            .toList();
      } else {
        throw Exception('Error al cargar productos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Obtener un producto específico por ID
 /* static Future<Producto> getProductoById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Producto.fromJson(jsonData);
      } else {
        throw Exception('Producto no encontrado');
      }
    } catch (e) {
      throw Exception('Error al obtener producto: $e');
    }
  }*/
  /// Buscar productos por categoría
  static Future<List<Producto>> searchByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/category/$category'),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> productsJson = jsonData['products'];
        
        return productsJson
            .map((productJson) => Producto.fromJson(productJson))
            .toList();
      } else {
        throw Exception('Categoría no encontrada');
      }
    } catch (e) {
      throw Exception('Error en búsqueda: $e');
    }
  }
}
