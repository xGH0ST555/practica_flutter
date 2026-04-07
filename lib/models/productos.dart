import 'dart:convert';

class Producto {
  final int id;
  final String nombre;
  final double precio;
  final String imagen;
  final String descripcion;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.imagen,
    required this.descripcion,
  });

  /// Convertir de JSON a Producto (desde dummyjson)
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as int,
      nombre: json['title'] ?? 'Producto sin nombre',
      precio: (json['price'] as num).toDouble(),
      imagen: json['thumbnail'] ?? 'https://via.placeholder.com/300',
      descripcion: json['description'] ?? 'Sin descripción',
    );
  }

  /// Convertir a Map para compatibilidad con el Card existente
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'imagen': imagen,
      'descripcion': descripcion,
    };
  }
}

class Productos {
  /// Lista estática con productos de ejemplo (mantener como fallback)
  static final List<Map<String, dynamic>> productos = [
    {
      'imagen': 'https://i.pinimg.com/1200x/70/1a/cc/701acc05b9a01095309459d38c570ff2.jpg',
      'nombre': 'Head phones',
      'precio': 10.0,
      'descripcion': 'Audifonos de cable northFace sonido de alta calidad',
    },
    {
      'imagen': 'https://i.pinimg.com/1200x/f2/38/5e/f2385ebedff4024e5b1bc8d59854027b.jpg',
      'nombre': 'Seiko Watch',
      'precio': 20.0,
      'descripcion': 'Reloj de pulsera Seiko con movimiento automático',
    },
    {
      'imagen': 'https://i.pinimg.com/736x/ee/04/d3/ee04d350b409e1f4caf9389275898ef6.jpg',
      'nombre': 'Wallet NY',
      'precio': 30.0,
      'descripcion': 'Billetera de cuero de estilo urbano',
    },
  ];
}


