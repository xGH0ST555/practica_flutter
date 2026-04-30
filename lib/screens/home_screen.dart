import 'package:flutter/material.dart';
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
        onTap: (
          index) {
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

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            style: GoogleFonts.calSans(),
            decoration: InputDecoration(
              hintText: 'Buscar productos...',
              hintStyle: GoogleFonts.calSans(),
              labelStyle: GoogleFonts.calSans(),
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
        ),
        Expanded(
          child: FutureBuilder(
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
              //Éxito - Mostrar productos filtrados
              if (snapshot.hasData) {
                final productos = snapshot.data!;
                
                final productosFiltrados = productos.where((p) {
                  return p.nombre.toLowerCase().contains(_searchQuery) ||
                         p.descripcion.toLowerCase().contains(_searchQuery);
                }).toList();
                
                if (productos.isEmpty) {
                  return const Center(
                    child: Text('No hay productos disponibles'),
                  );
                }

                if (productosFiltrados.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron productos'),
                  );
                }

                return ListView.builder(
                  itemCount: productosFiltrados.length,
                  itemBuilder: (context, index) {
                    return Cardproductos(
                      productos: productosFiltrados[index].toMap(),
                    );
                  },
                );
              }

              return const Center(child: Text('No hay datos'));
            },
          ),
        ),
      ],
    );
  }
}

/*class HomeScreenState extends State<HomeScreen>{
  late Future<List<Producto>> _productosFuture;
  List<Producto> _allproductos = [];
  List<Producto> _filteredproductos = [];
  final TextEditingController _serchController = TextEditingController();
  
  @override
  void initState(){
    super.initState();
    _productosFuture = ProductsService.getProductos();
  }
  
  @override
   void _filtrar(String query){
    setState(() {
      _filteredproductos = _allproductos.where((p) => p.nombre.toLowerCase().contains(query.toLowerCase())).toList();
    });
   }

  @override
  void dispose(){
    _serchController.dispose();
    super.dispose();
  }
}*/
      
      

