import 'package:flutter/material.dart';
import 'package:practica_1/themes/exports.dart';

class Cardproductos extends StatelessWidget {

  final Map<String, dynamic> productos;
  Cardproductos({required this.productos, super.key});
  final title = GoogleFonts.calSans(fontWeight: FontWeight.bold, fontSize: 20);
  final subtitle = GoogleFonts.calSans(fontWeight: FontWeight.normal, fontSize: 18, color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.productVisualizer, arguments: productos);
      },
      child: Card(
        
        margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 8),
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                  productos['imagen'],
                  width: 130,  
                  height: 130, 
                  fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: 110, height: 130,
                    child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 60, color: Colors.grey);
              },
            ),
          ),

          SizedBox(width: 16), // ← espacio entre imagen y texto

          // 📝 Contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productos['nombre'],
                  style: title,
                ),
                SizedBox(height: 6),
                Text(
                  '\$${productos['precio']}',
                  style: subtitle,
                ),
                SizedBox(height: 10),
                IconButton(
                  icon: Icon(Icons.add_shopping_cart, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ), 
          ),
          ]
          ),
        ),
      ),
    );
  }

}