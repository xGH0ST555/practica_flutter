import 'package:flutter/cupertino.dart';
import 'package:practica_1/screens/home_screen.dart';
import 'package:practica_1/screens/product_visualizer.dart';
import 'package:practica_1/screens/cart_screen.dart';

class AppRoutes {
 static String home = '/';
 static String productVisualizer = '/product';
 static String cart = '/cart';


static Map<String, WidgetBuilder> get routes =>{
 home : (context) => HomeScreen(),
 productVisualizer: (context) => ProductVisualizer(),
 cart: (context) => CartScreen(),
 };
}

