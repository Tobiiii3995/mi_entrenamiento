import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SolicitudVinculacion {
  final String id;
  final String profesorId;
  final String profesorNombre;
  final String alumnoId;
  final String codigo;
  final String estado;

  const SolicitudVinculacion({
    required this.id,
    required this.profesorId,
    required this.profesorNombre,
    required this.alumnoId,
    required this.codigo,
    required this.estado,
  });

  factory SolicitudVinculacion.desdeDocumento(
    QueryDocumentSnapshot<Map<String, dynamic>> documento,
  ) {
    final datos = documento.data();

    return SolicitudVinculacion(
      id: documento.id,
      profesorId:
          (datos['profesorId'] ?? '').toString(),
      profesorNombre:
          (datos['profesorNombre'] ?? '').toString(),
      alumnoId:
          (datos['alumnoId'] ?? '').toString(),
      codigo:
          (datos['codigo'] ?? '').toString(),
      estado:
          (datos['estado'] ?? '').toString(),
    );
  }
}

class VinculoProfesor {
  final String profesorId;
  final String profesorNombre;
  final String alumnoId;
  final String estado;

  const VinculoProfesor({
    required this.profesorId,
    required this.profesorNombre,
    required this.alumnoId,
    required this.estado,
  });

  factory VinculoProfesor.desdeDocumento(
    DocumentSnapshot<Map<String, dynamic>> documento,
  ) {
    final datos =
        documento.data() ?? {};

    return VinculoProfesor(
      profesorId:
          (datos['profesorId'] ?? '').toString(),
      profesorNombre:
          (datos['profesorNombre'] ?? '').toString(),
      alumnoId:
          (datos['alumnoId'] ?? '').toString(),
      estado:
          (datos['estado'] ?? '').toString(),
    );
  }
}

class VinculacionFirestoreServicio {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static const String _caracteres =
      'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  static String _generarCodigo() {
    final random = Random.secure();

    return List.generate(
      8,
      (_) => _caracteres[
        random.nextInt(
          _caracteres.length,
        )
      ],
    ).join();
  }

  static Future<User> _obtenerUsuarioActual() async {
    final usuario =
        FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      throw Exception(
        'No hay ningún usuario autenticado.',
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

  static Future<Map<String, dynamic>>
      _obtenerDatosUsuario(
    String usuarioId,
  ) async {
    final documento =
        await _firestore
            .collection('usuarios')
            .doc(usuarioId)
            .get();

    final datos =
        documento.data();

    if (datos == null) {
      throw Exception(
        'No se encontró el perfil del usuario.',
      );
    }

    return datos;
  }

  static Future<bool>
      tieneProfesorActivo(
    String alumnoId,
  ) async {
    final documento =
        await _firestore
            .collection(
              'vinculosActivos',
            )
            .doc(alumnoId)
            .get();

    return documento.exists;
  }

  static Future<void>
      asegurarVinculoLegacyAlumno() async {
    final usuario =
        await _obtenerUsuarioActual();

    final datosUsuario =
        await _obtenerDatosUsuario(
      usuario.uid,
    );

    if (datosUsuario['rol'] != 'alumno') {
      return;
    }

    final vinculoActual =
        await _firestore
            .collection(
              'vinculosActivos',
            )
            .doc(usuario.uid)
            .get();

    if (vinculoActual.exists) {
      return;
    }

    final relaciones =
        await _firestore
            .collection(
              'relacionesProfesorAlumno',
            )
            .where(
              'alumnoId',
              isEqualTo: usuario.uid,
            )
            .where(
              'estado',
              isEqualTo: 'activa',
            )
            .limit(1)
            .get();

    if (relaciones.docs.isEmpty) {
      return;
    }

    final relacion =
        relaciones.docs.first.data();

    final profesorId =
        (relacion['profesorId'] ?? '')
            .toString();

    if (profesorId.isEmpty) {
      return;
    }

    var profesorNombre =
        (relacion['profesorNombre'] ?? '')
            .toString()
            .trim();

    if (profesorNombre.isEmpty) {
      final solicitudId =
          '${profesorId}_${usuario.uid}';

      final solicitud =
          await _firestore
              .collection(
                'solicitudesVinculacion',
              )
              .doc(
                solicitudId,
              )
              .get();

      final datosSolicitud =
          solicitud.data();

      profesorNombre =
          (datosSolicitud?[
                      'profesorNombre'] ??
                  '')
              .toString()
              .trim();
    }

    if (profesorNombre.isEmpty ||
        profesorNombre == 'Profesor') {
      profesorNombre =
          'Profesor vinculado';
    }

    try {
      await _firestore
          .collection(
            'vinculosActivos',
          )
          .doc(usuario.uid)
          .set({
        'profesorId':
            profesorId,
        'profesorNombre':
            profesorNombre,
        'alumnoId':
            usuario.uid,
        'estado':
            'activa',
        'creadoEn':
            FieldValue.serverTimestamp(),
        'actualizadoEn':
            FieldValue.serverTimestamp(),
      });
    } on FirebaseException {
      // Si ya existe, no hacemos nada.
    }
  }

  static Stream<VinculoProfesor?>
      escucharVinculoActivo() {
    final usuario =
        FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return Stream.value(
        null,
      );
    }

    return _firestore
        .collection(
          'vinculosActivos',
        )
        .doc(usuario.uid)
        .snapshots()
        .map(
      (documento) {
        if (!documento.exists) {
          return null;
        }

        final vinculo =
            VinculoProfesor
                .desdeDocumento(
          documento,
        );

        if (vinculo.estado != 'activa') {
          return null;
        }

        return vinculo;
      },
    );
  }

  static Future<QuerySnapshot<Map<String, dynamic>>>
      _obtenerRutinasActivasDeRelacion({
    required String profesorId,
    required String alumnoId,
  }) async {
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
        .get();
  }

  static void _agregarDesactivacionRutinasAlBatch({
    required WriteBatch batch,
    required QuerySnapshot<Map<String, dynamic>>
        rutinas,
  }) {
    for (final documento in rutinas.docs) {
      final datos = documento.data();

      if (datos['activa'] != true) {
        continue;
      }

      batch.update(
        documento.reference,
        {
          'activa': false,
          'actualizadoEn':
              FieldValue.serverTimestamp(),
        },
      );
    }
  }

  static Future<void>
      _desactivarRutinasHuerfanasDelAlumno(
    String alumnoId,
  ) async {
    final rutinas =
        await _firestore
            .collection(
              'rutinasAsignadas',
            )
            .where(
              'alumnoId',
              isEqualTo: alumnoId,
            )
            .get();

    final activas = rutinas.docs.where(
      (documento) =>
          documento.data()['activa'] == true,
    );

    if (activas.isEmpty) {
      return;
    }

    final batch = _firestore.batch();

    for (final documento in activas) {
      batch.update(
        documento.reference,
        {
          'activa': false,
          'actualizadoEn':
              FieldValue.serverTimestamp(),
        },
      );
    }

    await batch.commit();
  }

  static Future<String>
      obtenerOCrearCodigoAlumno() async {
    final usuario =
        await _obtenerUsuarioActual();

    final datosUsuario =
        await _obtenerDatosUsuario(
      usuario.uid,
    );

    if (datosUsuario['rol'] != 'alumno') {
      throw Exception(
        'Solo los alumnos tienen código de vinculación.',
      );
    }

    if (datosUsuario['activo'] != true) {
      throw Exception(
        'La cuenta no está activa.',
      );
    }

    final tieneProfesor =
        await tieneProfesorActivo(
      usuario.uid,
    );

    if (tieneProfesor) {
      throw Exception(
        'Ya tenés un profesor vinculado.',
      );
    }

    //
    // Si no hay profesor activo, ninguna rutina
    // asignada por una relación anterior debe
    // seguir apareciendo como activa.
    //
    await _desactivarRutinasHuerfanasDelAlumno(
      usuario.uid,
    );

    final existentes =
        await _firestore
            .collection(
              'codigosVinculacion',
            )
            .where(
              'alumnoId',
              isEqualTo: usuario.uid,
            )
            .where(
              'activo',
              isEqualTo: true,
            )
            .limit(1)
            .get();

    if (existentes.docs.isNotEmpty) {
      final documento =
          existentes.docs.first;

      final datos =
          documento.data();

      final codigo =
          (datos['codigo'] ?? '')
              .toString()
              .trim()
              .toUpperCase();

      if (codigo.isNotEmpty) {
        if (documento.id != codigo) {
          final referenciaNueva =
              _firestore
                  .collection(
                    'codigosVinculacion',
                  )
                  .doc(codigo);

          try {
            await referenciaNueva.set({
              'codigo':
                  codigo,
              'alumnoId':
                  usuario.uid,
              'activo':
                  true,
              'creadoEn':
                  FieldValue.serverTimestamp(),
            });

            await documento.reference.update({
              'activo':
                  false,
              'actualizadoEn':
                  FieldValue.serverTimestamp(),
            });

            return codigo;
          } on FirebaseException {
            // Si no se puede migrar,
            // generamos un código nuevo.
          }
        } else {
          return codigo;
        }
      }
    }

    for (
      var intento = 0;
      intento < 15;
      intento++
    ) {
      final codigo =
          _generarCodigo();

      final referencia =
          _firestore
              .collection(
                'codigosVinculacion',
              )
              .doc(
                codigo,
              );

      try {
        await referencia.set({
          'codigo':
              codigo,
          'alumnoId':
              usuario.uid,
          'activo':
              true,
          'creadoEn':
              FieldValue.serverTimestamp(),
        });

        return codigo;
      } on FirebaseException catch (e) {
        if (e.code !=
            'permission-denied') {
          rethrow;
        }
      }
    }

    throw Exception(
      'No se pudo generar un código de vinculación.',
    );
  }

  static Future<Map<String, dynamic>> buscarAlumnoPorCodigo(
    String codigoIngresado,
  ) async {
    final usuario = await _obtenerUsuarioActual();

    final datosProfesor = await _obtenerDatosUsuario(
      usuario.uid,
    );

    if (datosProfesor['rol'] != 'profesor') {
      throw Exception('Solo un profesor puede buscar y vincular alumnos.');
    }

    final codigo = codigoIngresado.trim().toUpperCase();

    if (codigo.length != 8) {
      throw Exception('Ingresá un código válido de 8 caracteres.');
    }

    final codigoDoc = await _firestore
        .collection('codigosVinculacion')
        .doc(codigo)
        .get();

    final datosCodigo = codigoDoc.data();

    if (datosCodigo == null || datosCodigo['activo'] != true) {
      throw Exception('El código ingresado no existe o ya no está activo.');
    }

    final alumnoId = (datosCodigo['alumnoId'] ?? '').toString();

    if (alumnoId.isEmpty) {
      throw Exception('El código no tiene un alumno válido.');
    }

    if (alumnoId == usuario.uid) {
      throw Exception('No podés vincularte con tu propia cuenta.');
    }

    final vinculoActivo = await _firestore
        .collection('vinculosActivos')
        .doc(alumnoId)
        .get();

    if (vinculoActivo.exists) {
      final datos = vinculoActivo.data();
      final profesorActualId = (datos?['profesorId'] ?? '').toString();

      if (profesorActualId == usuario.uid) {
        throw Exception('Este alumno ya está vinculado contigo.');
      }

      throw Exception('Este alumno ya tiene un profesor vinculado.');
    }

    final docAlumno = await _firestore.collection('usuarios').doc(alumnoId).get();
    final datosAlumno = docAlumno.data() ?? {};

    return {
      'alumnoId': alumnoId,
      'nombre': (datosAlumno['nombre'] ?? 'Alumno').toString().trim(),
      'correo': (datosAlumno['correo'] ?? '').toString().trim(),
      'fotoUrl': (datosAlumno['fotoUrl'] ?? '').toString().trim(),
      'codigo': codigo,
    };
  }

  static Future<void>
      enviarSolicitudPorCodigo(
    String codigoIngresado,
  ) async {
    final usuario =
        await _obtenerUsuarioActual();

    final datosProfesor =
        await _obtenerDatosUsuario(
      usuario.uid,
    );

    if (datosProfesor['rol'] !=
        'profesor') {
      throw Exception(
        'Solo un profesor puede enviar solicitudes.',
      );
    }

    if (datosProfesor['activo'] != true) {
      throw Exception(
        'La cuenta del profesor no está activa.',
      );
    }

    var nombreProfesor =
        (datosProfesor['nombre'] ?? '')
            .toString()
            .trim();

    if (nombreProfesor.isEmpty) {
      nombreProfesor =
          (usuario.displayName ?? '')
              .trim();
    }

    if (nombreProfesor.isEmpty) {
      throw Exception(
        'Completá tu nombre en el perfil antes de vincular alumnos.',
      );
    }

    final codigo =
        codigoIngresado
            .trim()
            .toUpperCase();

    if (codigo.length != 8) {
      throw Exception(
        'Ingresá un código válido de 8 caracteres.',
      );
    }

    final codigoDoc =
        await _firestore
            .collection(
              'codigosVinculacion',
            )
            .doc(
              codigo,
            )
            .get();

    final datosCodigo =
        codigoDoc.data();

    if (datosCodigo == null ||
        datosCodigo['activo'] != true) {
      throw Exception(
        'El código ingresado no existe o ya no está activo.',
      );
    }

    final alumnoId =
        (datosCodigo['alumnoId'] ?? '')
            .toString();

    if (alumnoId.isEmpty) {
      throw Exception(
        'El código no tiene un alumno válido.',
      );
    }

    if (alumnoId == usuario.uid) {
      throw Exception(
        'No podés vincularte con tu propia cuenta.',
      );
    }

    final vinculoActivo =
        await _firestore
            .collection(
              'vinculosActivos',
            )
            .doc(
              alumnoId,
            )
            .get();

    if (vinculoActivo.exists) {
      final datos =
          vinculoActivo.data();

      final profesorActualId =
          (datos?['profesorId'] ?? '')
              .toString();

      if (profesorActualId ==
          usuario.uid) {
        throw Exception(
          'Este alumno ya está vinculado contigo.',
        );
      }

      throw Exception(
        'Este alumno ya tiene un profesor vinculado.',
      );
    }

    final solicitudId =
        '${usuario.uid}_$alumnoId';

    final referenciaSolicitud =
        _firestore
            .collection(
              'solicitudesVinculacion',
            )
            .doc(
              solicitudId,
            );

    try {
      await referenciaSolicitud.set({
        'profesorId':
            usuario.uid,
        'profesorNombre':
            nombreProfesor,
        'alumnoId':
            alumnoId,
        'codigo':
            codigo,
        'estado':
            'pendiente',
        'creadoEn':
            FieldValue.serverTimestamp(),
        'respondidoEn':
            null,
      });
    } on FirebaseException catch (e) {
      if (e.code ==
          'permission-denied') {
        throw Exception(
          'No se pudo enviar la solicitud. '
          'El alumno puede tener ya un profesor vinculado.',
        );
      }

      rethrow;
    }
  }

  static Stream<List<SolicitudVinculacion>>
      escucharSolicitudesPendientes() {
    final usuario =
        FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return Stream.value(
        const [],
      );
    }

    return _firestore
        .collection(
          'solicitudesVinculacion',
        )
        .where(
          'alumnoId',
          isEqualTo: usuario.uid,
        )
        .where(
          'estado',
          isEqualTo: 'pendiente',
        )
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map(
              SolicitudVinculacion
                  .desdeDocumento,
            )
            .toList();
      },
    );
  }

  static Future<void>
      aceptarSolicitud(
    SolicitudVinculacion solicitud,
  ) async {
    final usuario =
        await _obtenerUsuarioActual();

    if (solicitud.alumnoId !=
        usuario.uid) {
      throw Exception(
        'Esta solicitud no pertenece a tu cuenta.',
      );
    }

    if (solicitud.estado !=
        'pendiente') {
      throw Exception(
        'La solicitud ya fue respondida.',
      );
    }

    final vinculoActual =
        await _firestore
            .collection(
              'vinculosActivos',
            )
            .doc(
              usuario.uid,
            )
            .get();

    if (vinculoActual.exists) {
      throw Exception(
        'Ya tenés un profesor vinculado.',
      );
    }

    final solicitudRef =
        _firestore
            .collection(
              'solicitudesVinculacion',
            )
            .doc(
              solicitud.id,
            );

    final relacionId =
        '${solicitud.profesorId}_${usuario.uid}';

    final relacionRef =
        _firestore
            .collection(
              'relacionesProfesorAlumno',
            )
            .doc(
              relacionId,
            );

    final vinculoRef =
        _firestore
            .collection(
              'vinculosActivos',
            )
            .doc(
              usuario.uid,
            );

    final codigoRef =
        _firestore
            .collection(
              'codigosVinculacion',
            )
            .doc(
              solicitud.codigo,
            );

    final pendientes =
        await _firestore
            .collection(
              'solicitudesVinculacion',
            )
            .where(
              'alumnoId',
              isEqualTo: usuario.uid,
            )
            .where(
              'estado',
              isEqualTo: 'pendiente',
            )
            .get();

    final batch =
        _firestore.batch();

    batch.set(
      vinculoRef,
      {
        'profesorId':
            solicitud.profesorId,
        'profesorNombre':
            solicitud.profesorNombre,
        'alumnoId':
            usuario.uid,
        'estado':
            'activa',
        'creadoEn':
            FieldValue.serverTimestamp(),
        'actualizadoEn':
            FieldValue.serverTimestamp(),
      },
    );

    batch.set(
      relacionRef,
      {
        'profesorId':
            solicitud.profesorId,
        'profesorNombre':
            solicitud.profesorNombre,
        'alumnoId':
            usuario.uid,
        'estado':
            'activa',
        'creadoEn':
            FieldValue.serverTimestamp(),
        'actualizadoEn':
            FieldValue.serverTimestamp(),
        'finalizadoEn':
            null,
      },
      SetOptions(
        merge: true,
      ),
    );

    batch.update(
      solicitudRef,
      {
        'estado':
            'aceptada',
        'respondidoEn':
            FieldValue.serverTimestamp(),
      },
    );

    batch.update(
      codigoRef,
      {
        'activo':
            false,
        'actualizadoEn':
            FieldValue.serverTimestamp(),
      },
    );

    for (final documento
        in pendientes.docs) {
      if (documento.id ==
          solicitud.id) {
        continue;
      }

      batch.update(
        documento.reference,
        {
          'estado':
              'cancelada',
          'respondidoEn':
              FieldValue.serverTimestamp(),
        },
      );
    }

    try {
      await batch.commit();
    } on FirebaseException catch (e) {
      if (e.code ==
          'permission-denied') {
        throw Exception(
          'No se pudo completar la vinculación. '
          'Es posible que ya tengas un profesor.',
        );
      }

      rethrow;
    }
  }

  static Future<void>
      rechazarSolicitud(
    SolicitudVinculacion solicitud,
  ) async {
    final usuario =
        await _obtenerUsuarioActual();

    if (solicitud.alumnoId !=
        usuario.uid) {
      throw Exception(
        'Esta solicitud no pertenece a tu cuenta.',
      );
    }

    if (solicitud.estado !=
        'pendiente') {
      throw Exception(
        'La solicitud ya fue respondida.',
      );
    }

    await _firestore
        .collection(
          'solicitudesVinculacion',
        )
        .doc(
          solicitud.id,
        )
        .update({
      'estado':
          'rechazada',
      'respondidoEn':
          FieldValue.serverTimestamp(),
    });
  }

  static Future<String>
      desvincularProfesor(
    VinculoProfesor vinculo,
  ) async {
    final usuario =
        await _obtenerUsuarioActual();

    if (vinculo.alumnoId !=
        usuario.uid) {
      throw Exception(
        'Este vínculo no pertenece a tu cuenta.',
      );
    }

    final vinculoRef =
        _firestore
            .collection(
              'vinculosActivos',
            )
            .doc(
              usuario.uid,
            );

    final relacionId =
        '${vinculo.profesorId}_${usuario.uid}';

    final relacionRef =
        _firestore
            .collection(
              'relacionesProfesorAlumno',
            )
            .doc(
              relacionId,
            );

    final relacionDoc =
        await relacionRef.get();

    if (!relacionDoc.exists) {
      throw Exception(
        'No se encontró la relación con el profesor.',
      );
    }

    final datosRelacion =
        relacionDoc.data();

    if (datosRelacion == null ||
        datosRelacion['estado'] !=
            'activa') {
      throw Exception(
        'La relación ya no está activa.',
      );
    }

    final rutinasRelacion =
        await _obtenerRutinasActivasDeRelacion(
      profesorId:
          vinculo.profesorId,
      alumnoId:
          usuario.uid,
    );

    final batch =
        _firestore.batch();

    _agregarDesactivacionRutinasAlBatch(
      batch:
          batch,
      rutinas:
          rutinasRelacion,
    );

    batch.update(
      relacionRef,
      {
        'estado':
            'finalizada',
        'actualizadoEn':
            FieldValue.serverTimestamp(),
        'finalizadoEn':
            FieldValue.serverTimestamp(),
      },
    );

    batch.delete(
      vinculoRef,
    );

    try {
      await batch.commit();
    } on FirebaseException catch (e) {
      if (e.code ==
          'permission-denied') {
        throw Exception(
          'No se pudo desvincular al profesor '
          'por un problema de permisos.',
        );
      }

      rethrow;
    }

    return obtenerOCrearCodigoAlumno();
  }

  static Future<void>
      desvincularAlumnoComoProfesor({
    required String alumnoId,
  }) async {
    final usuario =
        await _obtenerUsuarioActual();

    final datosProfesor =
        await _obtenerDatosUsuario(
      usuario.uid,
    );

    if (datosProfesor['rol'] !=
        'profesor') {
      throw Exception(
        'Solo un profesor puede realizar esta acción.',
      );
    }

    if (datosProfesor['activo'] != true) {
      throw Exception(
        'La cuenta del profesor no está activa.',
      );
    }

    if (alumnoId.trim().isEmpty) {
      throw Exception(
        'El alumno no es válido.',
      );
    }

    final relacionId =
        '${usuario.uid}_$alumnoId';

    final relacionRef =
        _firestore
            .collection(
              'relacionesProfesorAlumno',
            )
            .doc(
              relacionId,
            );

    final vinculoRef =
        _firestore
            .collection(
              'vinculosActivos',
            )
            .doc(
              alumnoId,
            );

    final relacionDoc =
        await relacionRef.get();

    final datosRelacion =
        relacionDoc.data();

    if (datosRelacion == null) {
      throw Exception(
        'No se encontró la relación con el alumno.',
      );
    }

    if (datosRelacion['profesorId'] !=
        usuario.uid) {
      throw Exception(
        'Este alumno no pertenece a tu cuenta.',
      );
    }

    if (datosRelacion['alumnoId'] !=
        alumnoId) {
      throw Exception(
        'La relación del alumno no es válida.',
      );
    }

    if (datosRelacion['estado'] !=
        'activa') {
      throw Exception(
        'Este alumno ya no está vinculado.',
      );
    }

    final vinculoDoc =
        await vinculoRef.get();

    final datosVinculo =
        vinculoDoc.data();

    if (datosVinculo == null) {
      throw Exception(
        'El vínculo activo ya no existe.',
      );
    }

    if (datosVinculo['profesorId'] !=
        usuario.uid) {
      throw Exception(
        'El alumno está vinculado con otro profesor.',
      );
    }

    final rutinasRelacion =
        await _obtenerRutinasActivasDeRelacion(
      profesorId:
          usuario.uid,
      alumnoId:
          alumnoId,
    );

    final batch =
        _firestore.batch();

    _agregarDesactivacionRutinasAlBatch(
      batch:
          batch,
      rutinas:
          rutinasRelacion,
    );

    batch.update(
      relacionRef,
      {
        'estado':
            'finalizada',
        'actualizadoEn':
            FieldValue.serverTimestamp(),
        'finalizadoEn':
            FieldValue.serverTimestamp(),
      },
    );

    batch.delete(
      vinculoRef,
    );

    try {
      await batch.commit();
    } on FirebaseException catch (e) {
      if (e.code ==
          'permission-denied') {
        throw Exception(
          'No tenés permisos para desvincular este alumno.',
        );
      }

      rethrow;
    }
  }
}