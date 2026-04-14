
class User {
  final String email;
  final String password;
  final String name;
  final String? fotoPerfil;   
  final String? fondoPerfil;  

  User({
    required this.email,
    required this.password,
    required this.name,
    this.fotoPerfil,
    this.fondoPerfil,
  });
}