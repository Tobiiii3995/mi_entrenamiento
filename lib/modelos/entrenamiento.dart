class RegistroEjercicio {
  final String ejercicioId;
  final String nombreEjercicio;

  final int series;
  final String repeticiones;

  final bool llevaPeso;
  final double? pesoUsado;

  final String nota;
  final bool completado;

  RegistroEjercicio({
    required this.ejercicioId,
    required this.nombreEjercicio,
    required this.series,
    required this.repeticiones,
    required this.llevaPeso,
    this.pesoUsado,
    required this.nota,
    required this.completado,
  });

  bool get realizadoValido {
    if (!completado) {
      return false;
    }

    if (!llevaPeso) {
      return true;
    }

    return pesoUsado != null && pesoUsado! > 0;
  }
}

class Entrenamiento {
  final String id;
  final String rutinaId;
  final DateTime fecha;

  final List<RegistroEjercicio> ejercicios;

  // En una sesión guardada, true significa que la rutina fue cerrada.
  // Puede haber quedado completa o parcial.
  final bool completado;

  Entrenamiento({
    required this.id,
    required this.rutinaId,
    required this.fecha,
    required this.ejercicios,
    required this.completado,
  });

  int get ejerciciosCompletados =>
      ejercicios.where((item) => item.realizadoValido).length;

  int get totalEjercicios => ejercicios.length;

  bool get esParcial =>
      completado &&
      totalEjercicios > 0 &&
      ejerciciosCompletados < totalEjercicios;

  bool get esCompleto =>
      completado &&
      totalEjercicios > 0 &&
      ejerciciosCompletados == totalEjercicios;

  String get estadoTexto {
    if (!completado) {
      return 'En curso';
    }

    if (esParcial) {
      return 'Parcial';
    }

    return 'Completa';
  }
}
