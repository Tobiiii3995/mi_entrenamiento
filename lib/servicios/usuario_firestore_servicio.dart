import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsuarioFirestoreServicio {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final RegExp _nombreValido =
      RegExp(
    r'^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ ]+$',
  );

  static String _normalizarNombre(
    String nombre,
  ) {
    return nombre
        .trim()
        .replaceAll(
          RegExp(r' +'),
          ' ',
        );
  }

  static void _validarNombre(
    String nombre,
  ) {
    final limpio =
        _normalizarNombre(
      nombre,
    );

    if (limpio.length < 2 ||
        limpio.length > 60 ||
        !_nombreValido.hasMatch(
          limpio,
        )) {
      throw Exception(
        'El nombre solo puede contener letras y espacios y debe tener entre 2 y 60 caracteres.',
      );
    }
  }

  static Future<User>
      _obtenerUsuarioVerificado() async {
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

  static Future<
          DocumentSnapshot<Map<String, dynamic>>>
      _obtenerDocumentoConFallbackCache(
    DocumentReference<Map<String, dynamic>>
        referencia,
  ) async {
    try {
      //
      // Intentamos primero servidor, pero con
      // un límite corto. No queremos que el
      // arranque quede esperando indefinidamente.
      //
      return await referencia
          .get(
            const GetOptions(
              source:
                  Source.server,
            ),
          )
          .timeout(
            const Duration(
              seconds: 3,
            ),
          );
    } catch (_) {
      //
      // Sin red o con servidor lento:
      // usamos inmediatamente la copia persistida
      // por Firestore en el dispositivo.
      //
      return referencia.get(
        const GetOptions(
          source:
              Source.cache,
        ),
      );
    }
  }

  static DocumentReference<Map<String, dynamic>>
      _referenciaRegistroPeso(
    String registroId,
  ) {
    return _firestore
        .collection(
          'registrosPesoAlumno',
        )
        .doc(
          registroId,
        );
  }

  static Map<String, dynamic>
      _datosRegistroPeso({
    required String id,
    required String alumnoId,
    required double peso,
    required DateTime fecha,
    required String origen,
  }) {
    return {
      'id': id,
      'alumnoId': alumnoId,
      'peso': peso,
      'fecha':
          Timestamp.fromDate(
        fecha,
      ),
      'origen':
          origen,
      'creadoEn':
          FieldValue.serverTimestamp(),
    };
  }

  static Future<Map<String, dynamic>>
      asegurarYObtenerUsuarioActual() async {
    final usuarioAuth =
        FirebaseAuth.instance.currentUser;

    if (usuarioAuth == null) {
      throw Exception(
        'No hay ningún usuario autenticado.',
      );
    }

    final referencia =
        _firestore
            .collection(
              'usuarios',
            )
            .doc(
              usuarioAuth.uid,
            );

    var documento =
        await _obtenerDocumentoConFallbackCache(
      referencia,
    );

    if (!documento.exists) {
      //
      // Si no hay documento y estamos sin red,
      // no intentamos inventar un perfil nuevo.
      //
      // Para una cuenta que ya se usó antes,
      // normalmente el documento estará en caché.
      //
      if (documento.metadata.isFromCache) {
        throw Exception(
          'No hay datos del perfil disponibles sin conexión.',
        );
      }

      final nombreAuth =
          _normalizarNombre(
        usuarioAuth.displayName ??
            '',
      );

      await referencia.set(
        {
          'uid':
              usuarioAuth.uid,
          'correo':
              usuarioAuth.email ??
                  '',
          'nombre':
              nombreAuth,
          'rol':
              'alumno',
          'activo':
              true,
          'perfilCompleto':
              false,
          'creadoEn':
              FieldValue.serverTimestamp(),
          'actualizadoEn':
              FieldValue.serverTimestamp(),
        },
      );

      documento =
          await _obtenerDocumentoConFallbackCache(
        referencia,
      );
    }

    final datos =
        documento.data();

    if (datos == null) {
      throw Exception(
        'No se pudieron obtener los datos del usuario.',
      );
    }

    final resultado =
        Map<String, dynamic>.from(
      datos,
    );

    final correoAuth =
        usuarioAuth.email ??
            '';

    final correoFirestore =
        (datos['correo'] ??
                '')
            .toString();

    final perfilCompleto =
        datos['perfilCompleto'] ==
            true;

    //
    // Si la lectura vino del servidor y hay un
    // correo nuevo, sincronizamos sin bloquear
    // el arranque de la aplicación.
    //
    if (!documento
            .metadata
            .isFromCache &&
        usuarioAuth.emailVerified &&
        perfilCompleto &&
        correoAuth.isNotEmpty &&
        correoAuth !=
            correoFirestore) {
      resultado['correo'] =
          correoAuth;

      unawaited(
        referencia.update(
          {
            'correo':
                correoAuth,
            'actualizadoEn':
                FieldValue.serverTimestamp(),
          },
        ).catchError(
          (_) {
            // No bloquea el inicio.
          },
        ),
      );
    }

    return resultado;
  }

  static Future<Map<String, dynamic>>
      obtenerUsuarioActual() async {
    final usuarioAuth =
        FirebaseAuth.instance.currentUser;

    if (usuarioAuth == null) {
      throw Exception(
        'No hay ningún usuario autenticado.',
      );
    }

    final referencia =
        _firestore
            .collection(
              'usuarios',
            )
            .doc(
              usuarioAuth.uid,
            );

    final documento =
        await _obtenerDocumentoConFallbackCache(
      referencia,
    );

    final datos =
        documento.data();

    if (datos == null) {
      throw Exception(
        'No se encontró el perfil del usuario.',
      );
    }

    return datos;
  }

  static Future<void>
      crearPerfilInicial({
    required String nombre,
  }) async {
    final usuarioAuth =
        FirebaseAuth.instance.currentUser;

    if (usuarioAuth == null) {
      throw Exception(
        'No hay ningún usuario autenticado.',
      );
    }

    final nombreLimpio =
        _normalizarNombre(
      nombre,
    );

    _validarNombre(
      nombreLimpio,
    );

    await usuarioAuth
        .updateDisplayName(
      nombreLimpio,
    );

    final referencia =
        _firestore
            .collection(
              'usuarios',
            )
            .doc(
              usuarioAuth.uid,
            );

    final documento =
        await referencia.get();

    if (!documento.exists) {
      await referencia.set(
        {
          'uid':
              usuarioAuth.uid,
          'correo':
              usuarioAuth.email ??
                  '',
          'nombre':
              nombreLimpio,
          'rol':
              'alumno',
          'activo':
              true,
          'perfilCompleto':
              false,
          'creadoEn':
              FieldValue.serverTimestamp(),
          'actualizadoEn':
              FieldValue.serverTimestamp(),
        },
      );

      return;
    }

    final datos =
        documento.data();

    final perfilCompleto =
        datos?[
                'perfilCompleto'] ==
            true;

    if (perfilCompleto) {
      throw Exception(
        'El perfil ya fue completado.',
      );
    }

    await referencia.update(
      {
        'nombre':
            nombreLimpio,
        'correo':
            usuarioAuth.email ??
                '',
        'actualizadoEn':
            FieldValue.serverTimestamp(),
      },
    );
  }

  static Future<Map<String, dynamic>>
      completarPerfilActual({
    required DateTime fechaNacimiento,
    required int edad,
    required double altura,
    required double peso,
    required String objetivo,
  }) async {
    final usuarioActualizado =
        await _obtenerUsuarioVerificado();

    final referencia =
        _firestore
            .collection(
              'usuarios',
            )
            .doc(
              usuarioActualizado.uid,
            );

    final documentoAnterior =
        await referencia.get();

    final datosAnteriores =
        documentoAnterior.data();

    final nombre =
        _normalizarNombre(
      (datosAnteriores?[
                  'nombre'] ??
              usuarioActualizado
                  .displayName ??
              '')
          .toString(),
    );

    _validarNombre(
      nombre,
    );

    final rol =
        (datosAnteriores?[
                    'rol'] ??
                'alumno')
            .toString();

    final activo =
        datosAnteriores?[
                'activo'] !=
            false;

    final ahora =
        DateTime.now();

    final registroInicialId =
        'inicial_${usuarioActualizado.uid}';

    final registroInicialRef =
        _referenciaRegistroPeso(
      registroInicialId,
    );

    final registroInicialDoc =
        await registroInicialRef
            .get();

    final batch =
        _firestore.batch();

    batch.set(
      referencia,
      {
        'uid':
            usuarioActualizado.uid,
        'correo':
            usuarioActualizado.email ??
                '',
        'nombre':
            nombre,
        'rol':
            rol,
        'activo':
            activo,
        'fechaNacimiento':
            Timestamp.fromDate(
          fechaNacimiento,
        ),
        'edad':
            edad,
        'altura':
            altura,
        'peso':
            peso,
        'objetivo':
            objetivo,
        'perfilCompleto':
            true,
        'actualizadoEn':
            FieldValue.serverTimestamp(),
        if (!documentoAnterior
            .exists)
          'creadoEn':
              FieldValue.serverTimestamp(),
      },
      SetOptions(
        merge:
            true,
      ),
    );

    if (!registroInicialDoc
        .exists) {
      batch.set(
        registroInicialRef,
        _datosRegistroPeso(
          id:
              registroInicialId,
          alumnoId:
              usuarioActualizado.uid,
          peso:
              peso,
          fecha:
              ahora,
          origen:
              'perfil_inicial',
        ),
      );
    }

    await batch.commit();

    final documento =
        await referencia.get();

    final datos =
        documento.data();

    if (datos == null) {
      throw Exception(
        'No se pudo actualizar el perfil.',
      );
    }

    return datos;
  }

  static Future<void>
      actualizarPerfilActual({
    required String nombre,
    required DateTime fechaNacimiento,
    required int edad,
    required double altura,
    required double peso,
    required String objetivo,
    String? fotoUrl,
  }) async {
    final usuarioAuth =
        await _obtenerUsuarioVerificado();

    final nombreLimpio =
        _normalizarNombre(
      nombre,
    );

    _validarNombre(
      nombreLimpio,
    );

    await usuarioAuth
        .updateDisplayName(
      nombreLimpio,
    );

    final referenciaUsuario =
        _firestore
            .collection(
              'usuarios',
            )
            .doc(
              usuarioAuth.uid,
            );

    final documentoAnterior =
        await referenciaUsuario
            .get();

    final datosAnteriores =
        documentoAnterior.data();

    if (datosAnteriores ==
        null) {
      throw Exception(
        'No se encontró el perfil del usuario.',
      );
    }

    final pesoAnteriorDato =
        datosAnteriores[
            'peso'];

    final pesoAnterior =
        pesoAnteriorDato is num
            ? pesoAnteriorDato
                .toDouble()
            : null;

    final cambioPeso =
        pesoAnterior == null ||
            (pesoAnterior -
                        peso)
                    .abs() >
                0.0001;

    final ahora =
        DateTime.now();

    final batch =
        _firestore.batch();

    final mapaActualizacion = <String, dynamic>{
      'nombre':
          nombreLimpio,
      'correo':
          usuarioAuth.email ??
              '',
      'fechaNacimiento':
          Timestamp.fromDate(
        fechaNacimiento,
      ),
      'edad':
          edad,
      'altura':
          altura,
      'peso':
          peso,
      'objetivo':
          objetivo,
      'perfilCompleto':
          true,
      'actualizadoEn':
          FieldValue.serverTimestamp(),
    };

    if (fotoUrl != null) {
      mapaActualizacion['fotoUrl'] = fotoUrl;
    }

    batch.update(
      referenciaUsuario,
      mapaActualizacion,
    );

    if (cambioPeso) {
      final existentes =
          await _firestore
              .collection(
                'registrosPesoAlumno',
              )
              .where(
                'alumnoId',
                isEqualTo:
                    usuarioAuth.uid,
              )
              .limit(
                1,
              )
              .get();

      if (existentes
              .docs
              .isEmpty &&
          pesoAnterior !=
              null &&
          pesoAnterior > 0) {
        final fechaAnteriorDato =
            datosAnteriores[
                'actualizadoEn'];

        final fechaAnterior =
            fechaAnteriorDato
                    is Timestamp
                ? fechaAnteriorDato
                    .toDate()
                : ahora.subtract(
                    const Duration(
                      milliseconds:
                          1,
                    ),
                  );

        final idAnterior =
            'migrado_inicial_${usuarioAuth.uid}';

        batch.set(
          _referenciaRegistroPeso(
            idAnterior,
          ),
          _datosRegistroPeso(
            id:
                idAnterior,
            alumnoId:
                usuarioAuth.uid,
            peso:
                pesoAnterior,
            fecha:
                fechaAnterior,
            origen:
                'migracion_perfil',
          ),
        );
      }

      final registroId =
          '${usuarioAuth.uid}_'
          '${ahora.microsecondsSinceEpoch}';

      batch.set(
        _referenciaRegistroPeso(
          registroId,
        ),
        _datosRegistroPeso(
          id:
              registroId,
          alumnoId:
              usuarioAuth.uid,
          peso:
              peso,
          fecha:
              ahora,
          origen:
              'edicion_perfil',
        ),
      );
    }

    await batch.commit();
  }

  static Future<List<Map<String, dynamic>>>
      obtenerHistorialPeso(
    String alumnoId,
  ) async {
    await _obtenerUsuarioVerificado();

    if (alumnoId
        .trim()
        .isEmpty) {
      throw Exception(
        'El alumno no es válido.',
      );
    }

    final snapshot =
        await _firestore
            .collection(
              'registrosPesoAlumno',
            )
            .where(
              'alumnoId',
              isEqualTo:
                  alumnoId,
            )
            .get();

    final resultado =
        snapshot.docs
            .map(
              (
                documento,
              ) {
                final datos =
                    Map<String, dynamic>.from(
                  documento.data(),
                );

                datos[
                        'documentoId'] =
                    documento.id;

                return datos;
              },
            )
            .toList();

    resultado.sort(
      (
        a,
        b,
      ) {
        final fechaA =
            a['fecha'];

        final fechaB =
            b['fecha'];

        final dateA =
            fechaA is Timestamp
                ? fechaA
                    .toDate()
                : DateTime
                    .fromMillisecondsSinceEpoch(
                    0,
                  );

        final dateB =
            fechaB is Timestamp
                ? fechaB
                    .toDate()
                : DateTime
                    .fromMillisecondsSinceEpoch(
                    0,
                  );

        return dateB.compareTo(
          dateA,
        );
      },
    );

    return resultado;
  }

  static Future<void> actualizarFotoPerfil(String fotoUrl) async {
    final usuarioAuth = await _obtenerUsuarioVerificado();
    final referenciaUsuario = _firestore.collection('usuarios').doc(usuarioAuth.uid);

    await referenciaUsuario.update({
      'fotoUrl': fotoUrl.trim(),
      'actualizadoEn': FieldValue.serverTimestamp(),
    });
  }
}

