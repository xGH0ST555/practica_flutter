import 'package:flutter/material.dart';
import 'package:practica_1/screens/home_screen.dart';
import 'package:practica_1/screens/login_screen.dart';
import 'package:practica_1/screens/registrar_usuario.dart';
import 'package:practica_1/screens/product_visualizer.dart';
import 'package:practica_1/screens/cart_screen.dart';
import 'package:practica_1/screens/profile_screen.dart';
import 'package:practica_1/screens/profille_visualizer.dart';

class AppRoutes {
  static const String register          = '/';           // ← const
  static const String login             = '/login';
  static const String home              = '/home';
  static const String productVisualizer = '/product';
  static const String cart              = '/cart';
  static const String profile           = '/profile';
  static const String profileVisualizer = '/profileVisualizer';



static Map<String, WidgetBuilder> get routes =>{
  register         : (context) => RegistrarUsuario(),
  login            : (context) => LoginScreen(),
  home             : (context) => HomeScreen(),
  productVisualizer: (context) => ProductVisualizer(),
  cart             : (context) => CartScreen(),
  profile          : (context) => ProfileScreen(),
  profileVisualizer: (context) => ProfilleVisualizer(),
 };
}

