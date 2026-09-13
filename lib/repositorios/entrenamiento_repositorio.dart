import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../base_datos/app_database.dart' as db;
import '../modelos/entrenamiento.dart';

class EntrenamientoRepositorio {
  final db.AppDatabase database;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  EntrenamientoRepositorio(
    this.database,
  );

  Future<void> guardarEntrenamientoFinalizado({
    required Entrenamiento entrenamiento,
    required String alumnoId,
    String? entrenamientoEnCursoId,
    String? rutinaNombre,
  }) async {
    // =========================
    // GUARDADO LOCAL
    // =========================
    //
    // Esta es la parte que SÍ esperamos.
    // Cuando este Future termina, el
    // entrenamiento ya quedó seguro en Drift.
    // =========================

    await database.transaction(() async {
      final ahora = DateTime.now();

      await database
          .into(database.entrenamientos)
          .insertOnConflictUpdate(
            db.EntrenamientosCompanion.insert(
              id: entrenamiento.id,
              alumnoId: alumnoId,
              rutinaId: entrenamiento.rutinaId,
              fechaInicio: entrenamiento.fecha,
              fechaFinalizacion: Value(
                entrenamiento.fecha,
              ),
              // true = sesión finalizada.
              // Puede ser completa o parcial.
              completado: Value(
                entrenamiento.completado,
              ),
              actualizadoEn: Value(
                ahora,
              ),
            ),
          );

      for (int i = 0;
          i < entrenamiento.ejercicios.length;
          i++) {
        final ejercicio =
            entrenamiento.ejercicios[i];

        await database
            .into(database.registrosEjercicio)
            .insertOnConflictUpdate(
              db.RegistrosEjercicioCompanion.insert(
                id:
                    '${entrenamiento.id}_${ejercicio.ejercicioId}_$i',
                entrenamientoId:
                    entrenamiento.id,
                ejercicioId:
                    ejercicio.ejercicioId,
                nombreEjercicio:
                    ejercicio.nombreEjercicio,
                series:
                    ejercicio.series,
                repeticiones:
                    ejercicio.repeticiones,
                llevaPeso:
                    ejercicio.llevaPeso,
                pesoUsado:
                    Value(
                  ejercicio.pesoUsado,
                ),
                nota:
                    Value(
                  ejercicio.nota,
                ),
                completado:
                    Value(
                  ejercicio.completado,
                ),
                orden:
                    i,
              ),
            );
      }

      if (entrenamientoEnCursoId != null) {
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
      }
    });

    // =========================
    // SINCRONIZACIÓN FIRESTORE
    // =========================
    //
    // NO esperamos la confirmación remota.
    //
    // Sin internet, Firestore puede mantener
    // la escritura pendiente. La pantalla
    // no debe quedarse en "Guardando...".
    // =========================

    unawaited(
      _guardarEnFirestore(
        entrenamiento: entrenamiento,
        alumnoId: alumnoId,
        rutinaNombre: rutinaNombre,
      ).catchError(
        (_) {
          // El entrenamiento ya está guardado
          // localmente. Se volverá a intentar
          // durante una sincronización posterior.
        },
      ),
    );
  }

  Future<void> _guardarEnFirestore({
    required Entrenamiento entrenamiento,
    required String alumnoId,
    String? rutinaNombre,
  }) async {
    final usuario =
        FirebaseAuth.instance.currentUser;

    if (usuario == null ||
        usuario.uid != alumnoId ||
        !usuario.emailVerified) {
      return;
    }

    final ejercicios =
        entrenamiento.ejercicios
            .asMap()
            .entries
            .map(
      (entrada) {
        final item =
            entrada.value;

        return {
          'orden':
              entrada.key,
          'ejercicioId':
              item.ejercicioId,
          'nombreEjercicio':
              item.nombreEjercicio,
          'series':
              item.series,
          'repeticiones':
              item.repeticiones,
          'llevaPeso':
              item.llevaPeso,
          'pesoUsado':
              item.pesoUsado,
          'nota':
              item.nota,
          'completado':
              item.completado,
        };
      },
    ).toList();

    await _firestore
        .collection(
          'entrenamientosAlumno',
        )
        .doc(
          entrenamiento.id,
        )
        .set(
      {
        'id':
            entrenamiento.id,
        'alumnoId':
            alumnoId,
        'rutinaId':
            entrenamiento.rutinaId,
        'rutinaNombre':
            rutinaNombre ?? '',
        'fecha':
            Timestamp.fromDate(
          entrenamiento.fecha,
        ),
        'estado':
            entrenamiento.esParcial
                ? 'parcial'
                : 'completo',
        'ejerciciosCompletados':
            entrenamiento
                .ejerciciosCompletados,
        'totalEjercicios':
            entrenamiento
                .totalEjercicios,
        'finalizado':
            entrenamiento.completado,
        'ejercicios':
            ejercicios,
        'actualizadoEn':
            FieldValue.serverTimestamp(),
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  Future<void>
      sincronizarEntrenamientosLocales({
    required String alumnoId,
  }) async {
    final usuario =
        FirebaseAuth.instance.currentUser;

    if (usuario == null ||
        usuario.uid != alumnoId ||
        !usuario.emailVerified) {
      return;
    }

    final entrenamientos =
        await obtenerEntrenamientosFinalizados(
      alumnoId,
    );

    for (final entrenamiento
        in entrenamientos.reversed) {
      try {
        await _guardarEnFirestore(
          entrenamiento:
              entrenamiento,
          alumnoId:
              alumnoId,
        );
      } catch (_) {
        // Si no se puede sincronizar ahora,
        // dejamos intactos los datos locales.
        // Se reintentará más adelante.
        return;
      }
    }
  }

  Future<List<Entrenamiento>>
      obtenerEntrenamientosFinalizados(
    String alumnoId,
  ) async {
    final entrenamientosDb =
        await (database.select(
                  database.entrenamientos,
                )
              ..where(
                (tabla) =>
                    tabla.alumnoId.equals(
                      alumnoId,
                    ) &
                    tabla.completado.equals(
                      true,
                    ),
              )
              ..orderBy([
                (tabla) =>
                    OrderingTerm.desc(
                  tabla.fechaFinalizacion,
                ),
              ]))
            .get();

    final resultado =
        <Entrenamiento>[];

    for (final entrenamientoDb
        in entrenamientosDb) {
      final registrosDb =
          await (database.select(
                    database.registrosEjercicio,
                  )
                ..where(
                  (tabla) =>
                      tabla.entrenamientoId.equals(
                    entrenamientoDb.id,
                  ),
                )
                ..orderBy([
                  (tabla) =>
                      OrderingTerm.asc(
                    tabla.orden,
                  ),
                ]))
              .get();

      final registros =
          registrosDb.map(
        (registroDb) {
          return RegistroEjercicio(
            ejercicioId:
                registroDb.ejercicioId,
            nombreEjercicio:
                registroDb.nombreEjercicio,
            series:
                registroDb.series,
            repeticiones:
                registroDb.repeticiones,
            llevaPeso:
                registroDb.llevaPeso,
            pesoUsado:
                registroDb.pesoUsado,
            nota:
                registroDb.nota ?? '',
            completado:
                registroDb.completado,
          );
        },
      ).toList();

      resultado.add(
        Entrenamiento(
          id:
              entrenamientoDb.id,
          rutinaId:
              entrenamientoDb.rutinaId,
          fecha:
              entrenamientoDb
                      .fechaFinalizacion ??
                  entrenamientoDb.fechaInicio,
          ejercicios:
              registros,
          completado:
              entrenamientoDb.completado,
        ),
      );
    }

    return resultado;
  }

  Future<Map<String, double>>
      obtenerUltimosPesosEjercicios(
    String alumnoId,
  ) async {
    final entrenamientos =
        await obtenerEntrenamientosFinalizados(
      alumnoId,
    );

    final ultimosPesos =
        <String, double>{};

    for (final entrenamiento
        in entrenamientos) {
      for (final ejercicio
          in entrenamiento.ejercicios) {
        if (!ejercicio.completado ||
            !ejercicio.llevaPeso) {
          continue;
        }

        if (ejercicio.pesoUsado == null ||
            ejercicio.pesoUsado! <= 0) {
          continue;
        }

        ultimosPesos.putIfAbsent(
          ejercicio.ejercicioId,
          () =>
              ejercicio.pesoUsado!,
        );
      }
    }

    return ultimosPesos;
  }
}
