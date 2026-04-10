import 'package:flutter/material.dart';
import 'package:practica_1/services/carrito_service.dart';
import '../themes/exports.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CarritoSc();
}

class _CarritoSc extends State<CartScreen> {
  late Future<List<Map<String, dynamic>>> _carritoFuture;

  @override
  void initState() {
    super.initState();
    _carritoFuture = CarritoService.obtenerCarrito();
  }

  Future<void> _refreshCarrito() async {
    setState(() {
      _carritoFuture = CarritoService.obtenerCarrito();
    });
    await _carritoFuture;
  }

  Future<void> _incrementar(int productoId) async {
    await CarritoService.incrementarCantidad(productoId);
    await _refreshCarrito();
  }

  Future<void> _disminuir(int productoId, int cantidad) async {
    if (cantidad <= 1) {
      await CarritoService.eliminar(productoId);
    } else {
      await CarritoService.disminuirCantidad(productoId);
    }
    await _refreshCarrito();
  }

  Future<void> _vaciarCarrito() async {
    await CarritoService.vaciar();
    await _refreshCarrito();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Vaciar carrito',
            onPressed: () async {
              await _vaciarCarrito();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _carritoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar el carrito: ${snapshot.error}'));
          }

          final carrito = snapshot.data ?? [];
          if (carrito.isEmpty) {
            return Center(
              child: Text(
                'Tu carrito está vacío',
                style: GoogleFonts.calSans(fontSize: 18),
              ),
            );
          }

          final total = carrito.fold<double>(0.0, (sum, item) {
            final price = (item['price'] as num).toDouble();
            final cantidad = item['cantidad'] as int;
            return sum + price * cantidad;
          });

          return RefreshIndicator(
            onRefresh: _refreshCarrito,
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: carrito.length + 1,
              itemBuilder: (context, index) {
                if (index == carrito.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: GoogleFonts.calSans(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('\$${total.toStringAsFixed(2)}', style: GoogleFonts.calSans(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }

                final item = carrito[index];
                final productoId = item['producto_id'] as int;
                final title = item['title'] as String;
                final price = (item['price'] as num).toDouble();
                final quantity = item['cantidad'] as int;
                final thumbnail = item['thumbnail'] as String?;
                final subtotal = price * quantity;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade200,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: thumbnail != null && thumbnail.isNotEmpty
                                ? Image.network(
                                    thumbnail,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
                                  )
                                : const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: GoogleFonts.calSans(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('Precio: \$${price.toStringAsFixed(2)}', style: GoogleFonts.calSans()),
                              const SizedBox(height: 4),
                              Text('Subtotal: \$${subtotal.toStringAsFixed(2)}', style: GoogleFonts.calSans()),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () => _disminuir(productoId, quantity),
                                  ),
                                  Text(quantity.toString(), style: GoogleFonts.calSans(fontSize: 16)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () => _incrementar(productoId),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () async {
                                      await CarritoService.eliminar(productoId);
                                      await _refreshCarrito();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
