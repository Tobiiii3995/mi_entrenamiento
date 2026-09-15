class AlumnoProfesor {
  final String id;
  final String nombre;
  final String correo;
  final String fotoUrl;

  AlumnoProfesor({
    required this.id,
    required this.nombre,
    required this.correo,
    this.fotoUrl = '',
  });
}