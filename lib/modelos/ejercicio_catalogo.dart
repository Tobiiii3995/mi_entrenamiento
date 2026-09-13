class EjercicioCatalogo {
  final String id;
  final String creadorId;

  String nombre;
  String descripcion;
  bool llevaPeso;
  String grupoMuscular;
  String instrucciones;

  EjercicioCatalogo({
    required this.id,
    required this.creadorId,
    required this.nombre,
    required this.descripcion,
    required this.llevaPeso,
    required this.grupoMuscular,
    required this.instrucciones,
  });
}