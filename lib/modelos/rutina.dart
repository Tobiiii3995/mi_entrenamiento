import 'ejercicio.dart';

class Rutina {
  final String id;
  final int dia;
  String nombre;
  final List<Ejercicio> ejercicios;

  Rutina({
    required this.id,
    required this.dia,
    required this.nombre,
    required this.ejercicios,
  });
}