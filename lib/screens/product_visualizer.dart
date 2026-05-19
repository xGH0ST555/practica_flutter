import 'package:flutter/material.dart';
import 'package:practica_1/services/carrito_service.dart';
import 'package:practica_1/widgets/fake_3d_visualizer.dart';
import '../themes/exports.dart';

class ProductVisualizer extends StatefulWidget {
  const ProductVisualizer({super.key});

  @override
  State<ProductVisualizer> createState() => _ProductVisualizerState();
}

class _ProductVisualizerState extends State<ProductVisualizer> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> producto = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(producto['nombre']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  child: Fake3DVisualizer(
                    images: (producto['imagenes'] as List<String>?)?.isNotEmpty == true
                        ? (producto['imagenes'] as List<String>)
                        : [producto['imagen'] as String],
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                producto['nombre'],
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${producto['precio']}',
                style: const TextStyle(fontSize: 20, color: Colors.green),
              ),
              const SizedBox(height: 16),
              Text(
                producto['descripcion'],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
               SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final productoAgregar = Producto(
                              id: producto['id'] as int,
                              nombre: producto['nombre'] as String,
                              precio: (producto['precio'] as num).toDouble(),
                              imagen: producto['imagen'] as String,
                              descripcion: producto['descripcion'] as String,
                            );
                            await CarritoService.agregar(productoAgregar);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Producto agregado al carrito'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Agregar al Carrito', style: GoogleFonts.calSans()),
                        ),
               ),
            ],
          ),
        ),
      ),
    );
  }
}