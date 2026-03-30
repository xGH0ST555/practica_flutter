import 'package:flutter/cupertino.dart';
import 'package:practica_1/screens/home_screen.dart';

class AppRoutes {
 static String home = '/';


static Map<String, WidgetBuilder> get routes =>{
 home : (context) => HomeScreen(),
 };
}

