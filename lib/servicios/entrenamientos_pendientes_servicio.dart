import 'package:cloud_firestore/cloud_firestore.dart';

import '../modelos/ejercicio.dart';
import '../modelos/estado_entrenamiento.dart';
import '../modelos/entrenamiento.dart';
import '../modelos/rutina.dart';
import '../repositorios/entrenamiento_en_curso_repositorio.dart';
import '../repositorios/entrenamiento_repositorio.dart';
import 'base_datos_servicio.dart';
import 'datos_app.dart';

class EntrenamientosPendientesServicio {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static String? _mensajePendiente;

  static String? consumirMensaje() {
    final mensaje = _mensajePendiente;
    _mensajePendiente = null;
    return mensaje;
  }

  static Future<void> finalizarPendientesDeDiasAnteriores({
    required String alumnoId,
  }) async {
    final cursoRepositorio =
        EntrenamientoEnCursoRepositorio(
      BaseDatosServicio.db,
    );

    final entrenamientoRepositorio =
        EntrenamientoRepositorio(
      BaseDatosServicio.db,
    );

    final pendientes =
        await cursoRepositorio
            .obtenerPendientesAnteriores(
      alumnoId,
    );

    if (pendientes.isEmpty) {
      return;
    }

    int cerradas = 0;
    int parciales = 0;
    int descartadas = 0;

    for (final pendiente in pendientes) {
      final rutina = await _obtenerRutinaAsignada(
        pendiente.rutinaId,
      );

      if (rutina == null) {
        // Si por algún motivo no podemos reconstruir la rutina,
        // no borramos el pendiente para no perder información.
        continue;
      }

      final registros = <RegistroEjercicio>[];

      for (final ejercicio in rutina.ejercicios) {
        EstadoEjercicioRutina? estado;

        for (final item in pendiente.ejercicios) {
          if (item.ejercicioId == ejercicio.id) {
            estado = item;
            break;
          }
        }

        bool realizado = false;
        double? pesoUsado;
        String nota = '';

        if (estado != null) {
          nota = estado.nota.trim();

          if (estado.completado) {
            if (ejercicio.llevaPeso) {
              final peso = double.tryParse(
                estado.peso
                    .replaceAll(',', '.')
                    .trim(),
              );

              if (peso != null && peso > 0) {
                realizado = true;
                pesoUsado = peso;
              }
            } else {
              realizado = true;
            }
          }
        }

        registros.add(
          RegistroEjercicio(
            ejercicioId: ejercicio.id,
            nombreEjercicio: ejercicio.nombre,
            series: ejercicio.series,
            repeticiones: ejercicio.repeticiones,
            llevaPeso: ejercicio.llevaPeso,
            pesoUsado: pesoUsado,
            nota: nota,
            completado: realizado,
          ),
        );
      }

      final realizados =
          registros.where((item) => item.completado).length;

      if (realizados == 0) {
        await cursoRepositorio.eliminar(
          pendiente.id,
        );

        DatosApp.eliminarEntrenamientoEnCurso(
          rutina.id,
        );

        descartadas++;
        continue;
      }

      final entrenamiento = Entrenamiento(
        id: 'auto_${pendiente.id}_${DateTime.now().microsecondsSinceEpoch}',
        rutinaId: rutina.id,
        // Conservamos el día en que realmente comenzó la sesión.
        fecha: pendiente.fechaInicio,
        ejercicios: registros,
        // true significa que la sesión quedó cerrada/finalizada.
        completado: true,
      );

      await entrenamientoRepositorio
          .guardarEntrenamientoFinalizado(
        entrenamiento: entrenamiento,
        alumnoId: alumnoId,
        entrenamientoEnCursoId: pendiente.id,
        rutinaNombre: rutina.nombre,
      );

      DatosApp.entrenamientosRealizados.add(
        entrenamiento,
      );

      DatosApp.eliminarEntrenamientoEnCurso(
        rutina.id,
      );

      cerradas++;

      if (entrenamiento.esParcial) {
        parciales++;
      }
    }

    if (cerradas == 0 && descartadas == 0) {
      return;
    }

    if (cerradas == 1 && descartadas == 0) {
      _mensajePendiente = parciales == 1
          ? 'Se cerró automáticamente una rutina pendiente del día anterior como parcial.'
          : 'Se cerró automáticamente una rutina pendiente del día anterior.';
      return;
    }

    if (cerradas == 0 && descartadas == 1) {
      _mensajePendiente =
          'Se descartó una rutina pendiente del día anterior porque no tenía ningún ejercicio completado con datos válidos.';
      return;
    }

    final partes = <String>[];

    if (cerradas > 0) {
      partes.add(
        'Se cerraron $cerradas rutina${cerradas == 1 ? '' : 's'} pendiente${cerradas == 1 ? '' : 's'}',
      );
    }

    if (parciales > 0) {
      partes.add(
        '$parciales parcial${parciales == 1 ? '' : 'es'}',
      );
    }

    if (descartadas > 0) {
      partes.add(
        '$descartadas descartada${descartadas == 1 ? '' : 's'} sin ejercicios válidos',
      );
    }

    _mensajePendiente = '${partes.join('. ')}.';
  }

  static Future<Rutina?> _obtenerRutinaAsignada(
    String asignacionId,
  ) async {
    try {
      final documento = await _firestore
          .collection('rutinasAsignadas')
          .doc(asignacionId)
          .get();

      final datos = documento.data();

      if (datos == null) {
        return null;
      }

      final diaDato = datos['dia'];
      final rutinaDato = datos['rutina'];

      if (diaDato is! num || rutinaDato is! Map) {
        return null;
      }

      final ejercicios = <Ejercicio>[];
      final lista = rutinaDato['ejercicios'];

      if (lista is List) {
        for (final item in lista) {
          if (item is! Map) {
            continue;
          }

          final id = (item['id'] ?? '').toString();
          final nombre = (item['nombre'] ?? '').toString();

          if (id.isEmpty || nombre.isEmpty) {
            continue;
          }

          final seriesDato = item['series'];
          final descansoDato = item['descansoSegundos'];

          ejercicios.add(
            Ejercicio(
              id: id,
              nombre: nombre,
              series: seriesDato is num
                  ? seriesDato.toInt()
                  : 1,
              repeticiones:
                  (item['repeticiones'] ?? '').toString(),
              llevaPeso: item['llevaPeso'] == true,
              pesoAnterior: null,
              descansoSegundos: descansoDato is num
                  ? descansoDato.toInt()
                  : 0,
            ),
          );
        }
      }

      return Rutina(
        id: documento.id,
        dia: diaDato.toInt(),
        nombre: (rutinaDato['nombre'] ?? 'Rutina').toString(),
        ejercicios: ejercicios,
      );
    } on FirebaseException {
      return null;
    }
  }
}
