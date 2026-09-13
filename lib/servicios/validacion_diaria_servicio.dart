import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValidacionDiariaServicio {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static const String _claveFecha =
      'validacion_diaria_fecha';

  static const String _claveUid =
      'validacion_diaria_uid';

  static const String _claveRol =
      'validacion_diaria_rol';

  static const String _claveProfesorId =
      'validacion_diaria_profesor_id';

  static String _fechaClave(
    DateTime fecha,
  ) {
    final local =
        fecha.toLocal();

    final anio =
        local.year
            .toString()
            .padLeft(
              4,
              '0',
            );

    final mes =
        local.month
            .toString()
            .padLeft(
              2,
              '0',
            );

    final dia =
        local.day
            .toString()
            .padLeft(
              2,
              '0',
            );

    return '$anio-$mes-$dia';
  }

  static Future<void>
      limpiarValidacion() async {
    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.remove(
      _claveFecha,
    );

    await prefs.remove(
      _claveUid,
    );

    await prefs.remove(
      _claveRol,
    );

    await prefs.remove(
      _claveProfesorId,
    );
  }

  static Future<bool>
      tieneValidacionVigenteLocal() async {
    final usuario =
        FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return false;
    }

    final prefs =
        await SharedPreferences
            .getInstance();

    final uidGuardado =
        prefs.getString(
      _claveUid,
    );

    final fechaGuardada =
        prefs.getString(
      _claveFecha,
    );

    if (uidGuardado !=
            usuario.uid ||
        fechaGuardada == null ||
        fechaGuardada.isEmpty) {
      return false;
    }

    return fechaGuardada ==
        _fechaClave(
          DateTime.now(),
        );
  }

  static Future<String?>
      profesorValidadoLocal() async {
    final prefs =
        await SharedPreferences
            .getInstance();

    return prefs.getString(
      _claveProfesorId,
    );
  }

  static Future<String?>
      rolValidadoLocal() async {
    final prefs =
        await SharedPreferences
            .getInstance();

    return prefs.getString(
      _claveRol,
    );
  }

  static Future<ResultadoValidacionDiaria>
      _resultadoLocalVigente() async {
    final rol =
        (await rolValidadoLocal() ??
                '')
            .trim()
            .toLowerCase();

    final profesorId =
        await profesorValidadoLocal();

    if (rol == 'alumno') {
      final vinculado =
          profesorId != null &&
              profesorId
                  .trim()
                  .isNotEmpty;

      return ResultadoValidacionDiaria(
        valida: true,
        habilitadoParaEntrenar:
            vinculado,
        necesitaInternet:
            false,
        rol:
            rol,
        profesorId:
            profesorId,
        mensaje:
            vinculado
                ? null
                : 'No tenés un profesor vinculado actualmente.',
      );
    }

    return ResultadoValidacionDiaria(
      valida: true,
      habilitadoParaEntrenar:
          true,
      necesitaInternet:
          false,
      rol:
          rol,
      profesorId:
          profesorId,
    );
  }

  static Future<ResultadoValidacionDiaria>
      validarOnlineAhora() async {
    final usuario =
        FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      await limpiarValidacion();

      return const ResultadoValidacionDiaria(
        valida: false,
        habilitadoParaEntrenar: false,
        necesitaInternet: false,
        mensaje:
            'No hay una sesión iniciada.',
      );
    }

    try {
      //
      // Forzamos una renovación REAL del token.
      // Con timeout evitamos dejar la app girando
      // indefinidamente cuando no hay internet.
      //
      final token =
          await usuario
              .getIdTokenResult(
        true,
      )
              .timeout(
        const Duration(
          seconds: 4,
        ),
      );

      final emitidoEn =
          token.issuedAtTime;

      //
      // issuedAtTime se usa solamente para
      // confirmar que Firebase devolvió un token
      // renovado correctamente.
      //
      if (emitidoEn == null) {
        return const ResultadoValidacionDiaria(
          valida: false,
          habilitadoParaEntrenar: false,
          necesitaInternet: true,
          mensaje:
              'No se pudo comprobar la sesión en línea.',
        );
      }

      final usuarioDoc =
          await _firestore
              .collection(
                'usuarios',
              )
              .doc(
                usuario.uid,
              )
              .get(
                const GetOptions(
                  source:
                      Source.server,
                ),
              )
              .timeout(
                const Duration(
                  seconds: 4,
                ),
              );

      final datosUsuario =
          usuarioDoc.data();

      if (datosUsuario == null) {
        await limpiarValidacion();

        return const ResultadoValidacionDiaria(
          valida: false,
          habilitadoParaEntrenar: false,
          necesitaInternet: false,
          mensaje:
              'No se encontró el perfil de esta cuenta.',
        );
      }

      if (datosUsuario[
              'activo'] ==
          false) {
        await limpiarValidacion();

        return const ResultadoValidacionDiaria(
          valida: false,
          habilitadoParaEntrenar: false,
          necesitaInternet: false,
          mensaje:
              'Esta cuenta está desactivada.',
        );
      }

      final perfilCompleto =
          datosUsuario[
                  'perfilCompleto'] ==
              true;

      if (!perfilCompleto) {
        return const ResultadoValidacionDiaria(
          valida: false,
          habilitadoParaEntrenar: false,
          necesitaInternet: false,
          mensaje:
              'Primero debés completar tu perfil.',
        );
      }

      final rol =
          (datosUsuario[
                      'rol'] ??
                  'alumno')
              .toString()
              .trim()
              .toLowerCase();

      String? profesorId;

      if (rol ==
          'alumno') {
        //
        // SIEMPRE consultamos el vínculo contra
        // el servidor, nunca desde caché.
        //
        // Esta es la protección que impide que un
        // alumno desvinculado renueve el acceso a
        // rutinas usando información vieja.
        //
        final vinculoDoc =
            await _firestore
                .collection(
                  'vinculosActivos',
                )
                .doc(
                  usuario.uid,
                )
                .get(
                  const GetOptions(
                    source:
                        Source.server,
                  ),
                )
                .timeout(
                  const Duration(
                    seconds: 4,
                  ),
                );

        final datosVinculo =
            vinculoDoc.data();

        if (datosVinculo !=
            null) {
          profesorId =
              (datosVinculo[
                          'profesorId'] ??
                      '')
                  .toString()
                  .trim();

          if (profesorId
              .isEmpty) {
            profesorId =
                null;
          }
        }
      }

      final prefs =
          await SharedPreferences
              .getInstance();

      await prefs.setString(
        _claveUid,
        usuario.uid,
      );

      await prefs.setString(
        _claveRol,
        rol,
      );

      //
      // La validación online ya fue comprobada
      // contra Firebase y Firestore.
      //
      // Guardamos el DÍA LOCAL ACTUAL del teléfono
      // como el día habilitado.
      //
      // Esto evita volver a pedir validación una
      // y otra vez cuando la fecha local difiere
      // de la fecha de emisión del token.
      //
      await prefs.setString(
        _claveFecha,
        _fechaClave(
          DateTime.now(),
        ),
      );

      if (profesorId ==
          null) {
        await prefs.remove(
          _claveProfesorId,
        );
      } else {
        await prefs.setString(
          _claveProfesorId,
          profesorId,
        );
      }

      if (rol ==
              'alumno' &&
          profesorId ==
              null) {
        return ResultadoValidacionDiaria(
          valida: true,
          habilitadoParaEntrenar:
              false,
          necesitaInternet:
              false,
          rol:
              rol,
          mensaje:
              'No tenés un profesor vinculado actualmente.',
        );
      }

      return ResultadoValidacionDiaria(
        valida: true,
        habilitadoParaEntrenar:
            true,
        necesitaInternet:
            false,
        rol:
            rol,
        profesorId:
            profesorId,
      );
    } on TimeoutException {
      return const ResultadoValidacionDiaria(
        valida: false,
        habilitadoParaEntrenar: false,
        necesitaInternet: true,
        mensaje:
            'Conectate a internet para validar tu cuenta de hoy.',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code ==
              'user-disabled' ||
          e.code ==
              'user-not-found') {
        await limpiarValidacion();

        return const ResultadoValidacionDiaria(
          valida: false,
          habilitadoParaEntrenar: false,
          necesitaInternet: false,
          mensaje:
              'Esta cuenta ya no está disponible.',
        );
      }

      return const ResultadoValidacionDiaria(
        valida: false,
        habilitadoParaEntrenar: false,
        necesitaInternet: true,
        mensaje:
            'Conectate a internet para validar tu cuenta de hoy.',
      );
    } on FirebaseException {
      return const ResultadoValidacionDiaria(
        valida: false,
        habilitadoParaEntrenar: false,
        necesitaInternet: true,
        mensaje:
            'Conectate a internet para validar tu cuenta de hoy.',
      );
    } catch (_) {
      return const ResultadoValidacionDiaria(
        valida: false,
        habilitadoParaEntrenar: false,
        necesitaInternet: true,
        mensaje:
            'Conectate a internet para validar tu cuenta de hoy.',
      );
    }
  }

  static Future<ResultadoValidacionDiaria>
      comprobarParaEntrenar() async {
    final vigente =
        await tieneValidacionVigenteLocal();

    if (vigente) {
      //
      // Ya fue validado online hoy.
      // No volvemos a consultar internet.
      //
      return _resultadoLocalVigente();
    }

    //
    // Primer acceso del día o validación vencida:
    // intentamos validar AUTOMÁTICAMENTE online.
    //
    // Si hay internet y todo está correcto,
    // se habilita sin mostrar ningún cartel.
    //
    // Si no hay internet, validarOnlineAhora()
    // devuelve necesitaInternet = true y Rutinas
    // queda bloqueado hasta recuperar conexión.
    //
    return validarOnlineAhora();
  }
}

class ResultadoValidacionDiaria {
  final bool valida;
  final bool habilitadoParaEntrenar;
  final bool necesitaInternet;
  final String? mensaje;
  final String? rol;
  final String? profesorId;

  const ResultadoValidacionDiaria({
    required this.valida,
    required this.habilitadoParaEntrenar,
    required this.necesitaInternet,
    this.mensaje,
    this.rol,
    this.profesorId,
  });
}
