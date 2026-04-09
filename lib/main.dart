import 'package:flutter/material.dart';
import 'package:practica_1/routes/app_routes.dart';
import 'package:practica_1/themes/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.register,
      routes: AppRoutes.routes,
      theme: AppTheme.Theme,
    );
  }
}
