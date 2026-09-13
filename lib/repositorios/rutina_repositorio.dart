import 'package:drift/drift.dart';

import '../base_datos/app_database.dart' as db;
import '../modelos/ejercicio.dart' as modelo_ejercicio;
import '../modelos/rutina.dart' as modelo_rutina;

class RutinaRepositorio {
  final db.AppDatabase database;

  RutinaRepositorio(this.database);

  Future<void> guardarEjercicio({
    required String id,
    required String creadorId,
    required String nombre,
    required bool llevaPeso,
    String? urlMedia,
  }) async {
    await database
        .into(database.ejercicios)
        .insertOnConflictUpdate(
          db.EjerciciosCompanion.insert(
            id: id,
            creadorId: creadorId,
            nombre: nombre,
            llevaPeso: Value(llevaPeso),
            urlMedia: Value(urlMedia),
            actualizadoEn: Value(DateTime.now()),
          ),
        );
  }

  Future<void> guardarRutina({
    required String id,
    required String creadorId,
    required String nombre,
  }) async {
    await database
        .into(database.rutinas)
        .insertOnConflictUpdate(
          db.RutinasCompanion.insert(
            id: id,
            creadorId: creadorId,
            nombre: nombre,
            actualizadoEn: Value(DateTime.now()),
          ),
        );
  }

  Future<void> guardarEjercicioEnRutina({
    required String id,
    required String rutinaId,
    required String ejercicioId,
    required int orden,
    required int series,
    required String repeticiones,
    required int descansoSegundos,
  }) async {
    await database
        .into(database.rutinaEjercicios)
        .insertOnConflictUpdate(
          db.RutinaEjerciciosCompanion.insert(
            id: id,
            rutinaId: rutinaId,
            ejercicioId: ejercicioId,
            orden: orden,
            series: series,
            repeticiones: repeticiones,
            descansoSegundos: Value(
              descansoSegundos,
            ),
          ),
        );
  }

  Future<void> asignarRutina({
    required String id,
    required String rutinaId,
    required String profesorId,
    required String alumnoId,
    required int dia,
  }) async {
    await database
        .into(database.rutinasAsignadas)
        .insertOnConflictUpdate(
          db.RutinasAsignadasCompanion.insert(
            id: id,
            rutinaId: rutinaId,
            profesorId: profesorId,
            alumnoId: alumnoId,
            dia: dia,
            fechaAsignacion: DateTime.now(),
          ),
        );
  }

  Future<void> guardarRutinaCompleta({
    required modelo_rutina.Rutina rutina,
    required String creadorId,
    required String profesorId,
    required String alumnoId,
  }) async {
    await database.transaction(() async {
      await guardarRutina(
        id: rutina.id,
        creadorId: creadorId,
        nombre: rutina.nombre,
      );

      for (int i = 0; i < rutina.ejercicios.length; i++) {
        final ejercicio = rutina.ejercicios[i];

        await guardarEjercicio(
          id: ejercicio.id,
          creadorId: creadorId,
          nombre: ejercicio.nombre,
          llevaPeso: ejercicio.llevaPeso,
          urlMedia: ejercicio.urlMedia,
        );

        await guardarEjercicioEnRutina(
          id: '${rutina.id}_${ejercicio.id}_$i',
          rutinaId: rutina.id,
          ejercicioId: ejercicio.id,
          orden: i,
          series: ejercicio.series,
          repeticiones: ejercicio.repeticiones,
          descansoSegundos:
              ejercicio.descansoSegundos,
        );
      }

      await asignarRutina(
        id: 'asignacion_${alumnoId}_${rutina.id}',
        rutinaId: rutina.id,
        profesorId: profesorId,
        alumnoId: alumnoId,
        dia: rutina.dia,
      );
    });
  }

  Future<List<modelo_rutina.Rutina>>
      obtenerRutinasAsignadas(
    String alumnoId,
  ) async {
    final asignaciones =
        await (database.select(database.rutinasAsignadas)
              ..where(
                (tabla) =>
                    tabla.alumnoId.equals(alumnoId) &
                    tabla.activa.equals(true),
              )
              ..orderBy([
                (tabla) => OrderingTerm.asc(
                      tabla.dia,
                    ),
              ]))
            .get();

    final resultado =
        <modelo_rutina.Rutina>[];

    for (final asignacion in asignaciones) {
      final rutinaDb =
          await (database.select(database.rutinas)
                ..where(
                  (tabla) =>
                      tabla.id.equals(
                        asignacion.rutinaId,
                      ) &
                      tabla.eliminado.equals(false),
                ))
              .getSingleOrNull();

      if (rutinaDb == null) {
        continue;
      }

      final relaciones =
          await (database.select(
                    database.rutinaEjercicios,
                  )
                ..where(
                  (tabla) =>
                      tabla.rutinaId.equals(
                        rutinaDb.id,
                      ),
                )
                ..orderBy([
                  (tabla) =>
                      OrderingTerm.asc(
                        tabla.orden,
                      ),
                ]))
              .get();

      final ejercicios =
          <modelo_ejercicio.Ejercicio>[];

      for (final relacion in relaciones) {
        final ejercicioDb =
            await (database.select(
                      database.ejercicios,
                    )
                  ..where(
                    (tabla) =>
                        tabla.id.equals(
                          relacion.ejercicioId,
                        ) &
                        tabla.eliminado.equals(false),
                  ))
                .getSingleOrNull();

        if (ejercicioDb == null) {
          continue;
        }

        ejercicios.add(
          modelo_ejercicio.Ejercicio(
            id: ejercicioDb.id,
            nombre: ejercicioDb.nombre,
            series: relacion.series,
            repeticiones:
                relacion.repeticiones,
            llevaPeso:
                ejercicioDb.llevaPeso,
            pesoAnterior: null,
            descansoSegundos:
                relacion.descansoSegundos,
            urlMedia: ejercicioDb.urlMedia,
          ),
        );
      }

      resultado.add(
        modelo_rutina.Rutina(
          id: rutinaDb.id,
          dia: asignacion.dia,
          nombre: rutinaDb.nombre,
          ejercicios: ejercicios,
        ),
      );
    }

    return resultado;
  }
}