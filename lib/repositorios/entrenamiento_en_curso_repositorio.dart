import 'package:drift/drift.dart';

import '../base_datos/app_database.dart' as db;
import '../modelos/estado_entrenamiento.dart';
import '../modelos/rutina.dart';

class EntrenamientoEnCursoRepositorio {
  final db.AppDatabase database;

  EntrenamientoEnCursoRepositorio(
    this.database,
  );

  String obtenerIdCurso({
    required String alumnoId,
    required String rutinaId,
  }) {
    return 'curso_${alumnoId}_$rutinaId';
  }

  Future<EntrenamientoEnCurso>
      obtenerOCrear({
    required String alumnoId,
    required Rutina rutina,
  }) async {
    final idCurso = obtenerIdCurso(
      alumnoId: alumnoId,
      rutinaId: rutina.id,
    );

    final cursoDb =
        await (database.select(
                  database.entrenamientosEnCurso,
                )
              ..where(
                (tabla) =>
                    tabla.id.equals(idCurso),
              ))
            .getSingleOrNull();

    if (cursoDb == null) {
      final ahora = DateTime.now();

      await database.transaction(() async {
        await database
            .into(database.entrenamientosEnCurso)
            .insert(
              db.EntrenamientosEnCursoCompanion.insert(
                id: idCurso,
                alumnoId: alumnoId,
                rutinaId: rutina.id,
                fechaInicio: ahora,
                actualizadoEn: Value(ahora),
              ),
            );

        for (int i = 0;
            i < rutina.ejercicios.length;
            i++) {
          final ejercicio =
              rutina.ejercicios[i];

          await database
              .into(database.registrosEnCurso)
              .insert(
                db.RegistrosEnCursoCompanion.insert(
                  id: '${idCurso}_${ejercicio.id}_$i',
                  entrenamientoEnCursoId:
                      idCurso,
                  ejercicioId: ejercicio.id,
                  orden: i,
                ),
              );
        }
      });
    }

    return cargar(
      alumnoId: alumnoId,
      rutina: rutina,
    );
  }

  Future<EntrenamientoEnCurso> cargar({
    required String alumnoId,
    required Rutina rutina,
  }) async {
    final idCurso = obtenerIdCurso(
      alumnoId: alumnoId,
      rutinaId: rutina.id,
    );

    final cursoDb =
        await (database.select(
                  database.entrenamientosEnCurso,
                )
              ..where(
                (tabla) =>
                    tabla.id.equals(idCurso),
              ))
            .getSingleOrNull();

    if (cursoDb == null) {
      return obtenerOCrear(
        alumnoId: alumnoId,
        rutina: rutina,
      );
    }

    final registrosDb =
        await (database.select(
                  database.registrosEnCurso,
                )
              ..where(
                (tabla) =>
                    tabla.entrenamientoEnCursoId
                        .equals(idCurso),
              )
              ..orderBy([
                (tabla) =>
                    OrderingTerm.asc(tabla.orden),
              ]))
            .get();

    final estados =
        <EstadoEjercicioRutina>[];

    for (int i = 0;
        i < rutina.ejercicios.length;
        i++) {
      final ejercicio =
          rutina.ejercicios[i];

      db.RegistroEnCursoDb? registroEncontrado;

      for (final registro in registrosDb) {
        if (registro.ejercicioId ==
            ejercicio.id) {
          registroEncontrado = registro;
          break;
        }
      }

      if (registroEncontrado == null) {
        final idRegistro =
            '${idCurso}_${ejercicio.id}_$i';

        await database
            .into(database.registrosEnCurso)
            .insertOnConflictUpdate(
              db.RegistrosEnCursoCompanion.insert(
                id: idRegistro,
                entrenamientoEnCursoId: idCurso,
                ejercicioId: ejercicio.id,
                orden: i,
              ),
            );

        estados.add(
          EstadoEjercicioRutina(
            ejercicioId: ejercicio.id,
            nombreEjercicio:
                ejercicio.nombre,
          ),
        );
      } else {
        estados.add(
          EstadoEjercicioRutina(
            ejercicioId: ejercicio.id,
            nombreEjercicio:
                ejercicio.nombre,
            completado:
                registroEncontrado.completado,
            peso:
                registroEncontrado.pesoTexto,
            nota:
                registroEncontrado.nota,
          ),
        );
      }
    }

    return EntrenamientoEnCurso(
      id: cursoDb.id,
      alumnoId: cursoDb.alumnoId,
      rutinaId: cursoDb.rutinaId,
      fechaInicio: cursoDb.fechaInicio,
      ejercicios: estados,
    );
  }

  Future<void> actualizarEjercicio({
    required EntrenamientoEnCurso entrenamiento,
    required int orden,
    required EstadoEjercicioRutina estado,
  }) async {
    final idRegistro =
        '${entrenamiento.id}_${estado.ejercicioId}_$orden';

    await database
        .into(database.registrosEnCurso)
        .insertOnConflictUpdate(
          db.RegistrosEnCursoCompanion.insert(
            id: idRegistro,
            entrenamientoEnCursoId:
                entrenamiento.id,
            ejercicioId:
                estado.ejercicioId,
            orden: orden,
            completado:
                Value(estado.completado),
            pesoTexto:
                Value(estado.peso),
            nota:
                Value(estado.nota),
          ),
        );

    await (database.update(
              database.entrenamientosEnCurso,
            )
          ..where(
            (tabla) =>
                tabla.id.equals(
              entrenamiento.id,
            ),
          ))
        .write(
      db.EntrenamientosEnCursoCompanion(
        actualizadoEn:
            Value(DateTime.now()),
      ),
    );
  }

  Future<List<EntrenamientoEnCurso>>
      obtenerPendientesAnteriores(
    String alumnoId,
  ) async {
    final ahora = DateTime.now();

    final inicioHoy = DateTime(
      ahora.year,
      ahora.month,
      ahora.day,
    );

    final cursos =
        await (database.select(
                  database.entrenamientosEnCurso,
                )
              ..where(
                (tabla) =>
                    tabla.alumnoId.equals(
                  alumnoId,
                ),
              ))
            .get();

    final anteriores = cursos
        .where(
          (curso) => curso.fechaInicio.isBefore(
            inicioHoy,
          ),
        )
        .toList();

    anteriores.sort(
      (a, b) => a.fechaInicio.compareTo(
        b.fechaInicio,
      ),
    );

    final resultado = <EntrenamientoEnCurso>[];

    for (final curso in anteriores) {
      final registros =
          await (database.select(
                    database.registrosEnCurso,
                  )
                ..where(
                  (tabla) => tabla.entrenamientoEnCursoId.equals(
                    curso.id,
                  ),
                )
                ..orderBy([
                  (tabla) => OrderingTerm.asc(
                    tabla.orden,
                  ),
                ]))
              .get();

      final estados = registros.map(
        (registro) {
          return EstadoEjercicioRutina(
            ejercicioId: registro.ejercicioId,
            nombreEjercicio: '',
            completado: registro.completado,
            peso: registro.pesoTexto,
            nota: registro.nota,
          );
        },
      ).toList();

      resultado.add(
        EntrenamientoEnCurso(
          id: curso.id,
          alumnoId: curso.alumnoId,
          rutinaId: curso.rutinaId,
          fechaInicio: curso.fechaInicio,
          ejercicios: estados,
        ),
      );
    }

    return resultado;
  }

  Future<void> eliminar(
    String entrenamientoEnCursoId,
  ) async {
    await database.transaction(() async {
      await (database.delete(
                database.registrosEnCurso,
              )
            ..where(
              (tabla) =>
                  tabla.entrenamientoEnCursoId
                      .equals(
                entrenamientoEnCursoId,
              ),
            ))
          .go();

      await (database.delete(
                database.entrenamientosEnCurso,
              )
            ..where(
              (tabla) =>
                  tabla.id.equals(
                entrenamientoEnCursoId,
              ),
            ))
          .go();
    });
  }
}