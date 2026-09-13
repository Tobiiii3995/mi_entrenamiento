import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../base_datos/app_database.dart' as db;
import '../modelos/ejercicio_catalogo.dart';

class EjercicioRepositorio {
  final db.AppDatabase database;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  EjercicioRepositorio(
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
        'la biblioteca de este profesor.',
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

  Future<void> guardarEjercicio(
    EjercicioCatalogo ejercicio,
  ) async {
    await _validarProfesor(
      ejercicio.creadorId,
    );

    //
    // 1. Guardamos localmente.
    //
    await _guardarEjercicioLocal(
      ejercicio,
    );

    //
    // 2. Guardamos la misma versión
    //    en Firestore.
    //
    await _firestore
        .collection('ejerciciosProfesor')
        .doc(ejercicio.id)
        .set({
      'id':
          ejercicio.id,
      'creadorId':
          ejercicio.creadorId,
      'nombre':
          ejercicio.nombre.trim(),
      'descripcion':
          ejercicio.descripcion.trim(),
      'llevaPeso':
          ejercicio.llevaPeso,
      'grupoMuscular':
          ejercicio.grupoMuscular.trim(),
      'instrucciones':
          ejercicio.instrucciones.trim(),
      'eliminado':
          false,
      'actualizadoEn':
          FieldValue.serverTimestamp(),
    });
  }

  Future<void> _guardarEjercicioLocal(
    EjercicioCatalogo ejercicio,
  ) async {
    final ahora =
        DateTime.now();

    await database
        .into(database.ejercicios)
        .insertOnConflictUpdate(
          db.EjerciciosCompanion.insert(
            id:
                ejercicio.id,
            creadorId:
                ejercicio.creadorId,
            nombre:
                ejercicio.nombre.trim(),
            descripcion:
                Value(
              _textoNullable(
                ejercicio.descripcion,
              ),
            ),
            llevaPeso:
                Value(
              ejercicio.llevaPeso,
            ),
            grupoMuscular:
                Value(
              _textoNullable(
                ejercicio.grupoMuscular,
              ),
            ),
            instrucciones:
                Value(
              _textoNullable(
                ejercicio.instrucciones,
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
  }

  Future<List<EjercicioCatalogo>>
      obtenerEjerciciosDelProfesor(
    String profesorId,
  ) async {
    await _validarProfesor(
      profesorId,
    );

    try {
      final consulta =
          await _firestore
              .collection(
                'ejerciciosProfesor',
              )
              .where(
                'creadorId',
                isEqualTo: profesorId,
              )
              .get();

      //
      // Si todavía no existe nada en cloud,
      // migramos la biblioteca local existente.
      //
      if (consulta.docs.isEmpty) {
        final locales =
            await _obtenerEjerciciosLocales(
          profesorId,
        );

        if (locales.isNotEmpty) {
          await _migrarLocalesAFirestore(
            locales,
          );

          return locales;
        }

        return const [];
      }

      final resultado =
          <EjercicioCatalogo>[];

      for (final documento
          in consulta.docs) {
        final datos =
            documento.data();

        if (datos['eliminado'] == true) {
          continue;
        }

        final ejercicio =
            _desdeFirestore(
          documento.id,
          datos,
        );

        resultado.add(
          ejercicio,
        );

        //
        // Firestore es la fuente compartida.
        // Dejamos también una copia local.
        //
        await _guardarEjercicioLocal(
          ejercicio,
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
      // Si falla Internet temporalmente,
      // seguimos pudiendo trabajar con
      // la biblioteca local.
      //
      return _obtenerEjerciciosLocales(
        profesorId,
      );
    }
  }

  Future<List<EjercicioCatalogo>>
      _obtenerEjerciciosLocales(
    String profesorId,
  ) async {
    final registros =
        await (database.select(
                  database.ejercicios,
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

    return registros.map(
      (registro) {
        return EjercicioCatalogo(
          id:
              registro.id,
          creadorId:
              registro.creadorId,
          nombre:
              registro.nombre,
          descripcion:
              registro.descripcion ?? '',
          llevaPeso:
              registro.llevaPeso,
          grupoMuscular:
              registro.grupoMuscular ?? '',
          instrucciones:
              registro.instrucciones ?? '',
        );
      },
    ).toList();
  }

  Future<void> _migrarLocalesAFirestore(
    List<EjercicioCatalogo> ejercicios,
  ) async {
    if (ejercicios.isEmpty) {
      return;
    }

    final batch =
        _firestore.batch();

    for (final ejercicio
        in ejercicios) {
      final referencia =
          _firestore
              .collection(
                'ejerciciosProfesor',
              )
              .doc(
                ejercicio.id,
              );

      batch.set(
        referencia,
        {
          'id':
              ejercicio.id,
          'creadorId':
              ejercicio.creadorId,
          'nombre':
              ejercicio.nombre.trim(),
          'descripcion':
              ejercicio.descripcion.trim(),
          'llevaPeso':
              ejercicio.llevaPeso,
          'grupoMuscular':
              ejercicio.grupoMuscular.trim(),
          'instrucciones':
              ejercicio.instrucciones.trim(),
          'eliminado':
              false,
          'actualizadoEn':
              FieldValue.serverTimestamp(),
        },
      );
    }

    await batch.commit();
  }

  EjercicioCatalogo _desdeFirestore(
    String documentoId,
    Map<String, dynamic> datos,
  ) {
    return EjercicioCatalogo(
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
      llevaPeso:
          datos['llevaPeso'] == true,
      grupoMuscular:
          (datos['grupoMuscular'] ?? '')
              .toString(),
      instrucciones:
          (datos['instrucciones'] ?? '')
              .toString(),
    );
  }

  Future<EjercicioCatalogo?>
      obtenerEjercicio(
    String ejercicioId,
  ) async {
    final usuario =
        FirebaseAuth.instance.currentUser;

    if (usuario != null) {
      try {
        final documento =
            await _firestore
                .collection(
                  'ejerciciosProfesor',
                )
                .doc(
                  ejercicioId,
                )
                .get();

        final datos =
            documento.data();

        if (datos != null &&
            datos['eliminado'] != true) {
          final ejercicio =
              _desdeFirestore(
            documento.id,
            datos,
          );

          await _guardarEjercicioLocal(
            ejercicio,
          );

          return ejercicio;
        }
      } on FirebaseException {
        // Probamos la copia local.
      }
    }

    final registro =
        await (database.select(
                  database.ejercicios,
                )
              ..where(
                (tabla) =>
                    tabla.id.equals(
                          ejercicioId,
                        ) &
                    tabla.eliminado.equals(
                      false,
                    ),
              ))
            .getSingleOrNull();

    if (registro == null) {
      return null;
    }

    return EjercicioCatalogo(
      id:
          registro.id,
      creadorId:
          registro.creadorId,
      nombre:
          registro.nombre,
      descripcion:
          registro.descripcion ?? '',
      llevaPeso:
          registro.llevaPeso,
      grupoMuscular:
          registro.grupoMuscular ?? '',
      instrucciones:
          registro.instrucciones ?? '',
    );
  }

  Future<void> archivarEjercicio(
    String ejercicioId,
  ) async {
    final ejercicio =
        await obtenerEjercicio(
      ejercicioId,
    );

    if (ejercicio == null) {
      throw Exception(
        'No se encontró el ejercicio.',
      );
    }

    await _validarProfesor(
      ejercicio.creadorId,
    );

    await (database.update(
              database.ejercicios,
            )
          ..where(
            (tabla) =>
                tabla.id.equals(
              ejercicioId,
            ),
          ))
        .write(
      db.EjerciciosCompanion(
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
          'ejerciciosProfesor',
        )
        .doc(
          ejercicioId,
        )
        .update({
      'eliminado':
          true,
      'actualizadoEn':
          FieldValue.serverTimestamp(),
    });
  }

  Future<void> restaurarEjercicio(
    String ejercicioId,
  ) async {
    final usuario =
        await _obtenerUsuarioActual();

    final documento =
        await _firestore
            .collection(
              'ejerciciosProfesor',
            )
            .doc(
              ejercicioId,
            )
            .get();

    final datos =
        documento.data();

    if (datos == null) {
      throw Exception(
        'No se encontró el ejercicio.',
      );
    }

    if (datos['creadorId'] !=
        usuario.uid) {
      throw Exception(
        'No tenés permiso para restaurar '
        'este ejercicio.',
      );
    }

    await (database.update(
              database.ejercicios,
            )
          ..where(
            (tabla) =>
                tabla.id.equals(
              ejercicioId,
            ),
          ))
        .write(
      db.EjerciciosCompanion(
        eliminado:
            const Value(
          false,
        ),
        actualizadoEn:
            Value(
          DateTime.now(),
        ),
      ),
    );

    await _firestore
        .collection(
          'ejerciciosProfesor',
        )
        .doc(
          ejercicioId,
        )
        .update({
      'eliminado':
          false,
      'actualizadoEn':
          FieldValue.serverTimestamp(),
    });
  }

  String? _textoNullable(
    String texto,
  ) {
    final limpio =
        texto.trim();

    if (limpio.isEmpty) {
      return null;
    }

    return limpio;
  }
}