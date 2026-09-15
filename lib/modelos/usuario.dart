class Usuario {
  final String id;
  String nombre;
  int edad;
  double altura;
  double peso;
  String objetivo;
  String correo;
  String rol;
  String fotoUrl;

  Usuario({
    required this.id,
    required this.nombre,
    required this.edad,
    required this.altura,
    required this.peso,
    required this.objetivo,
    required this.correo,
    required this.rol,
    this.fotoUrl = '',
  });
}