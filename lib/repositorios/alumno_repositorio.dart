import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../base_datos/app_database.dart' as db;
import '../modelos/alumno_profesor.dart';

class AlumnoRepositorio {
  final db.AppDatabase database;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  AlumnoRepositorio(
    this.database,
  );

  // ============================================================
  // ALUMNOS REALES - FIRESTORE
  // ============================================================

  Stream<List<AlumnoProfesor>>
      escucharAlumnosVinculados(
    String profesorId,
  ) {
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
          'relacionesProfesorAlumno',
        )
        .where(
          'profesorId',
          isEqualTo: profesorId,
        )
        .where(
          'estado',
          isEqualTo: 'activa',
        )
        .snapshots()
        .asyncMap(
      (snapshot) async {
        final resultado =
            <AlumnoProfesor>[];

        for (final relacion
            in snapshot.docs) {
          final datosRelacion =
              relacion.data();

          final alumnoId =
              (datosRelacion[
                          'alumnoId'] ??
                      '')
                  .toString();

          if (alumnoId.isEmpty) {
            continue;
          }

          try {
            final documentoAlumno =
                await _firestore
                    .collection(
                      'usuarios',
                    )
                    .doc(
                      alumnoId,
                    )
                    .get();

            final datosAlumno =
                documentoAlumno.data();

            if (datosAlumno == null) {
              continue;
            }

            final nombre =
                (datosAlumno[
                            'nombre'] ??
                        '')
                    .toString()
                    .trim();

            final correo =
                (datosAlumno[
                            'correo'] ??
                        '')
                    .toString()
                    .trim();

            resultado.add(
              AlumnoProfesor(
                id: alumnoId,
                nombre:
                    nombre.isEmpty
                        ? 'Alumno'
                        : nombre,
                correo: correo,
              ),
            );
          } on FirebaseException {
            continue;
          }
        }

        resultado.sort(
          (a, b) =>
              a.nombre
                  .toLowerCase()
                  .compareTo(
                    b.nombre
                        .toLowerCase(),
                  ),
        );

        return resultado;
      },
    );
  }

  Future<List<AlumnoProfesor>>
      obtenerAlumnosVinculados(
    String profesorId,
  ) async {
    final usuario =
        FirebaseAuth.instance.currentUser;

    if (usuario == null ||
        usuario.uid != profesorId) {
      return [];
    }

    final relaciones =
        await _firestore
            .collection(
              'relacionesProfesorAlumno',
            )
            .where(
              'profesorId',
              isEqualTo: profesorId,
            )
            .where(
              'estado',
              isEqualTo: 'activa',
            )
            .get();

    final resultado =
        <AlumnoProfesor>[];

    for (final relacion
        in relaciones.docs) {
      final alumnoId =
          (relacion.data()[
                      'alumnoId'] ??
                  '')
              .toString();

      if (alumnoId.isEmpty) {
        continue;
      }

      final documentoAlumno =
          await _firestore
              .collection('usuarios')
              .doc(alumnoId)
              .get();

      final datosAlumno =
          documentoAlumno.data();

      if (datosAlumno == null) {
        continue;
      }

      final nombre =
          (datosAlumno['nombre'] ?? '')
              .toString()
              .trim();

      final correo =
          (datosAlumno['correo'] ?? '')
              .toString()
              .trim();

      resultado.add(
        AlumnoProfesor(
          id: alumnoId,
          nombre:
              nombre.isEmpty
                  ? 'Alumno'
                  : nombre,
          correo: correo,
        ),
      );
    }

    resultado.sort(
      (a, b) =>
          a.nombre
              .toLowerCase()
              .compareTo(
                b.nombre
                    .toLowerCase(),
              ),
    );

    return resultado;
  }

  // ============================================================
  // FUNCIONES LOCALES ANTIGUAS
  //
  // Las mantenemos temporalmente porque otras partes de la app
  // podrían seguir utilizándolas durante la migración.
  // Ya NO serán usadas por AlumnosProfesorPagina.
  // ============================================================

  Future<void> crearAlumnoLocal({
    required String id,
    required String nombre,
    required String correo,
    required String profesorId,
  }) async {
    await database.transaction(
      () async {
        await database
            .into(
              database.usuarios,
            )
            .insertOnConflictUpdate(
              db.UsuariosCompanion.insert(
                id: id,
                nombre:
                    nombre.trim(),
                correo: Value(
                  correo.trim().isEmpty
                      ? null
                      : correo.trim(),
                ),
                rol: 'alumno',
                actualizadoEn:
                    Value(
                  DateTime.now(),
                ),
              ),
            );

        await database
            .into(
              database
                  .relacionesProfesorAlumno,
            )
            .insertOnConflictUpdate(
              db.RelacionesProfesorAlumnoCompanion
                  .insert(
                id:
                    'rel_${profesorId}_$id',
                profesorId:
                    profesorId,
                alumnoId: id,
                estado:
                    const Value(
                  'activo',
                ),
              ),
            );
      },
    );
  }

  Future<List<AlumnoProfesor>>
      obtenerAlumnos(
    String profesorId,
  ) async {
    final relaciones =
        await (database.select(
                  database
                      .relacionesProfesorAlumno,
                )
              ..where(
                (tabla) =>
                    tabla.profesorId
                        .equals(
                      profesorId,
                    ) &
                    tabla.estado.equals(
                      'activo',
                    ),
              ))
            .get();

    final resultado =
        <AlumnoProfesor>[];

    for (final relacion
        in relaciones) {
      final usuario =
          await (database.select(
                    database.usuarios,
                  )
                ..where(
                  (tabla) =>
                      tabla.id.equals(
                    relacion.alumnoId,
                  ),
                ))
              .getSingleOrNull();

      if (usuario == null) {
        continue;
      }

      resultado.add(
        AlumnoProfesor(
          id: usuario.id,
          nombre:
              usuario.nombre,
          correo:
              usuario.correo ?? '',
        ),
      );
    }

    resultado.sort(
      (a, b) =>
          a.nombre
              .toLowerCase()
              .compareTo(
                b.nombre
                    .toLowerCase(),
              ),
    );

    return resultado;
  }
}