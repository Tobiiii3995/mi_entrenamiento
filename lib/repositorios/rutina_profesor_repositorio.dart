import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../base_datos/app_database.dart' as db;
import '../modelos/ejercicio_catalogo.dart';
import '../modelos/rutina_editor.dart';

class RutinaProfesorRepositorio {
  final db.AppDatabase database;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  RutinaProfesorRepositorio(
    this.database,
  );

  Future<User> _obtenerUsuarioActual() async {
    final usuario =
        FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception(
        'No hay una sesión activa.',
      );
    }

    await usuario.reload();

    final actualizado =
        FirebaseAuth.instance.currentUser;

    if (actualizado == null) {
      throw Exception(
        'No se pudo actualizar la sesión.',
      );
    }

    if (!actualizado.emailVerified) {
      throw Exception(
        'El correo debe estar verificado.',
      );
    }

    await actualizado.getIdTokenResult(
      true,
    );

    return actualizado;
  }

  Future<void> _validarProfesor(
    String profesorId,
  ) async {
    final usuario =
        await _obtenerUsuarioActual();

    if (usuario.uid != profesorId) {
      throw Exception(
        'No tenés permiso para modificar '
        'las rutinas de este profesor.',
      );
    }

    final documento =
        await _firestore
            .collection('usuarios')
            .doc(profesorId)
            .get();

    final datos =
        documento.data();

    if (datos == null ||
        datos['rol'] != 'profesor' ||
        datos['activo'] != true) {
      throw Exception(
        'La cuenta del profesor no es válida.',
      );
    }
  }

  Future<void> guardarRutina(
    RutinaEditor rutina,
  ) async {
    await _validarProfesor(
      rutina.creadorId,
    );

    //
    // Guardamos primero en Drift.
    //
    await _guardarRutinaLocal(
      rutina,
    );

    //
    // Después guardamos la misma plantilla
    // completa en Firestore.
    //
    await _guardarRutinaFirestore(
      rutina,
    );
  }

  Future<void> _guardarRutinaLocal(
    RutinaEditor rutina,
  ) async {
    await database.transaction(
      () async {
        final ahora =
            DateTime.now();

        await database
            .into(database.rutinas)
            .insertOnConflictUpdate(
              db.RutinasCompanion.insert(
                id:
                    rutina.id,
                creadorId:
                    rutina.creadorId,
                nombre:
                    rutina.nombre.trim(),
                descripcion:
                    Value(
                  _textoNullable(
                    rutina.descripcion,
                  ),
                ),
                actualizadoEn:
                    Value(
                  ahora,
                ),
                eliminado:
                    const Value(
                  false,
                ),
              ),
            );

        await (database.delete(
                  database.rutinaEjercicios,
                )
              ..where(
                (tabla) =>
                    tabla.rutinaId.equals(
                  rutina.id,
                ),
              ))
            .go();

        for (
          int i = 0;
          i < rutina.ejercicios.length;
          i++
        ) {
          final item =
              rutina.ejercicios[i];

          //
          // Aseguramos también que el ejercicio
          // exista en la cache local.
          //
          await database
              .into(database.ejercicios)
              .insertOnConflictUpdate(
                db.EjerciciosCompanion.insert(
                  id:
                      item.ejercicio.id,
                  creadorId:
                      item.ejercicio.creadorId,
                  nombre:
                      item.ejercicio.nombre.trim(),
                  descripcion:
                      Value(
                    _textoNullable(
                      item.ejercicio.descripcion,
                    ),
                  ),
                  llevaPeso:
                      Value(
                    item.ejercicio.llevaPeso,
                  ),
                  grupoMuscular:
                      Value(
                    _textoNullable(
                      item.ejercicio.grupoMuscular,
                    ),
                  ),
                  instrucciones:
                      Value(
                    _textoNullable(
                      item.ejercicio.instrucciones,
                    ),
                  ),
                  urlMedia:
                      Value(
                    _textoNullable(
                      item.ejercicio.urlMedia,
                    ),
                  ),
                  actualizadoEn:
                      Value(
                    ahora,
                  ),
                  eliminado:
                      const Value(
                    false,
                  ),
                ),
              );

          await database
              .into(
                database.rutinaEjercicios,
              )
              .insert(
                db.RutinaEjerciciosCompanion.insert(
                  id:
                      item.idRelacion,
                  rutinaId:
                      rutina.id,
                  ejercicioId:
                      item.ejercicio.id,
                  orden:
                      i,
                  series:
                      item.series,
                  repeticiones:
                      item.repeticiones.trim(),
                  descansoSegundos:
                      Value(
                    item.descansoSegundos,
                  ),
                  observaciones:
                      Value(
                    _textoNullable(
                      item.observaciones,
                    ),
                  ),
                ),
              );
        }
      },
    );
  }

  Future<void> _guardarRutinaFirestore(
    RutinaEditor rutina,
  ) async {
    final ejercicios =
        rutina.ejercicios
            .asMap()
            .entries
            .map(
      (entrada) {
        final item =
            entrada.value;

        return {
          'idRelacion':
              item.idRelacion,
          'orden':
              entrada.key,
          'series':
              item.series,
          'repeticiones':
              item.repeticiones.trim(),
          'descansoSegundos':
              item.descansoSegundos,
          'observaciones':
              item.observaciones.trim(),
          'ejercicio': {
            'id':
                item.ejercicio.id,
            'creadorId':
                item.ejercicio.creadorId,
            'nombre':
                item.ejercicio.nombre.trim(),
            'descripcion':
                item.ejercicio.descripcion.trim(),
            'llevaPeso':
                item.ejercicio.llevaPeso,
            'grupoMuscular':
                item.ejercicio.grupoMuscular.trim(),
            'instrucciones':
                item.ejercicio.instrucciones.trim(),
            'urlMedia':
                (item.ejercicio.urlMedia ?? '').trim(),
          },
        };
      },
    ).toList();

    await _firestore
        .collection(
          'rutinasProfesor',
        )
        .doc(
          rutina.id,
        )
        .set({
      'id':
          rutina.id,
      'creadorId':
          rutina.creadorId,
      'nombre':
          rutina.nombre.trim(),
      'descripcion':
          rutina.descripcion.trim(),
      'ejercicios':
          ejercicios,
      'eliminado':
          false,
      'actualizadoEn':
          FieldValue.serverTimestamp(),
    });
  }

  Future<List<RutinaEditor>>
      obtenerRutinasDelProfesor(
    String profesorId,
  ) async {
    await _validarProfesor(
      profesorId,
    );

    try {
      final consulta =
          await _firestore
              .collection(
                'rutinasProfesor',
              )
              .where(
                'creadorId',
                isEqualTo: profesorId,
              )
              .get();

      //
      // Primera migración:
      // si todavía no existe ninguna rutina
      // cloud, subimos las locales actuales.
      //
      if (consulta.docs.isEmpty) {
        final locales =
            await _obtenerRutinasLocales(
          profesorId,
        );

        for (final rutina
            in locales) {
          await _guardarRutinaFirestore(
            rutina,
          );
        }

        return locales;
      }

      final resultado =
          <RutinaEditor>[];

      for (final documento
          in consulta.docs) {
        final datos =
            documento.data();

        if (datos['eliminado'] == true) {
          continue;
        }

        final rutina =
            _rutinaDesdeFirestore(
          documento.id,
          datos,
        );

        resultado.add(
          rutina,
        );

        //
        // Mantenemos cache local actualizada.
        //
        await _guardarRutinaLocal(
          rutina,
        );
      }

      resultado.sort(
        (a, b) =>
            a.nombre
                .toLowerCase()
                .compareTo(
                  b.nombre.toLowerCase(),
                ),
      );

      return resultado;
    } on FirebaseException {
      //
      // Sin conexión:
      // continuamos con Drift.
      //
      return _obtenerRutinasLocales(
        profesorId,
      );
    }
  }

  Future<List<RutinaEditor>>
      _obtenerRutinasLocales(
    String profesorId,
  ) async {
    final rutinasDb =
        await (database.select(
                  database.rutinas,
                )
              ..where(
                (tabla) =>
                    tabla.creadorId.equals(
                          profesorId,
                        ) &
                    tabla.eliminado.equals(
                      false,
                    ),
              )
              ..orderBy([
                (tabla) =>
                    OrderingTerm.asc(
                  tabla.nombre,
                ),
              ]))
            .get();

    final resultado =
        <RutinaEditor>[];

    for (final rutinaDb
        in rutinasDb) {
      resultado.add(
        await _mapearRutina(
          rutinaDb,
        ),
      );
    }

    return resultado;
  }

  RutinaEditor _rutinaDesdeFirestore(
    String documentoId,
    Map<String, dynamic> datos,
  ) {
    final ejercicios =
        <EjercicioRutinaEditor>[];

    final ejerciciosDatos =
        datos['ejercicios'];

    if (ejerciciosDatos is List) {
      for (
        int i = 0;
        i < ejerciciosDatos.length;
        i++
      ) {
        final itemDato =
            ejerciciosDatos[i];

        if (itemDato is! Map) {
          continue;
        }

        final ejercicioDato =
            itemDato['ejercicio'];

        if (ejercicioDato is! Map) {
          continue;
        }

        final ejercicio =
            EjercicioCatalogo(
          id:
              (ejercicioDato['id'] ?? '')
                  .toString(),
          creadorId:
              (ejercicioDato['creadorId'] ?? '')
                  .toString(),
          nombre:
              (ejercicioDato['nombre'] ?? '')
                  .toString(),
          descripcion:
              (ejercicioDato['descripcion'] ?? '')
                  .toString(),
          llevaPeso:
              ejercicioDato['llevaPeso'] == true,
          grupoMuscular:
              (ejercicioDato['grupoMuscular'] ?? '')
                  .toString(),
          instrucciones:
              (ejercicioDato['instrucciones'] ?? '')
                  .toString(),
          urlMedia:
              (ejercicioDato['urlMedia'] ??
                      ejercicioDato['url_media'] ??
                      '')
                  .toString(),
        );

        final ordenDato =
            itemDato['orden'];

        final seriesDato =
            itemDato['series'];

        final descansoDato =
            itemDato['descansoSegundos'];

        ejercicios.add(
          EjercicioRutinaEditor(
            idRelacion:
                (itemDato['idRelacion'] ??
                        'rel_${documentoId}_${ejercicio.id}_$i')
                    .toString(),
            ejercicio:
                ejercicio,
            orden:
                ordenDato is num
                    ? ordenDato.toInt()
                    : i,
            series:
                seriesDato is num
                    ? seriesDato.toInt()
                    : 1,
            repeticiones:
                (itemDato['repeticiones'] ?? '')
                    .toString(),
            descansoSegundos:
                descansoDato is num
                    ? descansoDato.toInt()
                    : 0,
            observaciones:
                (itemDato['observaciones'] ?? '')
                    .toString(),
          ),
        );
      }
    }

    ejercicios.sort(
      (a, b) =>
          a.orden.compareTo(
        b.orden,
      ),
    );

    return RutinaEditor(
      id:
          (datos['id'] ?? documentoId)
              .toString(),
      creadorId:
          (datos['creadorId'] ?? '')
              .toString(),
      nombre:
          (datos['nombre'] ?? '')
              .toString(),
      descripcion:
          (datos['descripcion'] ?? '')
              .toString(),
      ejercicios:
          ejercicios,
    );
  }

  Future<RutinaEditor?> obtenerRutina(
    String rutinaId,
  ) async {
    try {
      final documento =
          await _firestore
              .collection(
                'rutinasProfesor',
              )
              .doc(
                rutinaId,
              )
              .get();

      final datos =
          documento.data();

      if (datos != null &&
          datos['eliminado'] != true) {
        final rutina =
            _rutinaDesdeFirestore(
          documento.id,
          datos,
        );

        await _guardarRutinaLocal(
          rutina,
        );

        return rutina;
      }
    } on FirebaseException {
      // Probamos local.
    }

    final rutinaDb =
        await (database.select(
                  database.rutinas,
                )
              ..where(
                (tabla) =>
                    tabla.id.equals(
                          rutinaId,
                        ) &
                    tabla.eliminado.equals(
                      false,
                    ),
              ))
            .getSingleOrNull();

    if (rutinaDb == null) {
      return null;
    }

    return _mapearRutina(
      rutinaDb,
    );
  }

  Future<void> archivarRutina(
    String rutinaId,
  ) async {
    final rutina =
        await obtenerRutina(
      rutinaId,
    );

    if (rutina == null) {
      throw Exception(
        'No se encontró la rutina.',
      );
    }

    await _validarProfesor(
      rutina.creadorId,
    );

    await (database.update(
              database.rutinas,
            )
          ..where(
            (tabla) =>
                tabla.id.equals(
              rutinaId,
            ),
          ))
        .write(
      db.RutinasCompanion(
        eliminado:
            const Value(
          true,
        ),
        actualizadoEn:
            Value(
          DateTime.now(),
        ),
      ),
    );

    await _firestore
        .collection(
          'rutinasProfesor',
        )
        .doc(
          rutinaId,
        )
        .update({
      'eliminado':
          true,
      'actualizadoEn':
          FieldValue.serverTimestamp(),
    });
  }

  Future<RutinaEditor> _mapearRutina(
    db.RutinaDb rutinaDb,
  ) async {
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
        <EjercicioRutinaEditor>[];

    for (final relacion
        in relaciones) {
      final ejercicioDb =
          await (database.select(
                    database.ejercicios,
                  )
                ..where(
                  (tabla) =>
                      tabla.id.equals(
                    relacion.ejercicioId,
                  ),
                ))
              .getSingleOrNull();

      if (ejercicioDb == null) {
        continue;
      }

      final ejercicioCatalogo =
          EjercicioCatalogo(
        id:
            ejercicioDb.id,
        creadorId:
            ejercicioDb.creadorId,
        nombre:
            ejercicioDb.nombre,
        descripcion:
            ejercicioDb.descripcion ?? '',
        llevaPeso:
            ejercicioDb.llevaPeso,
        grupoMuscular:
            ejercicioDb.grupoMuscular ?? '',
        instrucciones:
            ejercicioDb.instrucciones ?? '',
        urlMedia:
            ejercicioDb.urlMedia ?? '',
      );

      ejercicios.add(
        EjercicioRutinaEditor(
          idRelacion:
              relacion.id,
          ejercicio:
              ejercicioCatalogo,
          orden:
              relacion.orden,
          series:
              relacion.series,
          repeticiones:
              relacion.repeticiones,
          descansoSegundos:
              relacion.descansoSegundos,
          observaciones:
              relacion.observaciones ?? '',
        ),
      );
    }

    return RutinaEditor(
      id:
          rutinaDb.id,
      creadorId:
          rutinaDb.creadorId,
      nombre:
          rutinaDb.nombre,
      descripcion:
          rutinaDb.descripcion ?? '',
      ejercicios:
          ejercicios,
    );
  }

  String? _textoNullable(
    String? texto,
  ) {
    if (texto == null) {
      return null;
    }

    final limpio =
        texto.trim();

    if (limpio.isEmpty) {
      return null;
    }

    return limpio;
  }
}