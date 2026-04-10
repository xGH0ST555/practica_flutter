# practica_1

Una aplicación Flutter de e-commerce simple con funcionalidades de autenticación, visualización de productos y navegación.

## Descripción

Esta aplicación es un proyecto de práctica que implementa una tienda en línea básica con las siguientes características principales:
- Autenticación de usuarios simulada
- Visualización de catálogo de productos desde API externa (dummyjson)
- Navegación intuitiva con bottom navigation bar
- Perfil de usuario con opción de logout
- Diseño moderno con fuentes personalizadas (Cal Sans)
- Integración con API REST para datos dinámicos

## Características

### Autenticación
- Pantalla de login con validación básica
- Pantalla de registro de nuevos usuarios
- Usuarios de prueba hardcodeados
- Persistencia de sesión durante la ejecución
- Mensajes de error para credenciales incorrectas
- Base de datos SQLite para almacenamiento de usuarios

### Catálogo de Productos
- Lista dinámica de productos obtenidos desde dummyjson API
- Cards interactivas que navegan a vista detallada
- Indicador de carga mientras se obtienen los datos
- Manejo de errores de conexión
- Más de 100 productos disponibles con imágenes, nombres, precios y descripciones

### Carrito de Compras
- Gestión de productos en carrito con SQLite
- Agregar productos al carrito
- Actualizar cantidades

### Navegación
- Bottom navigation bar con 3 pestañas (Home, Cart, Profile)
- Rutas nombradas para navegación consistente
- Transiciones suaves entre pantallas
- Pantalla de login accesible desde registro

### Perfil de Usuario
- Visualización de información del usuario autenticado
- Avatar con imagen de red
- Dos vistas de perfil disponibles
- Botón de logout que regresa a pantalla de login

## Arquitectura

### Estructura del Proyecto
```
lib/
├── main.dart                 # Punto de entrada
├── db/
│   └── database_helper.dart  # Helper para SQLite database
├── models/
│   ├── productos.dart        # Modelo de productos y clase Producto
│   └── user.dart            # Modelo de usuario
├── screens/
│   ├── login_screen.dart    # Pantalla de login
│   ├── registrar_usuario.dart # Pantalla de registro de usuario
│   ├── home_screen.dart     # Pantalla principal con navegación
│   ├── product_visualizer.dart # Vista detallada de producto
│   ├── cart_screen.dart     # Pantalla del carrito
│   ├── profile_screen.dart  # Pantalla de perfil
│   └── profille_visualizer.dart # Visualizador alternativo de perfil
├── services/
│   ├── auth_service.dart    # Servicio de autenticación
│   ├── products_service.dart # Servicio para consumir API de productos
│   ├── carrito_service.dart # Servicio para gestión del carrito
│   └── usuario_service.dart # Servicio para gestión de usuarios
├── routes/
│   └── app_routes.dart      # Configuración de rutas
└── themes/
    ├── app_theme.dart      # Tema de la aplicación
    └── exports.dart        # Exportaciones de temas
```

### Modelos de Datos

#### Productos
```dart
class Producto {
  final int id;
  final String nombre;
  final double precio;
  final String imagen;
  final String descripcion;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.imagen,
    required this.descripcion,
  });

  // Factory constructor para crear desde JSON de dummyjson API
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as int,
      nombre: json['title'] ?? 'Producto sin nombre',
      precio: (json['price'] as num).toDouble(),
      imagen: json['thumbnail'] ?? 'https://via.placeholder.com/300',
      descripcion: json['description'] ?? 'Sin descripción',
    );
  }

  // Método para compatibilidad con widgets existentes
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'imagen': imagen,
      'descripcion': descripcion,
    };
  }
}
```

#### Usuario
```dart
class User {
  final String email;
  final String password;
  final String name;
}
```

### Servicios

#### AuthService
- `login(String email, String password)`: Autentica usuario
- `currentUser`: Getter para usuario actual
- `logout()`: Cierra sesión

#### ProductsService
- `getProductos()`: Obtiene todos los productos desde dummyjson API
- `getProductoById(int id)`: Obtiene un producto específico por ID
- `searchByCategory(String category)`: Busca productos por categoría
- Manejo de errores de conexión y timeouts

#### CarritoService
- `agregar(Producto producto)`: Agrega producto al carrito
- `obtenerCarrito()`: Obtiene lista de productos en carrito
- `actualizarCantidad(int productoId, int cantidad)`: Actualiza cantidad de producto
- `eliminarProducto(int productoId)`: Elimina producto del carrito

#### UsuarioService
- `insertar(User user)`: Inserta nuevo usuario en base de datos
- `register(String name, String email, String password)`: Registra usuario con validación
- `login(String email, String password)`: Autentica usuario desde base de datos

## Diseño y UI
 
### Tema General
- **Tema personalizado** con color primario negro y elementos claros
- **Fuente personalizada**: Cal Sans (Google Fonts) aplicada a todos los textos
- **Bordes redondeados**: Radio de 12px en inputs y botones
- **Espaciado consistente**: Padding de 16px en contenedores principales
- **Colores principales**:
  - Fondo: Negro oscuro
  - Texto: Blanco
  - Acentos: Negro para botones primarios

### Detalles de Diseño por Pantalla

#### Login Screen (`/login`)
**Layout Principal:**
- `Column` con imagen superior y formulario inferior
- Imagen de fondo ocupa parte superior con altura fija de 350px
- Formulario centrado en el espacio restante

**Elementos Visuales:**
- **Imagen de fondo**: Imagen de red con `ClipPath` personalizado
  - `BottomCurveClipper`: Curva cuadrática en la parte inferior
  - `BoxFit.cover` para cubrir todo el ancho
- **Texto "Iniciar sesión"**: 
  - Tamaño 45px, negrita
  - Fuente Cal Sans
  - Padding vertical de 8px
- **Campos de texto**:
  - `TextField` con `OutlineInputBorder`
  - Prefijos: `Icons.email_outlined` y `Icons.lock_outline_rounded`
  - Estilo de fuente: Cal Sans para texto y labels
  - Sufijo en contraseña: Toggle de visibilidad
- **Botón de login**:
  - `ElevatedButton` de ancho completo
  - Fondo negro, texto blanco
  - Fuente Cal Sans
- **Enlace a registro**: Texto clickable para navegar a pantalla de registro

**Animaciones y Estados:**
- Toggle de visibilidad de contraseña con cambio de ícono
- `SnackBar` rojo para errores de login

#### Registrar Usuario Screen (`/`)
**Layout Principal:**
- Formulario de registro con campos para nombre, email y contraseña
- Diseño similar al login con imagen de fondo

**Elementos Visuales:**
- Campos de texto con validación
- Botón de registro
- Enlace para volver al login

#### Home Screen (`/`)
**Layout Principal:**
- `Scaffold` con `BottomNavigationBar`
- `IndexedStack` para mantener estado de pestañas
- `AppBar` con título animado

**Bottom Navigation Bar:**
- 3 elementos: Home, Cart, Profile
- Íconos: `Icons.home`, `Icons.shopping_cart`, `Icons.person`
- Animación de transición entre índices
- Color activo: Tema primario

**Pestaña Home:**
- `ListView.builder` con productos
- Cards usando `Cardproductos` widget
- Espaciado vertical entre cards

**AppBar Animado:**
- Título cambia según pestaña activa
- Animación de `AnimatedSwitcher` con fade

#### Product Visualizer (`/product`)
**Layout Principal:**
- `Scaffold` con `AppBar` simple
- `Column` con imagen, detalles y botón de acción en la parte inferior
- Uso de `Spacer()` para empujar el botón hacia el final de la vista

**Elementos Visuales:**
- **Imagen del producto**:
  - Altura responsiva: `MediaQuery.of(context).size.height * 0.4`
  - `BoxFit.cover` para mantener proporción
  - Indicador de carga y manejo de errores
- **Información del producto**:
  - Nombre: Tamaño 24px, negrita
  - Precio: Tamaño 20px, color de acento
  - Descripción: Texto normal con padding
- **Botón de acción**:
  - `ElevatedButton.icon` anclado en la parte inferior
  - Fondo negro, texto blanco
  - Añade experiencia de carrito aunque la lógica completa de carrito no está implementada aún
- **Espaciado**: Padding horizontal de 16px

**Responsive Design:**
- Imagen se adapta al ancho de pantalla
- Texto se ajusta automáticamente

#### Cart Screen (`/cart`)
**Estado Actual:**
- Placeholder simple
- `Center` con texto "No hay productos en el carrito"
- Diseño preparado para futura implementación

**Diseño Futuro Planeado:**
- Lista de productos en carrito
- Controles de cantidad
- Total y botón de checkout

#### Profile Screen (`/profile`)
**Layout Principal:**
- `Scaffold` sin `AppBar`
- `Padding` de 16px alrededor
- `Row` con `MainAxisAlignment.spaceBetween`

**Elementos Visuales:**
- **Información del usuario**:
  - `ListTile` expandido para ocupar espacio disponible
  - `CircleAvatar` con imagen de red (Pinterest)
  - Nombre: 24px, negrita
  - Email: Subtítulo normal
- **Botón de logout**:
  - `IconButton` con `Icons.logout`
  - Tamaño 28px
  - Acción: Logout y navegación a login

**Colores y Estilos:**
- Avatar: Imagen circular de red
- Texto: Cal Sans para consistencia
- Icono: Tema por defecto de Material Design

#### Profille Visualizer (`/profileVisualizer`)
**Layout Principal:**
- `Scaffold` con imagen de fondo curvada
- `Stack` para posicionar elementos
- Avatar centrado sobre la imagen de fondo

**Elementos Visuales:**
- **Imagen de fondo**: Imagen de red con `ClipPath` personalizado
- **Avatar**: `CircleAvatar` grande con borde blanco
- **Nombre del usuario**: Texto centrado debajo del avatar
- Diseño visual alternativo al perfil estándar

### Componentes Reutilizables

#### Cardproductos
- `Card` con `InkWell` para interacción
- Imagen pequeña con `BoxFit.cover`
- Nombre y precio en fila
- Padding interno de 8px
- Bordes redondeados
- Ya no incluye un botón explícito de añadir al carrito en cada card; la interacción se centra en abrir la vista de producto

### Animaciones y Transiciones
- **Bottom Navigation**: Transición suave entre pestañas
- **AppBar Title**: `AnimatedSwitcher` con fade transition
- **Toggle Password**: Cambio instantáneo de ícono
- **Navigation**: `pushReplacementNamed` para login/logout

### Responsive Design
- Uso de `MediaQuery` para alturas dinámicas
- `double.infinity` para anchos completos
- `Expanded` widgets para distribución de espacio
- Padding consistente en todos los lados

### Accesibilidad
- Labels descriptivos en campos de texto
- Íconos semánticos en botones
- Contraste adecuado entre texto y fondo
- Tamaños de fuente legibles (mínimo 16px para inputs)

### Pantallas Principales

#### Login Screen
- Imagen de fondo con curva inferior personalizada
- Campos de email y contraseña con validación
- Botón de login negro con texto blanco
- Toggle para mostrar/ocultar contraseña

#### Home Screen
- Bottom navigation bar con animaciones
- Lista de productos en cards
- Navegación fluida entre pestañas

#### Product Visualizer
- Vista detallada con imagen grande
- Información completa del producto
- Diseño adaptativo

## Tecnologías Utilizadas

- **Flutter**: Framework principal
- **Dart**: Lenguaje de programación
- **SQLite**: Base de datos local
- **Google Fonts**: Para fuentes personalizadas
- **Material Design**: Componentes de UI
- **HTTP Package**: Para consumir APIs REST
- **dummyjson API**: API externa para datos de productos

## Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^8.0.2
  http: ^1.2.0
  sqflite: ^2.3.2
  path: ^1.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

## Instalación y Ejecución

### Prerrequisitos
- Flutter SDK instalado (versión ^3.11.0)
- Dart SDK
- Un emulador o dispositivo físico

### Pasos de Instalación
1. Clona el repositorio
2. Navega al directorio del proyecto
3. Instala dependencias:
   ```bash
   flutter pub get
   ```
4. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

## Usuarios de Prueba

| Email | Contraseña | Nombre |
|-------|------------|--------|
| admin@gmail.com | admin123 | Admin User |
| user@gmail.com | user123 | Normal User |

## Configuración

### Rutas
Las rutas están definidas en `lib/routes/app_routes.dart`:
- `/`: Pantalla de registro de usuario
- `/login`: Pantalla de login
- `/home`: Pantalla principal (Home)
- `/product`: Visualizador de producto
- `/cart`: Carrito de compras
- `/profile`: Perfil de usuario
- `/profileVisualizer`: Visualizador alternativo de perfil

### Tema
El tema se configura en `lib/themes/app_theme.dart` con:
- ColorScheme oscuro
- Fuente Cal Sans
- Estilos personalizados

## API Integration

### dummyjson API
La aplicación consume datos desde [dummyjson](https://dummyjson.com), una API gratuita que proporciona datos de prueba para desarrollo.

#### Endpoints Utilizados
- `GET https://dummyjson.com/products` - Obtiene todos los productos
- `GET https://dummyjson.com/products/{id}` - Obtiene producto específico
- `GET https://dummyjson.com/products/category/{category}` - Productos por categoría

#### Estructura de Datos
Los productos incluyen:
- `id`: Identificador único
- `title`: Nombre del producto
- `price`: Precio en dólares
- `thumbnail`: URL de imagen miniatura
- `description`: Descripción detallada
- `category`: Categoría del producto
- `brand`: Marca del producto

#### Manejo de Estados
- **Loading**: Indicador circular mientras se cargan datos
- **Error**: Mensaje de error con ícono cuando falla la conexión
- **Success**: Lista de productos renderizada dinámicamente

## Funcionalidades

### Implementadas
- Autenticación simulada y registro de usuarios
- Visualización de productos desde API externa
- Integración con dummyjson API para catálogo dinámico
- Gestión completa del carrito con persistencia en SQLite
- Navegación con bottom bar
- Perfil de usuario con dos vistas
- Diseño responsivo
- Fuentes personalizadas
- Manejo de estados de carga y errores
- Base de datos SQLite para usuarios y carrito

### Pendientes/Limitadas
- Búsqueda y filtrado avanzado de productos por categoría
- Validación más robusta de formularios
- Notificaciones push

## Problemas Conocidos

- El carrito es solo un placeholder sin lógica
- No hay persistencia entre sesiones
- Autenticación local únicamente

## Contribución

Este es un proyecto de práctica. Para mejoras:
1. Fork el proyecto
2. Crea una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

## Licencia

Este proyecto es de uso educativo y no tiene licencia específica.

---

**Última actualización**: Abril 10, 2026  
**Versión**: 0.1.0+1
