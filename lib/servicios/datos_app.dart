import '../modelos/usuario.dart';
import '../modelos/rutina.dart';
import '../modelos/entrenamiento.dart';
import '../modelos/estado_entrenamiento.dart';
import '../modelos/registro_peso.dart';

class DatosApp {
  static Usuario usuarioActual = Usuario(
    id: '',
    nombre: '',
    edad: 0,
    altura: 0,
    peso: 0,
    objetivo: '',
    correo: '',
    rol: 'alumno',
  );

  static final List<RegistroPeso> historialPeso = [];

  static final List<Rutina> rutinasAsignadas = [];

  static final List<Entrenamiento>
      entrenamientosRealizados = [];

  static final Map<String, EntrenamientoEnCurso>
      entrenamientosEnCurso = {};

  static void establecerEntrenamientoEnCurso(
    EntrenamientoEnCurso entrenamiento,
  ) {
    entrenamientosEnCurso[
            entrenamiento.rutinaId] =
        entrenamiento;
  }

  static EntrenamientoEnCurso?
      buscarEntrenamientoEnCurso(
    String rutinaId,
  ) {
    return entrenamientosEnCurso[rutinaId];
  }

  static void eliminarEntrenamientoEnCurso(
    String rutinaId,
  ) {
    entrenamientosEnCurso.remove(rutinaId);
  }

  static void limpiarDatosUsuario() {
    historialPeso.clear();
    rutinasAsignadas.clear();
    entrenamientosRealizados.clear();
    entrenamientosEnCurso.clear();
  }
}