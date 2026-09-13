import 'package:flutter/material.dart';

import '../modelos/entrenamiento.dart';
import '../servicios/datos_app.dart';

class HistorialEjercicioPagina extends StatelessWidget {
  final String ejercicioId;
  final String nombreEjercicio;

  const HistorialEjercicioPagina({
    super.key,
    required this.ejercicioId,
    required this.nombreEjercicio,
  });

  String fechaTexto(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');

    return '$dia/$mes/${fecha.year}';
  }

  List<_RegistroHistoricoEjercicio> _obtenerHistorial() {
    final registros = <_RegistroHistoricoEjercicio>[];

    for (final entrenamiento
        in DatosApp.entrenamientosRealizados) {
      for (final ejercicio in entrenamiento.ejercicios) {
        if (ejercicio.ejercicioId == ejercicioId) {
          registros.add(
            _RegistroHistoricoEjercicio(
              fecha: entrenamiento.fecha,
              registro: ejercicio,
            ),
          );
        }
      }
    }

    registros.sort(
      (a, b) => b.fecha.compareTo(a.fecha),
    );

    return registros;
  }

  @override
  Widget build(BuildContext context) {
    final historial = _obtenerHistorial();

    final pesosValidos = historial
        .where(
          (registro) =>
              registro.registro.llevaPeso &&
              registro.registro.pesoUsado != null,
        )
        .map(
          (registro) => registro.registro.pesoUsado!,
        )
        .toList();

    double? ultimoPeso;

    for (final registro in historial) {
      if (registro.registro.llevaPeso &&
          registro.registro.pesoUsado != null) {
        ultimoPeso = registro.registro.pesoUsado;
        break;
      }
    }

    double? pesoMaximo;

    if (pesosValidos.isNotEmpty) {
      pesoMaximo = pesosValidos.reduce(
        (actual, siguiente) =>
            siguiente > actual ? siguiente : actual,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(nombreEjercicio),
      ),
      body: SafeArea(
        top: false,
        child: historial.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Todavía no hay registros para este ejercicio.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  80,
                ),
                children: [
                  const Text(
                    'Progreso del ejercicio',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    nombreEjercicio,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _TarjetaDato(
                          titulo: 'Entrenamientos',
                          valor: historial.length.toString(),
                          icono: Icons.event_available,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _TarjetaDato(
                          titulo: 'Último peso',
                          valor: ultimoPeso == null
                              ? '—'
                              : '${ultimoPeso.toStringAsFixed(1)} kg',
                          icono: Icons.fitness_center,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _TarjetaDato(
                    titulo: 'Peso máximo registrado',
                    valor: pesoMaximo == null
                        ? '—'
                        : '${pesoMaximo.toStringAsFixed(1)} kg',
                    icono: Icons.emoji_events_outlined,
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Historial',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ...historial.map(
                    (item) {
                      final registro = item.registro;

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 20,
                                  ),

                                  const SizedBox(width: 8),

                                  Text(
                                    fechaTexto(item.fecha),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: _DatoSimple(
                                      titulo: 'Series',
                                      valor:
                                          registro.series.toString(),
                                    ),
                                  ),
                                  Expanded(
                                    child: _DatoSimple(
                                      titulo: 'Reps',
                                      valor:
                                          registro.repeticiones,
                                    ),
                                  ),
                                ],
                              ),

                              if (registro.llevaPeso) ...[
                                const SizedBox(height: 14),

                                _DatoSimple(
                                  titulo: 'Peso utilizado',
                                  valor:
                                      registro.pesoUsado == null
                                          ? 'Sin registro'
                                          : '${registro.pesoUsado!.toStringAsFixed(1)} kg',
                                ),
                              ],

                              if (registro.nota.trim().isNotEmpty) ...[
                                const SizedBox(height: 14),

                                const Divider(),

                                const SizedBox(height: 8),

                                const Text(
                                  'Nota',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  registro.nota,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class _RegistroHistoricoEjercicio {
  final DateTime fecha;
  final RegistroEjercicio registro;

  _RegistroHistoricoEjercicio({
    required this.fecha,
    required this.registro,
  });
}

class _TarjetaDato extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;

  const _TarjetaDato({
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icono,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              valor,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatoSimple extends StatelessWidget {
  final String titulo;
  final String valor;

  const _DatoSimple({
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}