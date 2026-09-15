import 'dart:async';

import '../modelos/registro_peso.dart';
import '../modelos/usuario.dart';
import '../repositorios/usuario_repositorio.dart';
import '../repositorios/rutina_repositorio.dart';
import '../repositorios/entrenamiento_repositorio.dart';
import 'base_datos_servicio.dart';
import 'datos_app.dart';

class InicializacionAppServicio {
  static Future<void> cargarDatosLocales({
    required String usuarioId,
    required String correo,
    required String rol,
    String nombre = '',
    Map<String, dynamic>? datosFirestore,
  }) async {
    final usuarioRepositorio =
        UsuarioRepositorio(
      BaseDatosServicio.db,
    );

    final rutinaRepositorio =
        RutinaRepositorio(
      BaseDatosServicio.db,
    );

    final entrenamientoRepositorio =
        EntrenamientoRepositorio(
      BaseDatosServicio.db,
    );

    DatosApp.limpiarDatosUsuario();

    // =========================
    // USUARIO
    // =========================

    final usuarioGuardado =
        await usuarioRepositorio
            .obtenerUsuario(
      usuarioId,
    );

    int edadFs = 0;
    double alturaFs = 0.0;
    double pesoFs = 0.0;
    String objetivoFs = '';
    String nombreFs = nombre;
    String fotoUrlFs = '';

    if (datosFirestore != null) {
      if (datosFirestore['edad'] is num) {
        edadFs = (datosFirestore['edad'] as num).toInt();
      }
      if (datosFirestore['altura'] is num) {
        alturaFs = (datosFirestore['altura'] as num).toDouble();
      }
      if (datosFirestore['peso'] is num) {
        pesoFs = (datosFirestore['peso'] as num).toDouble();
      }
      if (datosFirestore['objetivo'] != null) {
        objetivoFs = datosFirestore['objetivo'].toString();
      }
      if (datosFirestore['fotoUrl'] != null) {
        fotoUrlFs = datosFirestore['fotoUrl'].toString().trim();
      }
      if (datosFirestore['nombre'] != null &&
          datosFirestore['nombre'].toString().trim().isNotEmpty) {
        nombreFs = datosFirestore['nombre'].toString().trim();
      }
    }

    if (usuarioGuardado != null) {
      final edadFinal = (usuarioGuardado.edad != null && usuarioGuardado.edad! > 0)
          ? usuarioGuardado.edad!
          : edadFs;
      final alturaFinal = (usuarioGuardado.altura != null && usuarioGuardado.altura! > 0)
          ? usuarioGuardado.altura!
          : alturaFs;
      final pesoFinal = (usuarioGuardado.pesoActual != null && usuarioGuardado.pesoActual! > 0)
          ? usuarioGuardado.pesoActual!
          : pesoFs;
      final objetivoFinal = (usuarioGuardado.objetivo != null && usuarioGuardado.objetivo!.isNotEmpty)
          ? usuarioGuardado.objetivo!
          : objetivoFs;
      final nombreFinal = usuarioGuardado.nombre.isNotEmpty
          ? usuarioGuardado.nombre
          : nombreFs;

      DatosApp.usuarioActual = Usuario(
        id: usuarioId,
        nombre: nombreFinal,
        edad: edadFinal,
        altura: alturaFinal,
        peso: pesoFinal,
        objetivo: objetivoFinal,
        correo: correo.isNotEmpty
            ? correo
            : usuarioGuardado.correo ?? '',
        rol: rol,
        fotoUrl: fotoUrlFs,
      );
    } else {
      DatosApp.usuarioActual = Usuario(
        id: usuarioId,
        nombre: nombreFs.isNotEmpty ? nombreFs : 'Nuevo usuario',
        edad: edadFs,
        altura: alturaFs,
        peso: pesoFs,
        objetivo: objetivoFs,
        correo: correo,
        rol: rol,
        fotoUrl: fotoUrlFs,
      );
    }

    await usuarioRepositorio.guardarUsuario(
      id: usuarioId,
      nombre: DatosApp.usuarioActual.nombre,
      edad: DatosApp.usuarioActual.edad,
      altura: DatosApp.usuarioActual.altura,
      pesoActual: DatosApp.usuarioActual.peso,
      objetivo: DatosApp.usuarioActual.objetivo,
      correo: DatosApp.usuarioActual.correo,
      rol: rol,
    );

    // =========================
    // HISTORIAL DE PESO
    // =========================

    final historialDb =
        await usuarioRepositorio
            .obtenerHistorialPeso(
      usuarioId,
    );

    DatosApp.historialPeso
        .clear();

    for (final registroDb
        in historialDb) {
      DatosApp.historialPeso.add(
        RegistroPeso(
          fecha:
              registroDb.fecha,
          peso:
              registroDb.peso,
        ),
      );
    }

    // =========================
    // RUTINAS ASIGNADAS
    // =========================

    final rutinasGuardadas =
        await rutinaRepositorio
            .obtenerRutinasAsignadas(
      usuarioId,
    );

    DatosApp.rutinasAsignadas
      ..clear()
      ..addAll(
        rutinasGuardadas,
      );

    // =========================
    // ENTRENAMIENTOS LOCALES
    // =========================

    final entrenamientosGuardados =
        await entrenamientoRepositorio
            .obtenerEntrenamientosFinalizados(
      usuarioId,
    );

    DatosApp.entrenamientosRealizados
      ..clear()
      ..addAll(
        entrenamientosGuardados,
      );

    // =========================
    // SINCRONIZACIÓN CLOUD
    // =========================
    //
    // MUY IMPORTANTE:
    // nunca hacemos await aquí.
    //
    // La app termina de iniciar usando Drift.
    // La sincronización se intenta aparte.
    // =========================

    if (rol
            .trim()
            .toLowerCase() ==
        'alumno') {
      unawaited(
        entrenamientoRepositorio
            .sincronizarEntrenamientosLocales(
          alumnoId:
              usuarioId,
        )
            .catchError(
          (_) {
            // Offline o error temporal:
            // no bloquea el inicio.
          },
        ),
      );
    }
  }
}
