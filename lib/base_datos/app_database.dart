import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('UsuarioDb')
class Usuarios extends Table {
  TextColumn get id => text()();

  TextColumn get nombre => text()();

  IntColumn get edad => integer().nullable()();

  RealColumn get altura => real().nullable()();

  RealColumn get pesoActual => real().nullable()();

  TextColumn get objetivo => text().nullable()();

  TextColumn get correo => text().nullable()();

  TextColumn get rol => text()();

  DateTimeColumn get creadoEn =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get actualizadoEn =>
      dateTime().withDefault(currentDateAndTime)();

  BoolColumn get eliminado =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RelacionProfesorAlumnoDb')
class RelacionesProfesorAlumno extends Table {
  TextColumn get id => text()();

  TextColumn get profesorId => text()();

  TextColumn get alumnoId => text()();

  TextColumn get estado =>
      text().withDefault(const Constant('activo'))();

  DateTimeColumn get creadoEn =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RegistroPesoDb')
class RegistrosPeso extends Table {
  TextColumn get id => text()();

  TextColumn get usuarioId => text()();

  RealColumn get peso => real()();

  DateTimeColumn get fecha => dateTime()();

  DateTimeColumn get creadoEn =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EjercicioDb')
class Ejercicios extends Table {
  TextColumn get id => text()();

  TextColumn get creadorId => text()();

  TextColumn get nombre => text()();

  TextColumn get descripcion => text().nullable()();

  BoolColumn get llevaPeso =>
      boolean().withDefault(const Constant(true))();

  TextColumn get grupoMuscular => text().nullable()();

  TextColumn get instrucciones => text().nullable()();

  TextColumn get urlMedia => text().nullable()();

  DateTimeColumn get creadoEn =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get actualizadoEn =>
      dateTime().withDefault(currentDateAndTime)();

  BoolColumn get eliminado =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RutinaDb')
class Rutinas extends Table {
  TextColumn get id => text()();

  TextColumn get creadorId => text()();

  TextColumn get nombre => text()();

  TextColumn get descripcion => text().nullable()();

  DateTimeColumn get creadoEn =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get actualizadoEn =>
      dateTime().withDefault(currentDateAndTime)();

  BoolColumn get eliminado =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RutinaEjercicioDb')
class RutinaEjercicios extends Table {
  TextColumn get id => text()();

  TextColumn get rutinaId => text()();

  TextColumn get ejercicioId => text()();

  IntColumn get orden => integer()();

  IntColumn get series => integer()();

  TextColumn get repeticiones => text()();

  IntColumn get descansoSegundos =>
      integer().withDefault(const Constant(60))();

  TextColumn get observaciones => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RutinaAsignadaDb')
class RutinasAsignadas extends Table {
  TextColumn get id => text()();

  TextColumn get rutinaId => text()();

  TextColumn get profesorId => text()();

  TextColumn get alumnoId => text()();

  IntColumn get dia => integer()();

  BoolColumn get activa =>
      boolean().withDefault(const Constant(true))();

  DateTimeColumn get fechaAsignacion => dateTime()();

  DateTimeColumn get creadoEn =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EntrenamientoDb')
class Entrenamientos extends Table {
  TextColumn get id => text()();

  TextColumn get alumnoId => text()();

  TextColumn get rutinaId => text()();

  TextColumn get rutinaAsignadaId => text().nullable()();

  DateTimeColumn get fechaInicio => dateTime()();

  DateTimeColumn get fechaFinalizacion => dateTime().nullable()();

  BoolColumn get completado =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get creadoEn =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get actualizadoEn =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RegistroEjercicioDb')
class RegistrosEjercicio extends Table {
  TextColumn get id => text()();

  TextColumn get entrenamientoId => text()();

  TextColumn get ejercicioId => text()();

  TextColumn get nombreEjercicio => text()();

  IntColumn get series => integer()();

  TextColumn get repeticiones => text()();

  BoolColumn get llevaPeso => boolean()();

  RealColumn get pesoUsado => real().nullable()();

  TextColumn get nota => text().nullable()();

  BoolColumn get completado =>
      boolean().withDefault(const Constant(false))();

  IntColumn get orden => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// ======================================================
// NUEVO: ENTRENAMIENTO QUE TODAVÍA NO FUE FINALIZADO
// ======================================================

@DataClassName('EntrenamientoEnCursoDb')
class EntrenamientosEnCurso extends Table {
  TextColumn get id => text()();

  TextColumn get alumnoId => text()();

  TextColumn get rutinaId => text()();

  DateTimeColumn get fechaInicio => dateTime()();

  DateTimeColumn get actualizadoEn =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ======================================================
// NUEVO: ESTADO DE CADA EJERCICIO EN ESA SESIÓN
// ======================================================

@DataClassName('RegistroEnCursoDb')
class RegistrosEnCurso extends Table {
  TextColumn get id => text()();

  TextColumn get entrenamientoEnCursoId => text()();

  TextColumn get ejercicioId => text()();

  IntColumn get orden => integer()();

  BoolColumn get completado =>
      boolean().withDefault(const Constant(false))();

  TextColumn get pesoTexto =>
      text().withDefault(const Constant(''))();

  TextColumn get nota =>
      text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Usuarios,
    RelacionesProfesorAlumno,
    RegistrosPeso,
    Ejercicios,
    Rutinas,
    RutinaEjercicios,
    RutinasAsignadas,
    Entrenamientos,
    RegistrosEjercicio,
    EntrenamientosEnCurso,
    RegistrosEnCurso,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_abrirConexion());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await migrator.createAll();
      },
      onUpgrade: (migrator, desde, hasta) async {
        if (desde < 2) {
          await migrator.createTable(
            entrenamientosEnCurso,
          );

          await migrator.createTable(
            registrosEnCurso,
          );
        }

        if (desde < 3) {
          await migrator.addColumn(
            ejercicios,
            ejercicios.urlMedia,
          );
        }
      },
    );
  }
}

QueryExecutor _abrirConexion() {
  return driftDatabase(
    name: 'mi_entrenamiento',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}