import 'package:flutter/material.dart';
import 'package:practica_1/screens/cart_screen.dart';
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
    const Center(child: Text('Profile content', style: TextStyle(fontSize: 24))),
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
    return ListView.builder(
      itemCount: Productos.productos.length,
      itemBuilder: (context, index) {
        return Cardproductos(productos: Productos.productos[index]);
      },
    );
  }
}
      
      

