import 'package:flutter/material.dart';
import 'package:practica_1/screens/cart_screen.dart';
import 'package:practica_1/screens/profile_screen.dart';
import 'package:practica_1/services/products_service.dart';
import '../themes/exports.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _previousIndex = 0;

  static final List<String> _titles = ['Home', 'Cart', 'Profile'];

  static final List<Widget> _screens = [
    HomeTab(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isForward = _currentIndex >= _previousIndex;

    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            final isCurrent = child.key == ValueKey<String>(_titles[_currentIndex]);
            final beginOffset = isCurrent
                ? Offset(isForward ? 0.5 : -0.5, 0.0)
                : Offset.zero;
            final endOffset = isCurrent
                ? Offset.zero
                : Offset(isForward ? -0.5 : 0.5, 0.0);

            final offsetAnimation = Tween<Offset>(
              begin: beginOffset,
              end: endOffset,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

            final opacity = isCurrent
                ? animation
                : ReverseAnimation(animation);

            return ClipRect(
              child: SlideTransition(
                position: offsetAnimation,
                child: FadeTransition(opacity: opacity, child: child),
              ),
            );
          },
          child: Text(
            _titles[_currentIndex],
            key: ValueKey<String>(_titles[_currentIndex]),
          ),
          layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
            return currentChild ?? const SizedBox.shrink();
          },
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _previousIndex = _currentIndex;
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ProductsService.getProductos(),
      builder: (context, snapshot) {
        //Estado de carga
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        //Error
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
                const SizedBox(height: 16),
              ],
            ),
          );
        }
        //Éxito - Mostrar productos
        if (snapshot.hasData) {
          final productos = snapshot.data!;
          
          if (productos.isEmpty) {
            return const Center(
              child: Text('No hay productos disponibles'),
            );
          }
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              return Cardproductos(
                productos: productos[index].toMap(),
              );
            },
          );
        }

        return const Center(child: Text('No hay datos'));
      },
    );
  }
}
      
      

