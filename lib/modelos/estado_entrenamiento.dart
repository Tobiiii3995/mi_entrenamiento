class EstadoEjercicioRutina {
  final String ejercicioId;
  final String nombreEjercicio;

  bool completado;
  String peso;
  String nota;

  EstadoEjercicioRutina({
    required this.ejercicioId,
    required this.nombreEjercicio,
    this.completado = false,
    this.peso = '',
    this.nota = '',
  });
}

class EntrenamientoEnCurso {
  final String id;
  final String alumnoId;
  final String rutinaId;
  final DateTime fechaInicio;

  final List<EstadoEjercicioRutina> ejercicios;

  EntrenamientoEnCurso({
    required this.id,
    required this.alumnoId,
    required this.rutinaId,
    required this.fechaInicio,
    required this.ejercicios,
  });
}