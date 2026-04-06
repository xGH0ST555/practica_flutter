# practica_1

Una aplicación Flutter de e-commerce simple con funcionalidades de autenticación, visualización de productos y navegación.

## 📋 Descripción

Esta aplicación es un proyecto de práctica que implementa una tienda en línea básica con las siguientes características principales:
- Autenticación de usuarios simulada
- Visualización de catálogo de productos
- Navegación intuitiva con bottom navigation bar
- Perfil de usuario con opción de logout
- Diseño moderno con fuentes personalizadas (Cal Sans)

## 🚀 Características

### Autenticación
- Pantalla de login con validación básica
- Usuarios de prueba hardcodeados
- Persistencia de sesión durante la ejecución
- Mensajes de error para credenciales incorrectas

### Catálogo de Productos
- Lista de productos con imágenes, nombres, precios y descripciones
- Cards interactivas que navegan a vista detallada
- 8 productos de ejemplo incluidos

### Navegación
- Bottom navigation bar con 3 pestañas (Home, Cart, Profile)
- Rutas nombradas para navegación consistente
- Transiciones suaves entre pantallas

### Perfil de Usuario
- Visualización de información del usuario autenticado
- Avatar con imagen de red
- Botón de logout que regresa a pantalla de login

## 🏗️ Arquitectura

### Estructura del Proyecto
```
lib/
├── main.dart                 # Punto de entrada
├── models/
│   ├── productos.dart        # Modelo de productos
│   └── user.dart            # Modelo de usuario
├── screens/
│   ├── login_screen.dart    # Pantalla de login
│   ├── home_screen.dart     # Pantalla principal con navegación
│   ├── product_visualizer.dart # Vista detallada de producto
│   ├── cart_screen.dart     # Pantalla del carrito (placeholder)
│   └── profile_screen.dart  # Pantalla de perfil
├── services/
│   └── auth_service.dart    # Servicio de autenticación
├── routes/
│   └── app_routes.dart      # Configuración de rutas
└── themes/
    ├── app_theme.dart      # Tema de la aplicación
    └── exports.dart        # Exportaciones de temas
```

### Modelos de Datos

#### Productos
```dart
// Estructura de un producto
{
  'imagen': 'URL de imagen',
  'nombre': 'Nombre del producto',
  'precio': 99.99,
  'descripcion': 'Descripción breve'
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

## Diseño y UI
 
### Tema General
- **Tema oscuro** con `ColorScheme.dark()` y color primario negro
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

**Animaciones y Estados:**
- Toggle de visibilidad de contraseña con cambio de ícono
- `SnackBar` rojo para errores de login

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
- `Column` con imagen y detalles

**Elementos Visuales:**
- **Imagen del producto**:
  - Altura responsiva: `MediaQuery.of(context).size.height * 0.4`
  - `BoxFit.cover` para mantener proporción
  - Indicador de carga y manejo de errores
- **Información del producto**:
  - Nombre: Tamaño 24px, negrita
  - Precio: Tamaño 20px, color de acento
  - Descripción: Texto normal con padding
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

### Componentes Reutilizables

#### Cardproductos
- `Card` con `InkWell` para interacción
- Imagen pequeña con `BoxFit.cover`
- Nombre y precio en fila
- Padding interno de 8px
- Bordes redondeados

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
- **Google Fonts**: Para fuentes personalizadas
- **Material Design**: Componentes de UI

## Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^8.0.2

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
- `/login`: Pantalla de login
- `/`: Pantalla principal (Home)
- `/product`: Visualizador de producto
- `/cart`: Carrito de compras
- `/profile`: Perfil de usuario

### Tema
El tema se configura en `lib/themes/app_theme.dart` con:
- ColorScheme oscuro
- Fuente Cal Sans
- Estilos personalizados

## Funcionalidades

### Implementadas
- Autenticación simulada
- Visualización de productos
- Navegación con bottom bar
- Perfil de usuario
- Diseño responsivo
- Fuentes personalizadas

### Pendientes/Limitadas
- Funcionalidad completa del carrito
- Persistencia de datos
- Validación avanzada de formularios
- Integración con backend real

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

**Última actualización**: Abril 2026
**Versión**: 0.1.0+1
