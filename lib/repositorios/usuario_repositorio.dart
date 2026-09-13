import 'package:drift/drift.dart';

import '../base_datos/app_database.dart' as db;

class UsuarioRepositorio {
  final db.AppDatabase database;

  UsuarioRepositorio(this.database);

  Future<void> guardarUsuario({
    required String id,
    required String nombre,
    required int edad,
    required double altura,
    required double pesoActual,
    required String objetivo,
    required String correo,
    required String rol,
  }) async {
    await database
        .into(database.usuarios)
        .insertOnConflictUpdate(
          db.UsuariosCompanion.insert(
            id: id,
            nombre: nombre,
            edad: Value(edad),
            altura: Value(altura),
            pesoActual: Value(pesoActual),
            objetivo: Value(objetivo),
            correo: Value(correo),
            rol: rol,
            actualizadoEn: Value(
              DateTime.now(),
            ),
          ),
        );
  }

  Future<db.UsuarioDb?> obtenerUsuario(
    String id,
  ) {
    return (database.select(database.usuarios)
          ..where(
            (tabla) => tabla.id.equals(id),
          ))
        .getSingleOrNull();
  }

  Future<void> guardarPeso({
    required String id,
    required String usuarioId,
    required double peso,
    required DateTime fecha,
  }) async {
    await database
        .into(database.registrosPeso)
        .insert(
          db.RegistrosPesoCompanion.insert(
            id: id,
            usuarioId: usuarioId,
            peso: peso,
            fecha: fecha,
          ),
        );
  }

  Future<List<db.RegistroPesoDb>>
      obtenerHistorialPeso(
    String usuarioId,
  ) {
    return (database.select(
              database.registrosPeso,
            )
          ..where(
            (tabla) =>
                tabla.usuarioId.equals(
              usuarioId,
            ),
          )
          ..orderBy([
            (tabla) =>
                OrderingTerm.desc(
              tabla.fecha,
            ),
          ]))
        .get();
  }
}