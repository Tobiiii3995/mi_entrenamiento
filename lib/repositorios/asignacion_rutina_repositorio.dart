import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../base_datos/app_database.dart' as db;
import '../modelos/ejercicio.dart';
import '../modelos/rutina.dart';
import '../modelos/rutina_editor.dart';

class AsignacionRutinaFirestore {
  final String id;
  final String rutinaOrigenId;
  final String profesorId;
  final String alumnoId;
  final int dia;
  final bool activa;
  final String nombreRutina;

  const AsignacionRutinaFirestore({
    required this.id,
    required this.rutinaOrigenId,
    required this.profesorId,
    required this.alumnoId,
    required this.dia,
    required this.activa,
    required this.nombreRutina,
  });
}

class AsignacionRutinaRepositorio {
  final db.AppDatabase database;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  AsignacionRutinaRepositorio(
    this.database,
  );

  // ============================================================
  // FIRESTORE
  // ============================================================

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

  Stream<List<AsignacionRutinaFirestore>>
      escucharAsignacionesProfesor({
    required String profesorId,
    required String alumnoId,
  }) {
    final usuario =
        FirebaseAuth.instance.currentUser;

    if (usuario == null ||
        usuario.uid != profesorId) {
      return Stream.value(
        const [],
      );
    }

    return _firestore
        .collection(
          'rutinasAsignadas',
        )
        .where(
          'profesorId',
          isEqualTo: profesorId,
        )
        .where(
          'alumnoId',
          isEqualTo: alumnoId,
        )
        .where(
          'activa',
          isEqualTo: true,
        )
        .snapshots()
        .map(
      (snapshot) {
        final resultado =
            snapshot.docs.map(
          (documento) {
            final datos =
                documento.data();

            final rutina =
                datos['rutina'];

            String nombre =
                'Rutina';

            if (rutina is Map) {
              nombre =
                  (rutina['nombre'] ??
                          'Rutina')
                      .toString();
            }

            return AsignacionRutinaFirestore(
              id: documento.id,
              rutinaOrigenId:
                  (datos[
                              'rutinaOrigenId'] ??
                          '')
                      .toString(),
              profesorId:
                  (datos['profesorId'] ?? '')
                      .toString(),
              alumnoId:
                  (datos['alumnoId'] ?? '')
                      .toString(),
              dia:
                  (datos['dia'] is num)
                      ? (datos['dia'] as num)
                          .toInt()
                      : 0,
              activa:
                  datos['activa'] == true,
              nombreRutina:
                  nombre,
            );
          },
        ).toList();

        resultado.sort(
          (a, b) =>
              a.dia.compareTo(
            b.dia,
          ),
        );

        return resultado;
      },
    );
  }

  Stream<List<Rutina>>
      escucharRutinasAlumnoFirestore() {
    final usuario =
        FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return Stream.value(
        const [],
      );
    }

    return _firestore
        .collection(
          'rutinasAsignadas',
        )
        .where(
          'alumnoId',
          isEqualTo: usuario.uid,
        )
        .where(
          'activa',
          isEqualTo: true,
        )
        .snapshots()
        .map(
      (snapshot) {
        final rutinas =
            <Rutina>[];

        for (final documento
            in snapshot.docs) {
          final rutina =
              _rutinaAlumnoDesdeDocumento(
            documento,
          );

          if (rutina != null) {
            rutinas.add(
              rutina,
            );
          }
        }

        rutinas.sort(
          (a, b) =>
              a.dia.compareTo(
            b.dia,
          ),
        );

        return rutinas;
      },
    );
  }

  Rutina? _rutinaAlumnoDesdeDocumento(
    QueryDocumentSnapshot<
            Map<String, dynamic>>
        documento,
  ) {
    final datos =
        documento.data();

    final diaDato =
        datos['dia'];

    if (diaDato is! num) {
      return null;
    }

    final snapshotRutina =
        datos['rutina'];

    if (snapshotRutina is! Map) {
      return null;
    }

    final nombre =
        (snapshotRutina['nombre'] ??
                'Rutina')
            .toString();

    final ejerciciosDato =
        snapshotRutina['ejercicios'];

    final ejercicios =
        <Ejercicio>[];

    if (ejerciciosDato is List) {
      for (final item
          in ejerciciosDato) {
        if (item is! Map) {
          continue;
        }

        final id =
            (item['id'] ?? '')
                .toString();

        final nombreEjercicio =
            (item['nombre'] ?? '')
                .toString();

        if (id.isEmpty ||
            nombreEjercicio.isEmpty) {
          continue;
        }

        final seriesDato =
            item['series'];

        final descansoDato =
            item['descansoSegundos'];

        ejercicios.add(
          Ejercicio(
            id:
                id,
            nombre:
                nombreEjercicio,
            series:
                seriesDato is num
                    ? seriesDato.toInt()
                    : 1,
            repeticiones:
                (item['repeticiones'] ??
                        '')
                    .toString(),
            llevaPeso:
                item['llevaPeso'] ==
                    true,
            pesoAnterior:
                null,
            descansoSegundos:
                descansoDato is num
                    ? descansoDato.toInt()
                    : 0,
          ),
        );
      }
    }

    //
    // IMPORTANTE:
    //
    // El ID que recibe el alumno es el ID
    // DE LA ASIGNACIÓN, no el ID de la
    // plantilla del profesor.
    //
    // Esto evita que dos asignaciones
    // históricas distintas se mezclen.
    //
    return Rutina(
      id:
          documento.id,
      dia:
          diaDato.toInt(),
      nombre:
          nombre,
      ejercicios:
          ejercicios,
    );
  }

  Future<void> asignarRutinaFirestore({
    required String profesorId,
    required String alumnoId,
    required RutinaEditor rutina,
  }) async {
    final usuario =
        await _obtenerUsuarioActual();

    if (usuario.uid !=
        profesorId) {
      throw Exception(
        'No tenés permiso para asignar rutinas con este profesor.',
      );
    }

    final usuarioProfesor =
        await _firestore
            .collection(
              'usuarios',
            )
            .doc(
              profesorId,
            )
            .get();

    final datosProfesor =
        usuarioProfesor.data();

    if (datosProfesor == null ||
        datosProfesor['rol'] !=
            'profesor' ||
        datosProfesor['activo'] !=
            true) {
      throw Exception(
        'La cuenta del profesor no es válida.',
      );
    }

    final vinculo =
        await _firestore
            .collection(
              'vinculosActivos',
            )
            .doc(
              alumnoId,
            )
            .get();

    final datosVinculo =
        vinculo.data();

    if (datosVinculo == null ||
        datosVinculo['profesorId'] !=
            profesorId) {
      throw Exception(
        'Este alumno ya no está vinculado contigo.',
      );
    }

    final actuales =
        await _firestore
            .collection(
              'rutinasAsignadas',
            )
            .where(
              'profesorId',
              isEqualTo: profesorId,
            )
            .where(
              'alumnoId',
              isEqualTo: alumnoId,
            )
            .where(
              'activa',
              isEqualTo: true,
            )
            .get();

    if (actuales.docs.length >= 7) {
      throw Exception(
        'El alumno ya tiene 7 rutinas asignadas.',
      );
    }

    for (final documento
        in actuales.docs) {
      final datos =
          documento.data();

      if ((datos[
                  'rutinaOrigenId'] ??
              '')
          .toString() ==
          rutina.id) {
        throw Exception(
          'Esta rutina ya está asignada al alumno.',
        );
      }
    }

    final diasUsados =
        actuales.docs
            .map(
              (documento) {
                final valor =
                    documento.data()[
                        'dia'];

                if (valor is num) {
                  return valor.toInt();
                }

                return 0;
              },
            )
            .where(
              (dia) =>
                  dia >= 1 &&
                  dia <= 7,
            )
            .toSet();

    int dia = 1;

    while (diasUsados.contains(
          dia,
        ) &&
        dia <= 7) {
      dia++;
    }

    if (dia > 7) {
      throw Exception(
        'No hay un día disponible para esta rutina.',
      );
    }

    final ahora =
        DateTime.now();

    final asignacionId =
        'asig_${alumnoId}_${ahora.microsecondsSinceEpoch}';

    final ejerciciosSnapshot =
        rutina.ejercicios
            .asMap()
            .entries
            .map(
      (entrada) {
        final item =
            entrada.value;

        return {
          'id':
              item.ejercicio.id,
          'nombre':
              item.ejercicio.nombre,
          'descripcion':
              item.ejercicio.descripcion,
          'llevaPeso':
              item.ejercicio.llevaPeso,
          'grupoMuscular':
              item.ejercicio.grupoMuscular,
          'instrucciones':
              item.ejercicio.instrucciones,
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
        };
      },
    ).toList();

    await _firestore
        .collection(
          'rutinasAsignadas',
        )
        .doc(
          asignacionId,
        )
        .set({
      'id':
          asignacionId,
      'rutinaOrigenId':
          rutina.id,
      'profesorId':
          profesorId,
      'alumnoId':
          alumnoId,
      'dia':
          dia,
      'activa':
          true,
      'fechaAsignacion':
          FieldValue.serverTimestamp(),
      'actualizadoEn':
          FieldValue.serverTimestamp(),
      'rutina': {
        'nombre':
            rutina.nombre.trim(),
        'descripcion':
            rutina.descripcion.trim(),
        'ejercicios':
            ejerciciosSnapshot,
      },
    });
  }

  Future<void>
      quitarAsignacionFirestore({
    required String profesorId,
    required String alumnoId,
    required String asignacionId,
  }) async {
    final usuario =
        await _obtenerUsuarioActual();

    if (usuario.uid !=
        profesorId) {
      throw Exception(
        'No tenés permiso para quitar esta rutina.',
      );
    }

    final referencia =
        _firestore
            .collection(
              'rutinasAsignadas',
            )
            .doc(
              asignacionId,
            );

    final documento =
        await referencia.get();

    final datos =
        documento.data();

    if (datos == null) {
      throw Exception(
        'La asignación ya no existe.',
      );
    }

    if (datos['profesorId'] !=
            profesorId ||
        datos['alumnoId'] !=
            alumnoId) {
      throw Exception(
        'Esta asignación no pertenece a este alumno.',
      );
    }

    await referencia.update({
      'activa':
          false,
      'actualizadoEn':
          FieldValue.serverTimestamp(),
    });

    await _reordenarFirestore(
      profesorId:
          profesorId,
      alumnoId:
          alumnoId,
    );
  }

  Future<void>
      moverAsignacionFirestore({
    required String profesorId,
    required String alumnoId,
    required String asignacionId,
    required bool subir,
  }) async {
    final usuario =
        await _obtenerUsuarioActual();

    if (usuario.uid !=
        profesorId) {
      throw Exception(
        'No tenés permiso para mover esta rutina.',
      );
    }

    final consulta =
        await _firestore
            .collection(
              'rutinasAsignadas',
            )
            .where(
              'profesorId',
              isEqualTo: profesorId,
            )
            .where(
              'alumnoId',
              isEqualTo: alumnoId,
            )
            .where(
              'activa',
              isEqualTo: true,
            )
            .get();

    final asignaciones =
        consulta.docs.toList();

    asignaciones.sort(
      (a, b) {
        final diaA =
            a.data()['dia'];

        final diaB =
            b.data()['dia'];

        final aNumero =
            diaA is num
                ? diaA.toInt()
                : 0;

        final bNumero =
            diaB is num
                ? diaB.toInt()
                : 0;

        return aNumero.compareTo(
          bNumero,
        );
      },
    );

    final index =
        asignaciones.indexWhere(
      (documento) =>
          documento.id ==
          asignacionId,
    );

    if (index == -1) {
      return;
    }

    final nuevoIndex =
        subir
            ? index - 1
            : index + 1;

    if (nuevoIndex < 0 ||
        nuevoIndex >=
            asignaciones.length) {
      return;
    }

    final actual =
        asignaciones[index];

    final otro =
        asignaciones[nuevoIndex];

    final diaActual =
        (actual.data()['dia'] as num)
            .toInt();

    final diaOtro =
        (otro.data()['dia'] as num)
            .toInt();

    final batch =
        _firestore.batch();

    batch.update(
      actual.reference,
      {
        'dia':
            diaOtro,
        'actualizadoEn':
            FieldValue.serverTimestamp(),
      },
    );

    batch.update(
      otro.reference,
      {
        'dia':
            diaActual,
        'actualizadoEn':
            FieldValue.serverTimestamp(),
      },
    );

    await batch.commit();
  }

  Future<void> _reordenarFirestore({
    required String profesorId,
    required String alumnoId,
  }) async {
    final consulta =
        await _firestore
            .collection(
              'rutinasAsignadas',
            )
            .where(
              'profesorId',
              isEqualTo: profesorId,
            )
            .where(
              'alumnoId',
              isEqualTo: alumnoId,
            )
            .where(
              'activa',
              isEqualTo: true,
            )
            .get();

    final documentos =
        consulta.docs.toList();

    documentos.sort(
      (a, b) {
        final diaA =
            a.data()['dia'];

        final diaB =
            b.data()['dia'];

        final numeroA =
            diaA is num
                ? diaA.toInt()
                : 0;

        final numeroB =
            diaB is num
                ? diaB.toInt()
                : 0;

        return numeroA.compareTo(
          numeroB,
        );
      },
    );

    if (documentos.isEmpty) {
      return;
    }

    final batch =
        _firestore.batch();

    for (
      int i = 0;
      i < documentos.length;
      i++
    ) {
      final diaCorrecto =
          i + 1;

      final diaActual =
          documentos[i]
              .data()['dia'];

      if (diaActual is num &&
          diaActual.toInt() ==
              diaCorrecto) {
        continue;
      }

      batch.update(
        documentos[i].reference,
        {
          'dia':
              diaCorrecto,
          'actualizadoEn':
              FieldValue.serverTimestamp(),
        },
      );
    }

    await batch.commit();
  }

  // ============================================================
  // SQLITE / DRIFT ANTIGUO
  //
  // Lo mantenemos porque otras partes todavía pueden necesitarlo
  // durante la migración. Las nuevas vinculaciones reales usarán
  // los métodos Firestore de arriba.
  // ============================================================

  Future<List<db.RutinaAsignadaDb>>
      obtenerAsignacionesActivas(
    String alumnoId,
  ) async {
    return (database.select(
              database.rutinasAsignadas,
            )
          ..where(
            (tabla) =>
                tabla.alumnoId.equals(
                      alumnoId,
                    ) &
                tabla.activa.equals(
                  true,
                ),
          )
          ..orderBy([
            (tabla) =>
                OrderingTerm.asc(
              tabla.dia,
            ),
          ]))
        .get();
  }

  Future<void> asignarRutina({
    required String profesorId,
    required String alumnoId,
    required RutinaEditor rutina,
  }) async {
    final actuales =
        await obtenerAsignacionesActivas(
      alumnoId,
    );

    if (actuales.length >= 7) {
      throw Exception(
        'El alumno ya tiene 7 rutinas asignadas.',
      );
    }

    final dia =
        actuales.length + 1;

    final ahora =
        DateTime.now();

    await database
        .into(
          database.rutinasAsignadas,
        )
        .insert(
          db.RutinasAsignadasCompanion.insert(
            id:
                'asig_${alumnoId}_${ahora.microsecondsSinceEpoch}',
            rutinaId:
                rutina.id,
            profesorId:
                profesorId,
            alumnoId:
                alumnoId,
            dia:
                dia,
            activa:
                const Value(
              true,
            ),
            fechaAsignacion:
                ahora,
          ),
        );
  }

  Future<void> quitarAsignacion(
    String asignacionId,
  ) async {
    await (database.update(
              database.rutinasAsignadas,
            )
          ..where(
            (tabla) =>
                tabla.id.equals(
              asignacionId,
            ),
          ))
        .write(
      const db.RutinasAsignadasCompanion(
        activa:
            Value(
          false,
        ),
      ),
    );

    await reordenarAsignaciones();
  }

  Future<void> reordenarAsignaciones({
    String? alumnoId,
  }) async {
    if (alumnoId == null) {
      return;
    }

    final asignaciones =
        await obtenerAsignacionesActivas(
      alumnoId,
    );

    await database.transaction(
      () async {
        for (
          int i = 0;
          i < asignaciones.length;
          i++
        ) {
          await (database.update(
                    database
                        .rutinasAsignadas,
                  )
                ..where(
                  (tabla) =>
                      tabla.id.equals(
                    asignaciones[i].id,
                  ),
                ))
              .write(
            db.RutinasAsignadasCompanion(
              dia:
                  Value(
                i + 1,
              ),
            ),
          );
        }
      },
    );
  }

  Future<void>
      quitarAsignacionDeAlumno({
    required String alumnoId,
    required String asignacionId,
  }) async {
    await (database.update(
              database.rutinasAsignadas,
            )
          ..where(
            (tabla) =>
                tabla.id.equals(
              asignacionId,
            ),
          ))
        .write(
      const db.RutinasAsignadasCompanion(
        activa:
            Value(
          false,
        ),
      ),
    );

    await reordenarAsignaciones(
      alumnoId:
          alumnoId,
    );
  }

  Future<void> moverAsignacion({
    required String alumnoId,
    required String asignacionId,
    required bool subir,
  }) async {
    final asignaciones =
        await obtenerAsignacionesActivas(
      alumnoId,
    );

    final index =
        asignaciones.indexWhere(
      (item) =>
          item.id ==
          asignacionId,
    );

    if (index == -1) {
      return;
    }

    final nuevoIndex =
        subir
            ? index - 1
            : index + 1;

    if (nuevoIndex < 0 ||
        nuevoIndex >=
            asignaciones.length) {
      return;
    }

    final actual =
        asignaciones[index];

    final otro =
        asignaciones[nuevoIndex];

    await database.transaction(
      () async {
        await (database.update(
                  database
                      .rutinasAsignadas,
                )
              ..where(
                (tabla) =>
                    tabla.id.equals(
                  actual.id,
                ),
              ))
            .write(
          db.RutinasAsignadasCompanion(
            dia:
                Value(
              otro.dia,
            ),
          ),
        );

        await (database.update(
                  database
                      .rutinasAsignadas,
                )
              ..where(
                (tabla) =>
                    tabla.id.equals(
                  otro.id,
                ),
              ))
            .write(
          db.RutinasAsignadasCompanion(
            dia:
                Value(
              actual.dia,
            ),
          ),
        );
      },
    );
  }

  Future<db.RutinaDb?> obtenerRutina(
    String rutinaId,
  ) {
    return (database.select(
              database.rutinas,
            )
          ..where(
            (tabla) =>
                tabla.id.equals(
              rutinaId,
            ),
          ))
        .getSingleOrNull();
  }
}