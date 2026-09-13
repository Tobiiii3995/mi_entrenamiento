import 'ejercicio_catalogo.dart';

class EjercicioRutinaEditor {
  final String idRelacion;
  final EjercicioCatalogo ejercicio;

  int orden;
  int series;
  String repeticiones;
  int descansoSegundos;
  String observaciones;

  EjercicioRutinaEditor({
    required this.idRelacion,
    required this.ejercicio,
    required this.orden,
    required this.series,
    required this.repeticiones,
    required this.descansoSegundos,
    required this.observaciones,
  });
}

class RutinaEditor {
  final String id;
  final String creadorId;

  String nombre;
  String descripcion;

  final List<EjercicioRutinaEditor> ejercicios;

  RutinaEditor({
    required this.id,
    required this.creadorId,
    required this.nombre,
    required this.descripcion,
    required this.ejercicios,
  });
}