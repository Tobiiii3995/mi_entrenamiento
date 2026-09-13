class Ejercicio {
  final String id;
  String nombre;
  final int series;
  final String repeticiones;
  final bool llevaPeso;
  final double? pesoAnterior;
  final int descansoSegundos;
  final String? urlMedia;

  Ejercicio({
    required this.id,
    required this.nombre,
    required this.series,
    required this.repeticiones,
    required this.llevaPeso,
    this.pesoAnterior,
    required this.descansoSegundos,
    this.urlMedia,
  });
}