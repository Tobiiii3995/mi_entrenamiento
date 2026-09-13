import 'package:flutter/material.dart';

import '../modelos/entrenamiento.dart';
import '../modelos/rutina.dart';

class DetalleEntrenamientoPagina extends StatelessWidget {
  final Entrenamiento entrenamiento;
  final Rutina rutina;

  const DetalleEntrenamientoPagina({
    super.key,
    required this.entrenamiento,
    required this.rutina,
  });

  String fechaTexto(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');

    return '$dia/$mes/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    final realizados = entrenamiento.ejerciciosCompletados;
    final total = entrenamiento.totalEjercicios;
    final parcial = entrenamiento.esParcial;

    return Scaffold(
      appBar: AppBar(
        title: Text('Día ${rutina.dia}'),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
          children: [
            Text(
              rutina.nombre,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Realizado el ${fechaTexto(entrenamiento.fecha)}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 18),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      parcial
                          ? Icons.pie_chart_outline
                          : Icons.check_circle,
                      size: 32,
                      color:
                          parcial ? Colors.orange : Colors.green,
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            parcial
                                ? 'Rutina parcial'
                                : 'Rutina completa',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            '$realizados de $total ejercicios realizados',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            ...entrenamiento.ejercicios.map((ejercicio) {
              final realizado =
                  ejercicio.realizadoValido;

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            realizado
                                ? Icons.check_circle
                                : Icons.cancel_outlined,
                            color: realizado
                                ? Colors.green
                                : Colors.grey,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              ejercicio.nombreEjercicio,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: realizado
                                    ? null
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Text(
                        '${ejercicio.series} series × ${ejercicio.repeticiones}',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              realizado ? null : Colors.grey,
                        ),
                      ),

                      if (!realizado) ...[
                        const SizedBox(height: 8),

                        Text(
                          ejercicio.completado &&
                                  ejercicio.llevaPeso &&
                                  (ejercicio.pesoUsado == null ||
                                      ejercicio.pesoUsado! <= 0)
                              ? 'No realizado · faltó registrar un peso válido'
                              : 'No realizado',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],

                      if (realizado &&
                          ejercicio.llevaPeso) ...[
                        const SizedBox(height: 8),

                        Text(
                          'Peso: ${ejercicio.pesoUsado!.toStringAsFixed(1)} kg',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],

                      if (ejercicio.nota.trim().isNotEmpty) ...[
                        const SizedBox(height: 10),

                        Text(
                          'Nota: ${ejercicio.nota}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
