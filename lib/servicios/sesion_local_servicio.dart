import '../modelos/registro_peso.dart';
import '../modelos/usuario.dart';
import '../repositorios/entrenamiento_repositorio.dart';
import '../repositorios/rutina_repositorio.dart';
import '../repositorios/usuario_repositorio.dart';
import 'base_datos_servicio.dart';
import 'datos_app.dart';

class SesionLocalServicio {
  static String? _usuarioAnteriorId;

  static bool get puedeVolver =>
      _usuarioAnteriorId != null;

  static Future<bool> entrarComoUsuario(
    String usuarioId, {
    bool guardarUsuarioActual = true,
  }) async {
    if (guardarUsuarioActual &&
        DatosApp.usuarioActual.id != usuarioId) {
      _usuarioAnteriorId =
          DatosApp.usuarioActual.id;
    }

    return _cargarUsuario(
      usuarioId,
    );
  }

  static Future<bool> volverAlUsuarioAnterior() async {
    final usuarioId =
        _usuarioAnteriorId;

    if (usuarioId == null) {
      return false;
    }

    final correcto =
        await _cargarUsuario(
      usuarioId,
    );

    if (correcto) {
      _usuarioAnteriorId = null;
    }

    return correcto;
  }

  static Future<bool> _cargarUsuario(
    String usuarioId,
  ) async {
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

    final usuarioDb =
        await usuarioRepositorio.obtenerUsuario(
      usuarioId,
    );

    if (usuarioDb == null) {
      return false;
    }

    DatosApp.usuarioActual = Usuario(
      id: usuarioDb.id,
      nombre: usuarioDb.nombre,
      edad: usuarioDb.edad ?? 0,
      altura: usuarioDb.altura ?? 0,
      peso: usuarioDb.pesoActual ?? 0,
      objetivo: usuarioDb.objetivo ?? '',
      correo: usuarioDb.correo ?? '',
      rol: usuarioDb.rol,
    );

    final historialPeso =
        await usuarioRepositorio
            .obtenerHistorialPeso(
      usuarioId,
    );

    DatosApp.historialPeso
      ..clear()
      ..addAll(
        historialPeso.map(
          (registro) {
            return RegistroPeso(
              fecha: registro.fecha,
              peso: registro.peso,
            );
          },
        ),
      );

    final rutinas =
        await rutinaRepositorio
            .obtenerRutinasAsignadas(
      usuarioId,
    );

    DatosApp.rutinasAsignadas
      ..clear()
      ..addAll(
        rutinas,
      );

    final entrenamientos =
        await entrenamientoRepositorio
            .obtenerEntrenamientosFinalizados(
      usuarioId,
    );

    DatosApp.entrenamientosRealizados
      ..clear()
      ..addAll(
        entrenamientos,
      );

    DatosApp.entrenamientosEnCurso.clear();

    return true;
  }
}