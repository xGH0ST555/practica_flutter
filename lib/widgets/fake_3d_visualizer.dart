import 'package:flutter/material.dart';

class Fake3DVisualizer extends StatefulWidget {
  final List<String> images;
  final double height;
  final double width;

  const Fake3DVisualizer({
    Key? key,
    required this.images,
    this.height = 300,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  State<Fake3DVisualizer> createState() => _Fake3DVisualizerState();
}

class _Fake3DVisualizerState extends State<Fake3DVisualizer>
    with TickerProviderStateMixin {
  late int _currentIndex;
  late AnimationController _rotationController;
  late AnimationController _imageController;
  Offset? _lastDragPosition;
  bool _isAutoRotating = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;

    // Controlador para rotación automática
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();

    // Controlador para animación de cambio de imagen
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _setupAutoRotation();
  }

  void _setupAutoRotation() {
    _rotationController.addListener(() {
      if (!_isAutoRotating || widget.images.isEmpty) return;

      final newIndex =
          (_rotationController.value * widget.images.length).floor() %
              widget.images.length;

      if (newIndex != _currentIndex) {
        setState(() {
          _currentIndex = newIndex;
        });
        _imageController.forward(from: 0.0);
      }
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _isAutoRotating = false;
    _rotationController.stop();

    final delta = details.delta.dx;
    const sensitivity = 20.0;

    if (delta.abs() > sensitivity) {
      setState(() {
        if (delta > 0) {
          // Deslizar a la derecha -> imagen anterior
          _currentIndex = (_currentIndex - 1) % widget.images.length;
          if (_currentIndex < 0) _currentIndex = widget.images.length - 1;
        } else {
          // Deslizar a la izquierda -> siguiente imagen
          _currentIndex = (_currentIndex + 1) % widget.images.length;
        }
      });
      _imageController.forward(from: 0.0);
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    // Reanudar rotación automática después de 2 segundos de inactividad
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isAutoRotating = true;
          _rotationController.repeat();
        });
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.grey[200],
        ),
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
        ),
      );
    }

    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Column(
        children: [
          // Contenedor de imagen con efecto de rotación
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.grey[100],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Imagen con animación de fade
                FadeTransition(
                  opacity: _imageController.drive(
                    CurveTween(curve: Curves.easeOut).chain(
                      Tween<double>(begin: 0.85, end: 1.0),
                    ),
                  ),
                  child: ScaleTransition(
                    scale: _imageController.drive(
                      CurveTween(curve: Curves.easeOutCubic).chain(
                        Tween<double>(begin: 0.92, end: 1.0),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        widget.images[_currentIndex],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // Indicador de rotación (pequeño ícono en la esquina)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.rotate_right,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Indicadores de posición
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Texto informativo
              Text(
                '${_currentIndex + 1}/${widget.images.length}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              // Barras de indicador
              Expanded(
                child: SizedBox(
                  height: 4,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.images.length,
                    itemBuilder: (context, index) {
                      final isActive = index == _currentIndex;
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: isActive
                                ? Colors.black
                                : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Texto de instrucción
              const Text(
                'Desliza',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
