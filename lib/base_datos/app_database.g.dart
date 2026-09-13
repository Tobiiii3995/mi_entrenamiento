// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsuariosTable extends Usuarios
    with TableInfo<$UsuariosTable, UsuarioDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsuariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _edadMeta = const VerificationMeta('edad');
  @override
  late final GeneratedColumn<int> edad = GeneratedColumn<int>(
    'edad',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _alturaMeta = const VerificationMeta('altura');
  @override
  late final GeneratedColumn<double> altura = GeneratedColumn<double>(
    'altura',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pesoActualMeta = const VerificationMeta(
    'pesoActual',
  );
  @override
  late final GeneratedColumn<double> pesoActual = GeneratedColumn<double>(
    'peso_actual',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _objetivoMeta = const VerificationMeta(
    'objetivo',
  );
  @override
  late final GeneratedColumn<String> objetivo = GeneratedColumn<String>(
    'objetivo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _correoMeta = const VerificationMeta('correo');
  @override
  late final GeneratedColumn<String> correo = GeneratedColumn<String>(
    'correo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rolMeta = const VerificationMeta('rol');
  @override
  late final GeneratedColumn<String> rol = GeneratedColumn<String>(
    'rol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _eliminadoMeta = const VerificationMeta(
    'eliminado',
  );
  @override
  late final GeneratedColumn<bool> eliminado = GeneratedColumn<bool>(
    'eliminado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("eliminado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    edad,
    altura,
    pesoActual,
    objetivo,
    correo,
    rol,
    creadoEn,
    actualizadoEn,
    eliminado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usuarios';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsuarioDb> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('edad')) {
      context.handle(
        _edadMeta,
        edad.isAcceptableOrUnknown(data['edad']!, _edadMeta),
      );
    }
    if (data.containsKey('altura')) {
      context.handle(
        _alturaMeta,
        altura.isAcceptableOrUnknown(data['altura']!, _alturaMeta),
      );
    }
    if (data.containsKey('peso_actual')) {
      context.handle(
        _pesoActualMeta,
        pesoActual.isAcceptableOrUnknown(data['peso_actual']!, _pesoActualMeta),
      );
    }
    if (data.containsKey('objetivo')) {
      context.handle(
        _objetivoMeta,
        objetivo.isAcceptableOrUnknown(data['objetivo']!, _objetivoMeta),
      );
    }
    if (data.containsKey('correo')) {
      context.handle(
        _correoMeta,
        correo.isAcceptableOrUnknown(data['correo']!, _correoMeta),
      );
    }
    if (data.containsKey('rol')) {
      context.handle(
        _rolMeta,
        rol.isAcceptableOrUnknown(data['rol']!, _rolMeta),
      );
    } else if (isInserting) {
      context.missing(_rolMeta);
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    if (data.containsKey('eliminado')) {
      context.handle(
        _eliminadoMeta,
        eliminado.isAcceptableOrUnknown(data['eliminado']!, _eliminadoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsuarioDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsuarioDb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      edad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}edad'],
      ),
      altura: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altura'],
      ),
      pesoActual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peso_actual'],
      ),
      objetivo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}objetivo'],
      ),
      correo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correo'],
      ),
      rol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rol'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
      eliminado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}eliminado'],
      )!,
    );
  }

  @override
  $UsuariosTable createAlias(String alias) {
    return $UsuariosTable(attachedDatabase, alias);
  }
}

class UsuarioDb extends DataClass implements Insertable<UsuarioDb> {
  final String id;
  final String nombre;
  final int? edad;
  final double? altura;
  final double? pesoActual;
  final String? objetivo;
  final String? correo;
  final String rol;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  final bool eliminado;
  const UsuarioDb({
    required this.id,
    required this.nombre,
    this.edad,
    this.altura,
    this.pesoActual,
    this.objetivo,
    this.correo,
    required this.rol,
    required this.creadoEn,
    required this.actualizadoEn,
    required this.eliminado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || edad != null) {
      map['edad'] = Variable<int>(edad);
    }
    if (!nullToAbsent || altura != null) {
      map['altura'] = Variable<double>(altura);
    }
    if (!nullToAbsent || pesoActual != null) {
      map['peso_actual'] = Variable<double>(pesoActual);
    }
    if (!nullToAbsent || objetivo != null) {
      map['objetivo'] = Variable<String>(objetivo);
    }
    if (!nullToAbsent || correo != null) {
      map['correo'] = Variable<String>(correo);
    }
    map['rol'] = Variable<String>(rol);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    map['eliminado'] = Variable<bool>(eliminado);
    return map;
  }

  UsuariosCompanion toCompanion(bool nullToAbsent) {
    return UsuariosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      edad: edad == null && nullToAbsent ? const Value.absent() : Value(edad),
      altura: altura == null && nullToAbsent
          ? const Value.absent()
          : Value(altura),
      pesoActual: pesoActual == null && nullToAbsent
          ? const Value.absent()
          : Value(pesoActual),
      objetivo: objetivo == null && nullToAbsent
          ? const Value.absent()
          : Value(objetivo),
      correo: correo == null && nullToAbsent
          ? const Value.absent()
          : Value(correo),
      rol: Value(rol),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
      eliminado: Value(eliminado),
    );
  }

  factory UsuarioDb.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsuarioDb(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      edad: serializer.fromJson<int?>(json['edad']),
      altura: serializer.fromJson<double?>(json['altura']),
      pesoActual: serializer.fromJson<double?>(json['pesoActual']),
      objetivo: serializer.fromJson<String?>(json['objetivo']),
      correo: serializer.fromJson<String?>(json['correo']),
      rol: serializer.fromJson<String>(json['rol']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
      eliminado: serializer.fromJson<bool>(json['eliminado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'edad': serializer.toJson<int?>(edad),
      'altura': serializer.toJson<double?>(altura),
      'pesoActual': serializer.toJson<double?>(pesoActual),
      'objetivo': serializer.toJson<String?>(objetivo),
      'correo': serializer.toJson<String?>(correo),
      'rol': serializer.toJson<String>(rol),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
      'eliminado': serializer.toJson<bool>(eliminado),
    };
  }

  UsuarioDb copyWith({
    String? id,
    String? nombre,
    Value<int?> edad = const Value.absent(),
    Value<double?> altura = const Value.absent(),
    Value<double?> pesoActual = const Value.absent(),
    Value<String?> objetivo = const Value.absent(),
    Value<String?> correo = const Value.absent(),
    String? rol,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
    bool? eliminado,
  }) => UsuarioDb(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    edad: edad.present ? edad.value : this.edad,
    altura: altura.present ? altura.value : this.altura,
    pesoActual: pesoActual.present ? pesoActual.value : this.pesoActual,
    objetivo: objetivo.present ? objetivo.value : this.objetivo,
    correo: correo.present ? correo.value : this.correo,
    rol: rol ?? this.rol,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    eliminado: eliminado ?? this.eliminado,
  );
  UsuarioDb copyWithCompanion(UsuariosCompanion data) {
    return UsuarioDb(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      edad: data.edad.present ? data.edad.value : this.edad,
      altura: data.altura.present ? data.altura.value : this.altura,
      pesoActual: data.pesoActual.present
          ? data.pesoActual.value
          : this.pesoActual,
      objetivo: data.objetivo.present ? data.objetivo.value : this.objetivo,
      correo: data.correo.present ? data.correo.value : this.correo,
      rol: data.rol.present ? data.rol.value : this.rol,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
      eliminado: data.eliminado.present ? data.eliminado.value : this.eliminado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsuarioDb(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('edad: $edad, ')
          ..write('altura: $altura, ')
          ..write('pesoActual: $pesoActual, ')
          ..write('objetivo: $objetivo, ')
          ..write('correo: $correo, ')
          ..write('rol: $rol, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('eliminado: $eliminado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    edad,
    altura,
    pesoActual,
    objetivo,
    correo,
    rol,
    creadoEn,
    actualizadoEn,
    eliminado,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsuarioDb &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.edad == this.edad &&
          other.altura == this.altura &&
          other.pesoActual == this.pesoActual &&
          other.objetivo == this.objetivo &&
          other.correo == this.correo &&
          other.rol == this.rol &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn &&
          other.eliminado == this.eliminado);
}

class UsuariosCompanion extends UpdateCompanion<UsuarioDb> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<int?> edad;
  final Value<double?> altura;
  final Value<double?> pesoActual;
  final Value<String?> objetivo;
  final Value<String?> correo;
  final Value<String> rol;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  final Value<bool> eliminado;
  final Value<int> rowid;
  const UsuariosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.edad = const Value.absent(),
    this.altura = const Value.absent(),
    this.pesoActual = const Value.absent(),
    this.objetivo = const Value.absent(),
    this.correo = const Value.absent(),
    this.rol = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsuariosCompanion.insert({
    required String id,
    required String nombre,
    this.edad = const Value.absent(),
    this.altura = const Value.absent(),
    this.pesoActual = const Value.absent(),
    this.objetivo = const Value.absent(),
    this.correo = const Value.absent(),
    required String rol,
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       rol = Value(rol);
  static Insertable<UsuarioDb> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<int>? edad,
    Expression<double>? altura,
    Expression<double>? pesoActual,
    Expression<String>? objetivo,
    Expression<String>? correo,
    Expression<String>? rol,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
    Expression<bool>? eliminado,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (edad != null) 'edad': edad,
      if (altura != null) 'altura': altura,
      if (pesoActual != null) 'peso_actual': pesoActual,
      if (objetivo != null) 'objetivo': objetivo,
      if (correo != null) 'correo': correo,
      if (rol != null) 'rol': rol,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (eliminado != null) 'eliminado': eliminado,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsuariosCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<int?>? edad,
    Value<double?>? altura,
    Value<double?>? pesoActual,
    Value<String?>? objetivo,
    Value<String?>? correo,
    Value<String>? rol,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
    Value<bool>? eliminado,
    Value<int>? rowid,
  }) {
    return UsuariosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      edad: edad ?? this.edad,
      altura: altura ?? this.altura,
      pesoActual: pesoActual ?? this.pesoActual,
      objetivo: objetivo ?? this.objetivo,
      correo: correo ?? this.correo,
      rol: rol ?? this.rol,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      eliminado: eliminado ?? this.eliminado,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (edad.present) {
      map['edad'] = Variable<int>(edad.value);
    }
    if (altura.present) {
      map['altura'] = Variable<double>(altura.value);
    }
    if (pesoActual.present) {
      map['peso_actual'] = Variable<double>(pesoActual.value);
    }
    if (objetivo.present) {
      map['objetivo'] = Variable<String>(objetivo.value);
    }
    if (correo.present) {
      map['correo'] = Variable<String>(correo.value);
    }
    if (rol.present) {
      map['rol'] = Variable<String>(rol.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (eliminado.present) {
      map['eliminado'] = Variable<bool>(eliminado.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsuariosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('edad: $edad, ')
          ..write('altura: $altura, ')
          ..write('pesoActual: $pesoActual, ')
          ..write('objetivo: $objetivo, ')
          ..write('correo: $correo, ')
          ..write('rol: $rol, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('eliminado: $eliminado, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RelacionesProfesorAlumnoTable extends RelacionesProfesorAlumno
    with TableInfo<$RelacionesProfesorAlumnoTable, RelacionProfesorAlumnoDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RelacionesProfesorAlumnoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profesorIdMeta = const VerificationMeta(
    'profesorId',
  );
  @override
  late final GeneratedColumn<String> profesorId = GeneratedColumn<String>(
    'profesor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alumnoIdMeta = const VerificationMeta(
    'alumnoId',
  );
  @override
  late final GeneratedColumn<String> alumnoId = GeneratedColumn<String>(
    'alumno_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('activo'),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profesorId,
    alumnoId,
    estado,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'relaciones_profesor_alumno';
  @override
  VerificationContext validateIntegrity(
    Insertable<RelacionProfesorAlumnoDb> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profesor_id')) {
      context.handle(
        _profesorIdMeta,
        profesorId.isAcceptableOrUnknown(data['profesor_id']!, _profesorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profesorIdMeta);
    }
    if (data.containsKey('alumno_id')) {
      context.handle(
        _alumnoIdMeta,
        alumnoId.isAcceptableOrUnknown(data['alumno_id']!, _alumnoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_alumnoIdMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RelacionProfesorAlumnoDb map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RelacionProfesorAlumnoDb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profesorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profesor_id'],
      )!,
      alumnoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alumno_id'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  $RelacionesProfesorAlumnoTable createAlias(String alias) {
    return $RelacionesProfesorAlumnoTable(attachedDatabase, alias);
  }
}

class RelacionProfesorAlumnoDb extends DataClass
    implements Insertable<RelacionProfesorAlumnoDb> {
  final String id;
  final String profesorId;
  final String alumnoId;
  final String estado;
  final DateTime creadoEn;
  const RelacionProfesorAlumnoDb({
    required this.id,
    required this.profesorId,
    required this.alumnoId,
    required this.estado,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profesor_id'] = Variable<String>(profesorId);
    map['alumno_id'] = Variable<String>(alumnoId);
    map['estado'] = Variable<String>(estado);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    return map;
  }

  RelacionesProfesorAlumnoCompanion toCompanion(bool nullToAbsent) {
    return RelacionesProfesorAlumnoCompanion(
      id: Value(id),
      profesorId: Value(profesorId),
      alumnoId: Value(alumnoId),
      estado: Value(estado),
      creadoEn: Value(creadoEn),
    );
  }

  factory RelacionProfesorAlumnoDb.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RelacionProfesorAlumnoDb(
      id: serializer.fromJson<String>(json['id']),
      profesorId: serializer.fromJson<String>(json['profesorId']),
      alumnoId: serializer.fromJson<String>(json['alumnoId']),
      estado: serializer.fromJson<String>(json['estado']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profesorId': serializer.toJson<String>(profesorId),
      'alumnoId': serializer.toJson<String>(alumnoId),
      'estado': serializer.toJson<String>(estado),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
    };
  }

  RelacionProfesorAlumnoDb copyWith({
    String? id,
    String? profesorId,
    String? alumnoId,
    String? estado,
    DateTime? creadoEn,
  }) => RelacionProfesorAlumnoDb(
    id: id ?? this.id,
    profesorId: profesorId ?? this.profesorId,
    alumnoId: alumnoId ?? this.alumnoId,
    estado: estado ?? this.estado,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  RelacionProfesorAlumnoDb copyWithCompanion(
    RelacionesProfesorAlumnoCompanion data,
  ) {
    return RelacionProfesorAlumnoDb(
      id: data.id.present ? data.id.value : this.id,
      profesorId: data.profesorId.present
          ? data.profesorId.value
          : this.profesorId,
      alumnoId: data.alumnoId.present ? data.alumnoId.value : this.alumnoId,
      estado: data.estado.present ? data.estado.value : this.estado,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RelacionProfesorAlumnoDb(')
          ..write('id: $id, ')
          ..write('profesorId: $profesorId, ')
          ..write('alumnoId: $alumnoId, ')
          ..write('estado: $estado, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profesorId, alumnoId, estado, creadoEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RelacionProfesorAlumnoDb &&
          other.id == this.id &&
          other.profesorId == this.profesorId &&
          other.alumnoId == this.alumnoId &&
          other.estado == this.estado &&
          other.creadoEn == this.creadoEn);
}

class RelacionesProfesorAlumnoCompanion
    extends UpdateCompanion<RelacionProfesorAlumnoDb> {
  final Value<String> id;
  final Value<String> profesorId;
  final Value<String> alumnoId;
  final Value<String> estado;
  final Value<DateTime> creadoEn;
  final Value<int> rowid;
  const RelacionesProfesorAlumnoCompanion({
    this.id = const Value.absent(),
    this.profesorId = const Value.absent(),
    this.alumnoId = const Value.absent(),
    this.estado = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RelacionesProfesorAlumnoCompanion.insert({
    required String id,
    required String profesorId,
    required String alumnoId,
    this.estado = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profesorId = Value(profesorId),
       alumnoId = Value(alumnoId);
  static Insertable<RelacionProfesorAlumnoDb> custom({
    Expression<String>? id,
    Expression<String>? profesorId,
    Expression<String>? alumnoId,
    Expression<String>? estado,
    Expression<DateTime>? creadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profesorId != null) 'profesor_id': profesorId,
      if (alumnoId != null) 'alumno_id': alumnoId,
      if (estado != null) 'estado': estado,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RelacionesProfesorAlumnoCompanion copyWith({
    Value<String>? id,
    Value<String>? profesorId,
    Value<String>? alumnoId,
    Value<String>? estado,
    Value<DateTime>? creadoEn,
    Value<int>? rowid,
  }) {
    return RelacionesProfesorAlumnoCompanion(
      id: id ?? this.id,
      profesorId: profesorId ?? this.profesorId,
      alumnoId: alumnoId ?? this.alumnoId,
      estado: estado ?? this.estado,
      creadoEn: creadoEn ?? this.creadoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profesorId.present) {
      map['profesor_id'] = Variable<String>(profesorId.value);
    }
    if (alumnoId.present) {
      map['alumno_id'] = Variable<String>(alumnoId.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RelacionesProfesorAlumnoCompanion(')
          ..write('id: $id, ')
          ..write('profesorId: $profesorId, ')
          ..write('alumnoId: $alumnoId, ')
          ..write('estado: $estado, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RegistrosPesoTable extends RegistrosPeso
    with TableInfo<$RegistrosPesoTable, RegistroPesoDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegistrosPesoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pesoMeta = const VerificationMeta('peso');
  @override
  late final GeneratedColumn<double> peso = GeneratedColumn<double>(
    'peso',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, usuarioId, peso, fecha, creadoEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'registros_peso';
  @override
  VerificationContext validateIntegrity(
    Insertable<RegistroPesoDb> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('peso')) {
      context.handle(
        _pesoMeta,
        peso.isAcceptableOrUnknown(data['peso']!, _pesoMeta),
      );
    } else if (isInserting) {
      context.missing(_pesoMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RegistroPesoDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegistroPesoDb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      peso: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peso'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  $RegistrosPesoTable createAlias(String alias) {
    return $RegistrosPesoTable(attachedDatabase, alias);
  }
}

class RegistroPesoDb extends DataClass implements Insertable<RegistroPesoDb> {
  final String id;
  final String usuarioId;
  final double peso;
  final DateTime fecha;
  final DateTime creadoEn;
  const RegistroPesoDb({
    required this.id,
    required this.usuarioId,
    required this.peso,
    required this.fecha,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['peso'] = Variable<double>(peso);
    map['fecha'] = Variable<DateTime>(fecha);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    return map;
  }

  RegistrosPesoCompanion toCompanion(bool nullToAbsent) {
    return RegistrosPesoCompanion(
      id: Value(id),
      usuarioId: Value(usuarioId),
      peso: Value(peso),
      fecha: Value(fecha),
      creadoEn: Value(creadoEn),
    );
  }

  factory RegistroPesoDb.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegistroPesoDb(
      id: serializer.fromJson<String>(json['id']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      peso: serializer.fromJson<double>(json['peso']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'peso': serializer.toJson<double>(peso),
      'fecha': serializer.toJson<DateTime>(fecha),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
    };
  }

  RegistroPesoDb copyWith({
    String? id,
    String? usuarioId,
    double? peso,
    DateTime? fecha,
    DateTime? creadoEn,
  }) => RegistroPesoDb(
    id: id ?? this.id,
    usuarioId: usuarioId ?? this.usuarioId,
    peso: peso ?? this.peso,
    fecha: fecha ?? this.fecha,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  RegistroPesoDb copyWithCompanion(RegistrosPesoCompanion data) {
    return RegistroPesoDb(
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      peso: data.peso.present ? data.peso.value : this.peso,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegistroPesoDb(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('peso: $peso, ')
          ..write('fecha: $fecha, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, usuarioId, peso, fecha, creadoEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegistroPesoDb &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.peso == this.peso &&
          other.fecha == this.fecha &&
          other.creadoEn == this.creadoEn);
}

class RegistrosPesoCompanion extends UpdateCompanion<RegistroPesoDb> {
  final Value<String> id;
  final Value<String> usuarioId;
  final Value<double> peso;
  final Value<DateTime> fecha;
  final Value<DateTime> creadoEn;
  final Value<int> rowid;
  const RegistrosPesoCompanion({
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.peso = const Value.absent(),
    this.fecha = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RegistrosPesoCompanion.insert({
    required String id,
    required String usuarioId,
    required double peso,
    required DateTime fecha,
    this.creadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       usuarioId = Value(usuarioId),
       peso = Value(peso),
       fecha = Value(fecha);
  static Insertable<RegistroPesoDb> custom({
    Expression<String>? id,
    Expression<String>? usuarioId,
    Expression<double>? peso,
    Expression<DateTime>? fecha,
    Expression<DateTime>? creadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (peso != null) 'peso': peso,
      if (fecha != null) 'fecha': fecha,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RegistrosPesoCompanion copyWith({
    Value<String>? id,
    Value<String>? usuarioId,
    Value<double>? peso,
    Value<DateTime>? fecha,
    Value<DateTime>? creadoEn,
    Value<int>? rowid,
  }) {
    return RegistrosPesoCompanion(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      peso: peso ?? this.peso,
      fecha: fecha ?? this.fecha,
      creadoEn: creadoEn ?? this.creadoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (peso.present) {
      map['peso'] = Variable<double>(peso.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegistrosPesoCompanion(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('peso: $peso, ')
          ..write('fecha: $fecha, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EjerciciosTable extends Ejercicios
    with TableInfo<$EjerciciosTable, EjercicioDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EjerciciosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadorIdMeta = const VerificationMeta(
    'creadorId',
  );
  @override
  late final GeneratedColumn<String> creadorId = GeneratedColumn<String>(
    'creador_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _llevaPesoMeta = const VerificationMeta(
    'llevaPeso',
  );
  @override
  late final GeneratedColumn<bool> llevaPeso = GeneratedColumn<bool>(
    'lleva_peso',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("lleva_peso" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _grupoMuscularMeta = const VerificationMeta(
    'grupoMuscular',
  );
  @override
  late final GeneratedColumn<String> grupoMuscular = GeneratedColumn<String>(
    'grupo_muscular',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _instruccionesMeta = const VerificationMeta(
    'instrucciones',
  );
  @override
  late final GeneratedColumn<String> instrucciones = GeneratedColumn<String>(
    'instrucciones',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _eliminadoMeta = const VerificationMeta(
    'eliminado',
  );
  @override
  late final GeneratedColumn<bool> eliminado = GeneratedColumn<bool>(
    'eliminado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("eliminado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    creadorId,
    nombre,
    descripcion,
    llevaPeso,
    grupoMuscular,
    instrucciones,
    creadoEn,
    actualizadoEn,
    eliminado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ejercicios';
  @override
  VerificationContext validateIntegrity(
    Insertable<EjercicioDb> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('creador_id')) {
      context.handle(
        _creadorIdMeta,
        creadorId.isAcceptableOrUnknown(data['creador_id']!, _creadorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_creadorIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('lleva_peso')) {
      context.handle(
        _llevaPesoMeta,
        llevaPeso.isAcceptableOrUnknown(data['lleva_peso']!, _llevaPesoMeta),
      );
    }
    if (data.containsKey('grupo_muscular')) {
      context.handle(
        _grupoMuscularMeta,
        grupoMuscular.isAcceptableOrUnknown(
          data['grupo_muscular']!,
          _grupoMuscularMeta,
        ),
      );
    }
    if (data.containsKey('instrucciones')) {
      context.handle(
        _instruccionesMeta,
        instrucciones.isAcceptableOrUnknown(
          data['instrucciones']!,
          _instruccionesMeta,
        ),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    if (data.containsKey('eliminado')) {
      context.handle(
        _eliminadoMeta,
        eliminado.isAcceptableOrUnknown(data['eliminado']!, _eliminadoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EjercicioDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EjercicioDb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      creadorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creador_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      llevaPeso: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}lleva_peso'],
      )!,
      grupoMuscular: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grupo_muscular'],
      ),
      instrucciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instrucciones'],
      ),
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
      eliminado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}eliminado'],
      )!,
    );
  }

  @override
  $EjerciciosTable createAlias(String alias) {
    return $EjerciciosTable(attachedDatabase, alias);
  }
}

class EjercicioDb extends DataClass implements Insertable<EjercicioDb> {
  final String id;
  final String creadorId;
  final String nombre;
  final String? descripcion;
  final bool llevaPeso;
  final String? grupoMuscular;
  final String? instrucciones;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  final bool eliminado;
  const EjercicioDb({
    required this.id,
    required this.creadorId,
    required this.nombre,
    this.descripcion,
    required this.llevaPeso,
    this.grupoMuscular,
    this.instrucciones,
    required this.creadoEn,
    required this.actualizadoEn,
    required this.eliminado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['creador_id'] = Variable<String>(creadorId);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['lleva_peso'] = Variable<bool>(llevaPeso);
    if (!nullToAbsent || grupoMuscular != null) {
      map['grupo_muscular'] = Variable<String>(grupoMuscular);
    }
    if (!nullToAbsent || instrucciones != null) {
      map['instrucciones'] = Variable<String>(instrucciones);
    }
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    map['eliminado'] = Variable<bool>(eliminado);
    return map;
  }

  EjerciciosCompanion toCompanion(bool nullToAbsent) {
    return EjerciciosCompanion(
      id: Value(id),
      creadorId: Value(creadorId),
      nombre: Value(nombre),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      llevaPeso: Value(llevaPeso),
      grupoMuscular: grupoMuscular == null && nullToAbsent
          ? const Value.absent()
          : Value(grupoMuscular),
      instrucciones: instrucciones == null && nullToAbsent
          ? const Value.absent()
          : Value(instrucciones),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
      eliminado: Value(eliminado),
    );
  }

  factory EjercicioDb.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EjercicioDb(
      id: serializer.fromJson<String>(json['id']),
      creadorId: serializer.fromJson<String>(json['creadorId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      llevaPeso: serializer.fromJson<bool>(json['llevaPeso']),
      grupoMuscular: serializer.fromJson<String?>(json['grupoMuscular']),
      instrucciones: serializer.fromJson<String?>(json['instrucciones']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
      eliminado: serializer.fromJson<bool>(json['eliminado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'creadorId': serializer.toJson<String>(creadorId),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'llevaPeso': serializer.toJson<bool>(llevaPeso),
      'grupoMuscular': serializer.toJson<String?>(grupoMuscular),
      'instrucciones': serializer.toJson<String?>(instrucciones),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
      'eliminado': serializer.toJson<bool>(eliminado),
    };
  }

  EjercicioDb copyWith({
    String? id,
    String? creadorId,
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    bool? llevaPeso,
    Value<String?> grupoMuscular = const Value.absent(),
    Value<String?> instrucciones = const Value.absent(),
    DateTime? creadoEn,
    DateTime? actualizadoEn,
    bool? eliminado,
  }) => EjercicioDb(
    id: id ?? this.id,
    creadorId: creadorId ?? this.creadorId,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    llevaPeso: llevaPeso ?? this.llevaPeso,
    grupoMuscular: grupoMuscular.present
        ? grupoMuscular.value
        : this.grupoMuscular,
    instrucciones: instrucciones.present
        ? instrucciones.value
        : this.instrucciones,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    eliminado: eliminado ?? this.eliminado,
  );
  EjercicioDb copyWithCompanion(EjerciciosCompanion data) {
    return EjercicioDb(
      id: data.id.present ? data.id.value : this.id,
      creadorId: data.creadorId.present ? data.creadorId.value : this.creadorId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      llevaPeso: data.llevaPeso.present ? data.llevaPeso.value : this.llevaPeso,
      grupoMuscular: data.grupoMuscular.present
          ? data.grupoMuscular.value
          : this.grupoMuscular,
      instrucciones: data.instrucciones.present
          ? data.instrucciones.value
          : this.instrucciones,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
      eliminado: data.eliminado.present ? data.eliminado.value : this.eliminado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EjercicioDb(')
          ..write('id: $id, ')
          ..write('creadorId: $creadorId, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('llevaPeso: $llevaPeso, ')
          ..write('grupoMuscular: $grupoMuscular, ')
          ..write('instrucciones: $instrucciones, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('eliminado: $eliminado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    creadorId,
    nombre,
    descripcion,
    llevaPeso,
    grupoMuscular,
    instrucciones,
    creadoEn,
    actualizadoEn,
    eliminado,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EjercicioDb &&
          other.id == this.id &&
          other.creadorId == this.creadorId &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.llevaPeso == this.llevaPeso &&
          other.grupoMuscular == this.grupoMuscular &&
          other.instrucciones == this.instrucciones &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn &&
          other.eliminado == this.eliminado);
}

class EjerciciosCompanion extends UpdateCompanion<EjercicioDb> {
  final Value<String> id;
  final Value<String> creadorId;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<bool> llevaPeso;
  final Value<String?> grupoMuscular;
  final Value<String?> instrucciones;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  final Value<bool> eliminado;
  final Value<int> rowid;
  const EjerciciosCompanion({
    this.id = const Value.absent(),
    this.creadorId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.llevaPeso = const Value.absent(),
    this.grupoMuscular = const Value.absent(),
    this.instrucciones = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EjerciciosCompanion.insert({
    required String id,
    required String creadorId,
    required String nombre,
    this.descripcion = const Value.absent(),
    this.llevaPeso = const Value.absent(),
    this.grupoMuscular = const Value.absent(),
    this.instrucciones = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       creadorId = Value(creadorId),
       nombre = Value(nombre);
  static Insertable<EjercicioDb> custom({
    Expression<String>? id,
    Expression<String>? creadorId,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<bool>? llevaPeso,
    Expression<String>? grupoMuscular,
    Expression<String>? instrucciones,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
    Expression<bool>? eliminado,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (creadorId != null) 'creador_id': creadorId,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (llevaPeso != null) 'lleva_peso': llevaPeso,
      if (grupoMuscular != null) 'grupo_muscular': grupoMuscular,
      if (instrucciones != null) 'instrucciones': instrucciones,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (eliminado != null) 'eliminado': eliminado,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EjerciciosCompanion copyWith({
    Value<String>? id,
    Value<String>? creadorId,
    Value<String>? nombre,
    Value<String?>? descripcion,
    Value<bool>? llevaPeso,
    Value<String?>? grupoMuscular,
    Value<String?>? instrucciones,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
    Value<bool>? eliminado,
    Value<int>? rowid,
  }) {
    return EjerciciosCompanion(
      id: id ?? this.id,
      creadorId: creadorId ?? this.creadorId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      llevaPeso: llevaPeso ?? this.llevaPeso,
      grupoMuscular: grupoMuscular ?? this.grupoMuscular,
      instrucciones: instrucciones ?? this.instrucciones,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      eliminado: eliminado ?? this.eliminado,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (creadorId.present) {
      map['creador_id'] = Variable<String>(creadorId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (llevaPeso.present) {
      map['lleva_peso'] = Variable<bool>(llevaPeso.value);
    }
    if (grupoMuscular.present) {
      map['grupo_muscular'] = Variable<String>(grupoMuscular.value);
    }
    if (instrucciones.present) {
      map['instrucciones'] = Variable<String>(instrucciones.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (eliminado.present) {
      map['eliminado'] = Variable<bool>(eliminado.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EjerciciosCompanion(')
          ..write('id: $id, ')
          ..write('creadorId: $creadorId, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('llevaPeso: $llevaPeso, ')
          ..write('grupoMuscular: $grupoMuscular, ')
          ..write('instrucciones: $instrucciones, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('eliminado: $eliminado, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RutinasTable extends Rutinas with TableInfo<$RutinasTable, RutinaDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RutinasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadorIdMeta = const VerificationMeta(
    'creadorId',
  );
  @override
  late final GeneratedColumn<String> creadorId = GeneratedColumn<String>(
    'creador_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _eliminadoMeta = const VerificationMeta(
    'eliminado',
  );
  @override
  late final GeneratedColumn<bool> eliminado = GeneratedColumn<bool>(
    'eliminado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("eliminado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    creadorId,
    nombre,
    descripcion,
    creadoEn,
    actualizadoEn,
    eliminado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rutinas';
  @override
  VerificationContext validateIntegrity(
    Insertable<RutinaDb> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('creador_id')) {
      context.handle(
        _creadorIdMeta,
        creadorId.isAcceptableOrUnknown(data['creador_id']!, _creadorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_creadorIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    if (data.containsKey('eliminado')) {
      context.handle(
        _eliminadoMeta,
        eliminado.isAcceptableOrUnknown(data['eliminado']!, _eliminadoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RutinaDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RutinaDb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      creadorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creador_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
      eliminado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}eliminado'],
      )!,
    );
  }

  @override
  $RutinasTable createAlias(String alias) {
    return $RutinasTable(attachedDatabase, alias);
  }
}

class RutinaDb extends DataClass implements Insertable<RutinaDb> {
  final String id;
  final String creadorId;
  final String nombre;
  final String? descripcion;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  final bool eliminado;
  const RutinaDb({
    required this.id,
    required this.creadorId,
    required this.nombre,
    this.descripcion,
    required this.creadoEn,
    required this.actualizadoEn,
    required this.eliminado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['creador_id'] = Variable<String>(creadorId);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    map['eliminado'] = Variable<bool>(eliminado);
    return map;
  }

  RutinasCompanion toCompanion(bool nullToAbsent) {
    return RutinasCompanion(
      id: Value(id),
      creadorId: Value(creadorId),
      nombre: Value(nombre),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
      eliminado: Value(eliminado),
    );
  }

  factory RutinaDb.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RutinaDb(
      id: serializer.fromJson<String>(json['id']),
      creadorId: serializer.fromJson<String>(json['creadorId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
      eliminado: serializer.fromJson<bool>(json['eliminado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'creadorId': serializer.toJson<String>(creadorId),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
      'eliminado': serializer.toJson<bool>(eliminado),
    };
  }

  RutinaDb copyWith({
    String? id,
    String? creadorId,
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    DateTime? creadoEn,
    DateTime? actualizadoEn,
    bool? eliminado,
  }) => RutinaDb(
    id: id ?? this.id,
    creadorId: creadorId ?? this.creadorId,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    eliminado: eliminado ?? this.eliminado,
  );
  RutinaDb copyWithCompanion(RutinasCompanion data) {
    return RutinaDb(
      id: data.id.present ? data.id.value : this.id,
      creadorId: data.creadorId.present ? data.creadorId.value : this.creadorId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
      eliminado: data.eliminado.present ? data.eliminado.value : this.eliminado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RutinaDb(')
          ..write('id: $id, ')
          ..write('creadorId: $creadorId, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('eliminado: $eliminado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    creadorId,
    nombre,
    descripcion,
    creadoEn,
    actualizadoEn,
    eliminado,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RutinaDb &&
          other.id == this.id &&
          other.creadorId == this.creadorId &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn &&
          other.eliminado == this.eliminado);
}

class RutinasCompanion extends UpdateCompanion<RutinaDb> {
  final Value<String> id;
  final Value<String> creadorId;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  final Value<bool> eliminado;
  final Value<int> rowid;
  const RutinasCompanion({
    this.id = const Value.absent(),
    this.creadorId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RutinasCompanion.insert({
    required String id,
    required String creadorId,
    required String nombre,
    this.descripcion = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.eliminado = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       creadorId = Value(creadorId),
       nombre = Value(nombre);
  static Insertable<RutinaDb> custom({
    Expression<String>? id,
    Expression<String>? creadorId,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
    Expression<bool>? eliminado,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (creadorId != null) 'creador_id': creadorId,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (eliminado != null) 'eliminado': eliminado,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RutinasCompanion copyWith({
    Value<String>? id,
    Value<String>? creadorId,
    Value<String>? nombre,
    Value<String?>? descripcion,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
    Value<bool>? eliminado,
    Value<int>? rowid,
  }) {
    return RutinasCompanion(
      id: id ?? this.id,
      creadorId: creadorId ?? this.creadorId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      eliminado: eliminado ?? this.eliminado,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (creadorId.present) {
      map['creador_id'] = Variable<String>(creadorId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (eliminado.present) {
      map['eliminado'] = Variable<bool>(eliminado.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RutinasCompanion(')
          ..write('id: $id, ')
          ..write('creadorId: $creadorId, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('eliminado: $eliminado, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RutinaEjerciciosTable extends RutinaEjercicios
    with TableInfo<$RutinaEjerciciosTable, RutinaEjercicioDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RutinaEjerciciosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rutinaIdMeta = const VerificationMeta(
    'rutinaId',
  );
  @override
  late final GeneratedColumn<String> rutinaId = GeneratedColumn<String>(
    'rutina_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ejercicioIdMeta = const VerificationMeta(
    'ejercicioId',
  );
  @override
  late final GeneratedColumn<String> ejercicioId = GeneratedColumn<String>(
    'ejercicio_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ordenMeta = const VerificationMeta('orden');
  @override
  late final GeneratedColumn<int> orden = GeneratedColumn<int>(
    'orden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seriesMeta = const VerificationMeta('series');
  @override
  late final GeneratedColumn<int> series = GeneratedColumn<int>(
    'series',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeticionesMeta = const VerificationMeta(
    'repeticiones',
  );
  @override
  late final GeneratedColumn<String> repeticiones = GeneratedColumn<String>(
    'repeticiones',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descansoSegundosMeta = const VerificationMeta(
    'descansoSegundos',
  );
  @override
  late final GeneratedColumn<int> descansoSegundos = GeneratedColumn<int>(
    'descanso_segundos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _observacionesMeta = const VerificationMeta(
    'observaciones',
  );
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
    'observaciones',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    rutinaId,
    ejercicioId,
    orden,
    series,
    repeticiones,
    descansoSegundos,
    observaciones,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rutina_ejercicios';
  @override
  VerificationContext validateIntegrity(
    Insertable<RutinaEjercicioDb> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('rutina_id')) {
      context.handle(
        _rutinaIdMeta,
        rutinaId.isAcceptableOrUnknown(data['rutina_id']!, _rutinaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rutinaIdMeta);
    }
    if (data.containsKey('ejercicio_id')) {
      context.handle(
        _ejercicioIdMeta,
        ejercicioId.isAcceptableOrUnknown(
          data['ejercicio_id']!,
          _ejercicioIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ejercicioIdMeta);
    }
    if (data.containsKey('orden')) {
      context.handle(
        _ordenMeta,
        orden.isAcceptableOrUnknown(data['orden']!, _ordenMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenMeta);
    }
    if (data.containsKey('series')) {
      context.handle(
        _seriesMeta,
        series.isAcceptableOrUnknown(data['series']!, _seriesMeta),
      );
    } else if (isInserting) {
      context.missing(_seriesMeta);
    }
    if (data.containsKey('repeticiones')) {
      context.handle(
        _repeticionesMeta,
        repeticiones.isAcceptableOrUnknown(
          data['repeticiones']!,
          _repeticionesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repeticionesMeta);
    }
    if (data.containsKey('descanso_segundos')) {
      context.handle(
        _descansoSegundosMeta,
        descansoSegundos.isAcceptableOrUnknown(
          data['descanso_segundos']!,
          _descansoSegundosMeta,
        ),
      );
    }
    if (data.containsKey('observaciones')) {
      context.handle(
        _observacionesMeta,
        observaciones.isAcceptableOrUnknown(
          data['observaciones']!,
          _observacionesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RutinaEjercicioDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RutinaEjercicioDb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rutinaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rutina_id'],
      )!,
      ejercicioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ejercicio_id'],
      )!,
      orden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden'],
      )!,
      series: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}series'],
      )!,
      repeticiones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeticiones'],
      )!,
      descansoSegundos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}descanso_segundos'],
      )!,
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
      ),
    );
  }

  @override
  $RutinaEjerciciosTable createAlias(String alias) {
    return $RutinaEjerciciosTable(attachedDatabase, alias);
  }
}

class RutinaEjercicioDb extends DataClass
    implements Insertable<RutinaEjercicioDb> {
  final String id;
  final String rutinaId;
  final String ejercicioId;
  final int orden;
  final int series;
  final String repeticiones;
  final int descansoSegundos;
  final String? observaciones;
  const RutinaEjercicioDb({
    required this.id,
    required this.rutinaId,
    required this.ejercicioId,
    required this.orden,
    required this.series,
    required this.repeticiones,
    required this.descansoSegundos,
    this.observaciones,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['rutina_id'] = Variable<String>(rutinaId);
    map['ejercicio_id'] = Variable<String>(ejercicioId);
    map['orden'] = Variable<int>(orden);
    map['series'] = Variable<int>(series);
    map['repeticiones'] = Variable<String>(repeticiones);
    map['descanso_segundos'] = Variable<int>(descansoSegundos);
    if (!nullToAbsent || observaciones != null) {
      map['observaciones'] = Variable<String>(observaciones);
    }
    return map;
  }

  RutinaEjerciciosCompanion toCompanion(bool nullToAbsent) {
    return RutinaEjerciciosCompanion(
      id: Value(id),
      rutinaId: Value(rutinaId),
      ejercicioId: Value(ejercicioId),
      orden: Value(orden),
      series: Value(series),
      repeticiones: Value(repeticiones),
      descansoSegundos: Value(descansoSegundos),
      observaciones: observaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(observaciones),
    );
  }

  factory RutinaEjercicioDb.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RutinaEjercicioDb(
      id: serializer.fromJson<String>(json['id']),
      rutinaId: serializer.fromJson<String>(json['rutinaId']),
      ejercicioId: serializer.fromJson<String>(json['ejercicioId']),
      orden: serializer.fromJson<int>(json['orden']),
      series: serializer.fromJson<int>(json['series']),
      repeticiones: serializer.fromJson<String>(json['repeticiones']),
      descansoSegundos: serializer.fromJson<int>(json['descansoSegundos']),
      observaciones: serializer.fromJson<String?>(json['observaciones']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rutinaId': serializer.toJson<String>(rutinaId),
      'ejercicioId': serializer.toJson<String>(ejercicioId),
      'orden': serializer.toJson<int>(orden),
      'series': serializer.toJson<int>(series),
      'repeticiones': serializer.toJson<String>(repeticiones),
      'descansoSegundos': serializer.toJson<int>(descansoSegundos),
      'observaciones': serializer.toJson<String?>(observaciones),
    };
  }

  RutinaEjercicioDb copyWith({
    String? id,
    String? rutinaId,
    String? ejercicioId,
    int? orden,
    int? series,
    String? repeticiones,
    int? descansoSegundos,
    Value<String?> observaciones = const Value.absent(),
  }) => RutinaEjercicioDb(
    id: id ?? this.id,
    rutinaId: rutinaId ?? this.rutinaId,
    ejercicioId: ejercicioId ?? this.ejercicioId,
    orden: orden ?? this.orden,
    series: series ?? this.series,
    repeticiones: repeticiones ?? this.repeticiones,
    descansoSegundos: descansoSegundos ?? this.descansoSegundos,
    observaciones: observaciones.present
        ? observaciones.value
        : this.observaciones,
  );
  RutinaEjercicioDb copyWithCompanion(RutinaEjerciciosCompanion data) {
    return RutinaEjercicioDb(
      id: data.id.present ? data.id.value : this.id,
      rutinaId: data.rutinaId.present ? data.rutinaId.value : this.rutinaId,
      ejercicioId: data.ejercicioId.present
          ? data.ejercicioId.value
          : this.ejercicioId,
      orden: data.orden.present ? data.orden.value : this.orden,
      series: data.series.present ? data.series.value : this.series,
      repeticiones: data.repeticiones.present
          ? data.repeticiones.value
          : this.repeticiones,
      descansoSegundos: data.descansoSegundos.present
          ? data.descansoSegundos.value
          : this.descansoSegundos,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RutinaEjercicioDb(')
          ..write('id: $id, ')
          ..write('rutinaId: $rutinaId, ')
          ..write('ejercicioId: $ejercicioId, ')
          ..write('orden: $orden, ')
          ..write('series: $series, ')
          ..write('repeticiones: $repeticiones, ')
          ..write('descansoSegundos: $descansoSegundos, ')
          ..write('observaciones: $observaciones')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    rutinaId,
    ejercicioId,
    orden,
    series,
    repeticiones,
    descansoSegundos,
    observaciones,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RutinaEjercicioDb &&
          other.id == this.id &&
          other.rutinaId == this.rutinaId &&
          other.ejercicioId == this.ejercicioId &&
          other.orden == this.orden &&
          other.series == this.series &&
          other.repeticiones == this.repeticiones &&
          other.descansoSegundos == this.descansoSegundos &&
          other.observaciones == this.observaciones);
}

class RutinaEjerciciosCompanion extends UpdateCompanion<RutinaEjercicioDb> {
  final Value<String> id;
  final Value<String> rutinaId;
  final Value<String> ejercicioId;
  final Value<int> orden;
  final Value<int> series;
  final Value<String> repeticiones;
  final Value<int> descansoSegundos;
  final Value<String?> observaciones;
  final Value<int> rowid;
  const RutinaEjerciciosCompanion({
    this.id = const Value.absent(),
    this.rutinaId = const Value.absent(),
    this.ejercicioId = const Value.absent(),
    this.orden = const Value.absent(),
    this.series = const Value.absent(),
    this.repeticiones = const Value.absent(),
    this.descansoSegundos = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RutinaEjerciciosCompanion.insert({
    required String id,
    required String rutinaId,
    required String ejercicioId,
    required int orden,
    required int series,
    required String repeticiones,
    this.descansoSegundos = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rutinaId = Value(rutinaId),
       ejercicioId = Value(ejercicioId),
       orden = Value(orden),
       series = Value(series),
       repeticiones = Value(repeticiones);
  static Insertable<RutinaEjercicioDb> custom({
    Expression<String>? id,
    Expression<String>? rutinaId,
    Expression<String>? ejercicioId,
    Expression<int>? orden,
    Expression<int>? series,
    Expression<String>? repeticiones,
    Expression<int>? descansoSegundos,
    Expression<String>? observaciones,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rutinaId != null) 'rutina_id': rutinaId,
      if (ejercicioId != null) 'ejercicio_id': ejercicioId,
      if (orden != null) 'orden': orden,
      if (series != null) 'series': series,
      if (repeticiones != null) 'repeticiones': repeticiones,
      if (descansoSegundos != null) 'descanso_segundos': descansoSegundos,
      if (observaciones != null) 'observaciones': observaciones,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RutinaEjerciciosCompanion copyWith({
    Value<String>? id,
    Value<String>? rutinaId,
    Value<String>? ejercicioId,
    Value<int>? orden,
    Value<int>? series,
    Value<String>? repeticiones,
    Value<int>? descansoSegundos,
    Value<String?>? observaciones,
    Value<int>? rowid,
  }) {
    return RutinaEjerciciosCompanion(
      id: id ?? this.id,
      rutinaId: rutinaId ?? this.rutinaId,
      ejercicioId: ejercicioId ?? this.ejercicioId,
      orden: orden ?? this.orden,
      series: series ?? this.series,
      repeticiones: repeticiones ?? this.repeticiones,
      descansoSegundos: descansoSegundos ?? this.descansoSegundos,
      observaciones: observaciones ?? this.observaciones,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (rutinaId.present) {
      map['rutina_id'] = Variable<String>(rutinaId.value);
    }
    if (ejercicioId.present) {
      map['ejercicio_id'] = Variable<String>(ejercicioId.value);
    }
    if (orden.present) {
      map['orden'] = Variable<int>(orden.value);
    }
    if (series.present) {
      map['series'] = Variable<int>(series.value);
    }
    if (repeticiones.present) {
      map['repeticiones'] = Variable<String>(repeticiones.value);
    }
    if (descansoSegundos.present) {
      map['descanso_segundos'] = Variable<int>(descansoSegundos.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RutinaEjerciciosCompanion(')
          ..write('id: $id, ')
          ..write('rutinaId: $rutinaId, ')
          ..write('ejercicioId: $ejercicioId, ')
          ..write('orden: $orden, ')
          ..write('series: $series, ')
          ..write('repeticiones: $repeticiones, ')
          ..write('descansoSegundos: $descansoSegundos, ')
          ..write('observaciones: $observaciones, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RutinasAsignadasTable extends RutinasAsignadas
    with TableInfo<$RutinasAsignadasTable, RutinaAsignadaDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RutinasAsignadasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rutinaIdMeta = const VerificationMeta(
    'rutinaId',
  );
  @override
  late final GeneratedColumn<String> rutinaId = GeneratedColumn<String>(
    'rutina_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profesorIdMeta = const VerificationMeta(
    'profesorId',
  );
  @override
  late final GeneratedColumn<String> profesorId = GeneratedColumn<String>(
    'profesor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alumnoIdMeta = const VerificationMeta(
    'alumnoId',
  );
  @override
  late final GeneratedColumn<String> alumnoId = GeneratedColumn<String>(
    'alumno_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diaMeta = const VerificationMeta('dia');
  @override
  late final GeneratedColumn<int> dia = GeneratedColumn<int>(
    'dia',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activaMeta = const VerificationMeta('activa');
  @override
  late final GeneratedColumn<bool> activa = GeneratedColumn<bool>(
    'activa',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activa" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _fechaAsignacionMeta = const VerificationMeta(
    'fechaAsignacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaAsignacion =
      GeneratedColumn<DateTime>(
        'fecha_asignacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    rutinaId,
    profesorId,
    alumnoId,
    dia,
    activa,
    fechaAsignacion,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rutinas_asignadas';
  @override
  VerificationContext validateIntegrity(
    Insertable<RutinaAsignadaDb> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('rutina_id')) {
      context.handle(
        _rutinaIdMeta,
        rutinaId.isAcceptableOrUnknown(data['rutina_id']!, _rutinaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rutinaIdMeta);
    }
    if (data.containsKey('profesor_id')) {
      context.handle(
        _profesorIdMeta,
        profesorId.isAcceptableOrUnknown(data['profesor_id']!, _profesorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profesorIdMeta);
    }
    if (data.containsKey('alumno_id')) {
      context.handle(
        _alumnoIdMeta,
        alumnoId.isAcceptableOrUnknown(data['alumno_id']!, _alumnoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_alumnoIdMeta);
    }
    if (data.containsKey('dia')) {
      context.handle(
        _diaMeta,
        dia.isAcceptableOrUnknown(data['dia']!, _diaMeta),
      );
    } else if (isInserting) {
      context.missing(_diaMeta);
    }
    if (data.containsKey('activa')) {
      context.handle(
        _activaMeta,
        activa.isAcceptableOrUnknown(data['activa']!, _activaMeta),
      );
    }
    if (data.containsKey('fecha_asignacion')) {
      context.handle(
        _fechaAsignacionMeta,
        fechaAsignacion.isAcceptableOrUnknown(
          data['fecha_asignacion']!,
          _fechaAsignacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaAsignacionMeta);
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RutinaAsignadaDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RutinaAsignadaDb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rutinaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rutina_id'],
      )!,
      profesorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profesor_id'],
      )!,
      alumnoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alumno_id'],
      )!,
      dia: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dia'],
      )!,
      activa: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activa'],
      )!,
      fechaAsignacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_asignacion'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  $RutinasAsignadasTable createAlias(String alias) {
    return $RutinasAsignadasTable(attachedDatabase, alias);
  }
}

class RutinaAsignadaDb extends DataClass
    implements Insertable<RutinaAsignadaDb> {
  final String id;
  final String rutinaId;
  final String profesorId;
  final String alumnoId;
  final int dia;
  final bool activa;
  final DateTime fechaAsignacion;
  final DateTime creadoEn;
  const RutinaAsignadaDb({
    required this.id,
    required this.rutinaId,
    required this.profesorId,
    required this.alumnoId,
    required this.dia,
    required this.activa,
    required this.fechaAsignacion,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['rutina_id'] = Variable<String>(rutinaId);
    map['profesor_id'] = Variable<String>(profesorId);
    map['alumno_id'] = Variable<String>(alumnoId);
    map['dia'] = Variable<int>(dia);
    map['activa'] = Variable<bool>(activa);
    map['fecha_asignacion'] = Variable<DateTime>(fechaAsignacion);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    return map;
  }

  RutinasAsignadasCompanion toCompanion(bool nullToAbsent) {
    return RutinasAsignadasCompanion(
      id: Value(id),
      rutinaId: Value(rutinaId),
      profesorId: Value(profesorId),
      alumnoId: Value(alumnoId),
      dia: Value(dia),
      activa: Value(activa),
      fechaAsignacion: Value(fechaAsignacion),
      creadoEn: Value(creadoEn),
    );
  }

  factory RutinaAsignadaDb.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RutinaAsignadaDb(
      id: serializer.fromJson<String>(json['id']),
      rutinaId: serializer.fromJson<String>(json['rutinaId']),
      profesorId: serializer.fromJson<String>(json['profesorId']),
      alumnoId: serializer.fromJson<String>(json['alumnoId']),
      dia: serializer.fromJson<int>(json['dia']),
      activa: serializer.fromJson<bool>(json['activa']),
      fechaAsignacion: serializer.fromJson<DateTime>(json['fechaAsignacion']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rutinaId': serializer.toJson<String>(rutinaId),
      'profesorId': serializer.toJson<String>(profesorId),
      'alumnoId': serializer.toJson<String>(alumnoId),
      'dia': serializer.toJson<int>(dia),
      'activa': serializer.toJson<bool>(activa),
      'fechaAsignacion': serializer.toJson<DateTime>(fechaAsignacion),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
    };
  }

  RutinaAsignadaDb copyWith({
    String? id,
    String? rutinaId,
    String? profesorId,
    String? alumnoId,
    int? dia,
    bool? activa,
    DateTime? fechaAsignacion,
    DateTime? creadoEn,
  }) => RutinaAsignadaDb(
    id: id ?? this.id,
    rutinaId: rutinaId ?? this.rutinaId,
    profesorId: profesorId ?? this.profesorId,
    alumnoId: alumnoId ?? this.alumnoId,
    dia: dia ?? this.dia,
    activa: activa ?? this.activa,
    fechaAsignacion: fechaAsignacion ?? this.fechaAsignacion,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  RutinaAsignadaDb copyWithCompanion(RutinasAsignadasCompanion data) {
    return RutinaAsignadaDb(
      id: data.id.present ? data.id.value : this.id,
      rutinaId: data.rutinaId.present ? data.rutinaId.value : this.rutinaId,
      profesorId: data.profesorId.present
          ? data.profesorId.value
          : this.profesorId,
      alumnoId: data.alumnoId.present ? data.alumnoId.value : this.alumnoId,
      dia: data.dia.present ? data.dia.value : this.dia,
      activa: data.activa.present ? data.activa.value : this.activa,
      fechaAsignacion: data.fechaAsignacion.present
          ? data.fechaAsignacion.value
          : this.fechaAsignacion,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RutinaAsignadaDb(')
          ..write('id: $id, ')
          ..write('rutinaId: $rutinaId, ')
          ..write('profesorId: $profesorId, ')
          ..write('alumnoId: $alumnoId, ')
          ..write('dia: $dia, ')
          ..write('activa: $activa, ')
          ..write('fechaAsignacion: $fechaAsignacion, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    rutinaId,
    profesorId,
    alumnoId,
    dia,
    activa,
    fechaAsignacion,
    creadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RutinaAsignadaDb &&
          other.id == this.id &&
          other.rutinaId == this.rutinaId &&
          other.profesorId == this.profesorId &&
          other.alumnoId == this.alumnoId &&
          other.dia == this.dia &&
          other.activa == this.activa &&
          other.fechaAsignacion == this.fechaAsignacion &&
          other.creadoEn == this.creadoEn);
}

class RutinasAsignadasCompanion extends UpdateCompanion<RutinaAsignadaDb> {
  final Value<String> id;
  final Value<String> rutinaId;
  final Value<String> profesorId;
  final Value<String> alumnoId;
  final Value<int> dia;
  final Value<bool> activa;
  final Value<DateTime> fechaAsignacion;
  final Value<DateTime> creadoEn;
  final Value<int> rowid;
  const RutinasAsignadasCompanion({
    this.id = const Value.absent(),
    this.rutinaId = const Value.absent(),
    this.profesorId = const Value.absent(),
    this.alumnoId = const Value.absent(),
    this.dia = const Value.absent(),
    this.activa = const Value.absent(),
    this.fechaAsignacion = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RutinasAsignadasCompanion.insert({
    required String id,
    required String rutinaId,
    required String profesorId,
    required String alumnoId,
    required int dia,
    this.activa = const Value.absent(),
    required DateTime fechaAsignacion,
    this.creadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rutinaId = Value(rutinaId),
       profesorId = Value(profesorId),
       alumnoId = Value(alumnoId),
       dia = Value(dia),
       fechaAsignacion = Value(fechaAsignacion);
  static Insertable<RutinaAsignadaDb> custom({
    Expression<String>? id,
    Expression<String>? rutinaId,
    Expression<String>? profesorId,
    Expression<String>? alumnoId,
    Expression<int>? dia,
    Expression<bool>? activa,
    Expression<DateTime>? fechaAsignacion,
    Expression<DateTime>? creadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rutinaId != null) 'rutina_id': rutinaId,
      if (profesorId != null) 'profesor_id': profesorId,
      if (alumnoId != null) 'alumno_id': alumnoId,
      if (dia != null) 'dia': dia,
      if (activa != null) 'activa': activa,
      if (fechaAsignacion != null) 'fecha_asignacion': fechaAsignacion,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RutinasAsignadasCompanion copyWith({
    Value<String>? id,
    Value<String>? rutinaId,
    Value<String>? profesorId,
    Value<String>? alumnoId,
    Value<int>? dia,
    Value<bool>? activa,
    Value<DateTime>? fechaAsignacion,
    Value<DateTime>? creadoEn,
    Value<int>? rowid,
  }) {
    return RutinasAsignadasCompanion(
      id: id ?? this.id,
      rutinaId: rutinaId ?? this.rutinaId,
      profesorId: profesorId ?? this.profesorId,
      alumnoId: alumnoId ?? this.alumnoId,
      dia: dia ?? this.dia,
      activa: activa ?? this.activa,
      fechaAsignacion: fechaAsignacion ?? this.fechaAsignacion,
      creadoEn: creadoEn ?? this.creadoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (rutinaId.present) {
      map['rutina_id'] = Variable<String>(rutinaId.value);
    }
    if (profesorId.present) {
      map['profesor_id'] = Variable<String>(profesorId.value);
    }
    if (alumnoId.present) {
      map['alumno_id'] = Variable<String>(alumnoId.value);
    }
    if (dia.present) {
      map['dia'] = Variable<int>(dia.value);
    }
    if (activa.present) {
      map['activa'] = Variable<bool>(activa.value);
    }
    if (fechaAsignacion.present) {
      map['fecha_asignacion'] = Variable<DateTime>(fechaAsignacion.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RutinasAsignadasCompanion(')
          ..write('id: $id, ')
          ..write('rutinaId: $rutinaId, ')
          ..write('profesorId: $profesorId, ')
          ..write('alumnoId: $alumnoId, ')
          ..write('dia: $dia, ')
          ..write('activa: $activa, ')
          ..write('fechaAsignacion: $fechaAsignacion, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntrenamientosTable extends Entrenamientos
    with TableInfo<$EntrenamientosTable, EntrenamientoDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntrenamientosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alumnoIdMeta = const VerificationMeta(
    'alumnoId',
  );
  @override
  late final GeneratedColumn<String> alumnoId = GeneratedColumn<String>(
    'alumno_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rutinaIdMeta = const VerificationMeta(
    'rutinaId',
  );
  @override
  late final GeneratedColumn<String> rutinaId = GeneratedColumn<String>(
    'rutina_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rutinaAsignadaIdMeta = const VerificationMeta(
    'rutinaAsignadaId',
  );
  @override
  late final GeneratedColumn<String> rutinaAsignadaId = GeneratedColumn<String>(
    'rutina_asignada_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaInicioMeta = const VerificationMeta(
    'fechaInicio',
  );
  @override
  late final GeneratedColumn<DateTime> fechaInicio = GeneratedColumn<DateTime>(
    'fecha_inicio',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaFinalizacionMeta = const VerificationMeta(
    'fechaFinalizacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaFinalizacion =
      GeneratedColumn<DateTime>(
        'fecha_finalizacion',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _completadoMeta = const VerificationMeta(
    'completado',
  );
  @override
  late final GeneratedColumn<bool> completado = GeneratedColumn<bool>(
    'completado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    alumnoId,
    rutinaId,
    rutinaAsignadaId,
    fechaInicio,
    fechaFinalizacion,
    completado,
    creadoEn,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entrenamientos';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntrenamientoDb> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('alumno_id')) {
      context.handle(
        _alumnoIdMeta,
        alumnoId.isAcceptableOrUnknown(data['alumno_id']!, _alumnoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_alumnoIdMeta);
    }
    if (data.containsKey('rutina_id')) {
      context.handle(
        _rutinaIdMeta,
        rutinaId.isAcceptableOrUnknown(data['rutina_id']!, _rutinaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rutinaIdMeta);
    }
    if (data.containsKey('rutina_asignada_id')) {
      context.handle(
        _rutinaAsignadaIdMeta,
        rutinaAsignadaId.isAcceptableOrUnknown(
          data['rutina_asignada_id']!,
          _rutinaAsignadaIdMeta,
        ),
      );
    }
    if (data.containsKey('fecha_inicio')) {
      context.handle(
        _fechaInicioMeta,
        fechaInicio.isAcceptableOrUnknown(
          data['fecha_inicio']!,
          _fechaInicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaInicioMeta);
    }
    if (data.containsKey('fecha_finalizacion')) {
      context.handle(
        _fechaFinalizacionMeta,
        fechaFinalizacion.isAcceptableOrUnknown(
          data['fecha_finalizacion']!,
          _fechaFinalizacionMeta,
        ),
      );
    }
    if (data.containsKey('completado')) {
      context.handle(
        _completadoMeta,
        completado.isAcceptableOrUnknown(data['completado']!, _completadoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntrenamientoDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntrenamientoDb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      alumnoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alumno_id'],
      )!,
      rutinaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rutina_id'],
      )!,
      rutinaAsignadaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rutina_asignada_id'],
      ),
      fechaInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_inicio'],
      )!,
      fechaFinalizacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_finalizacion'],
      ),
      completado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completado'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $EntrenamientosTable createAlias(String alias) {
    return $EntrenamientosTable(attachedDatabase, alias);
  }
}

class EntrenamientoDb extends DataClass implements Insertable<EntrenamientoDb> {
  final String id;
  final String alumnoId;
  final String rutinaId;
  final String? rutinaAsignadaId;
  final DateTime fechaInicio;
  final DateTime? fechaFinalizacion;
  final bool completado;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  const EntrenamientoDb({
    required this.id,
    required this.alumnoId,
    required this.rutinaId,
    this.rutinaAsignadaId,
    required this.fechaInicio,
    this.fechaFinalizacion,
    required this.completado,
    required this.creadoEn,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['alumno_id'] = Variable<String>(alumnoId);
    map['rutina_id'] = Variable<String>(rutinaId);
    if (!nullToAbsent || rutinaAsignadaId != null) {
      map['rutina_asignada_id'] = Variable<String>(rutinaAsignadaId);
    }
    map['fecha_inicio'] = Variable<DateTime>(fechaInicio);
    if (!nullToAbsent || fechaFinalizacion != null) {
      map['fecha_finalizacion'] = Variable<DateTime>(fechaFinalizacion);
    }
    map['completado'] = Variable<bool>(completado);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  EntrenamientosCompanion toCompanion(bool nullToAbsent) {
    return EntrenamientosCompanion(
      id: Value(id),
      alumnoId: Value(alumnoId),
      rutinaId: Value(rutinaId),
      rutinaAsignadaId: rutinaAsignadaId == null && nullToAbsent
          ? const Value.absent()
          : Value(rutinaAsignadaId),
      fechaInicio: Value(fechaInicio),
      fechaFinalizacion: fechaFinalizacion == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaFinalizacion),
      completado: Value(completado),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory EntrenamientoDb.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntrenamientoDb(
      id: serializer.fromJson<String>(json['id']),
      alumnoId: serializer.fromJson<String>(json['alumnoId']),
      rutinaId: serializer.fromJson<String>(json['rutinaId']),
      rutinaAsignadaId: serializer.fromJson<String?>(json['rutinaAsignadaId']),
      fechaInicio: serializer.fromJson<DateTime>(json['fechaInicio']),
      fechaFinalizacion: serializer.fromJson<DateTime?>(
        json['fechaFinalizacion'],
      ),
      completado: serializer.fromJson<bool>(json['completado']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'alumnoId': serializer.toJson<String>(alumnoId),
      'rutinaId': serializer.toJson<String>(rutinaId),
      'rutinaAsignadaId': serializer.toJson<String?>(rutinaAsignadaId),
      'fechaInicio': serializer.toJson<DateTime>(fechaInicio),
      'fechaFinalizacion': serializer.toJson<DateTime?>(fechaFinalizacion),
      'completado': serializer.toJson<bool>(completado),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  EntrenamientoDb copyWith({
    String? id,
    String? alumnoId,
    String? rutinaId,
    Value<String?> rutinaAsignadaId = const Value.absent(),
    DateTime? fechaInicio,
    Value<DateTime?> fechaFinalizacion = const Value.absent(),
    bool? completado,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) => EntrenamientoDb(
    id: id ?? this.id,
    alumnoId: alumnoId ?? this.alumnoId,
    rutinaId: rutinaId ?? this.rutinaId,
    rutinaAsignadaId: rutinaAsignadaId.present
        ? rutinaAsignadaId.value
        : this.rutinaAsignadaId,
    fechaInicio: fechaInicio ?? this.fechaInicio,
    fechaFinalizacion: fechaFinalizacion.present
        ? fechaFinalizacion.value
        : this.fechaFinalizacion,
    completado: completado ?? this.completado,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  EntrenamientoDb copyWithCompanion(EntrenamientosCompanion data) {
    return EntrenamientoDb(
      id: data.id.present ? data.id.value : this.id,
      alumnoId: data.alumnoId.present ? data.alumnoId.value : this.alumnoId,
      rutinaId: data.rutinaId.present ? data.rutinaId.value : this.rutinaId,
      rutinaAsignadaId: data.rutinaAsignadaId.present
          ? data.rutinaAsignadaId.value
          : this.rutinaAsignadaId,
      fechaInicio: data.fechaInicio.present
          ? data.fechaInicio.value
          : this.fechaInicio,
      fechaFinalizacion: data.fechaFinalizacion.present
          ? data.fechaFinalizacion.value
          : this.fechaFinalizacion,
      completado: data.completado.present
          ? data.completado.value
          : this.completado,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntrenamientoDb(')
          ..write('id: $id, ')
          ..write('alumnoId: $alumnoId, ')
          ..write('rutinaId: $rutinaId, ')
          ..write('rutinaAsignadaId: $rutinaAsignadaId, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFinalizacion: $fechaFinalizacion, ')
          ..write('completado: $completado, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    alumnoId,
    rutinaId,
    rutinaAsignadaId,
    fechaInicio,
    fechaFinalizacion,
    completado,
    creadoEn,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntrenamientoDb &&
          other.id == this.id &&
          other.alumnoId == this.alumnoId &&
          other.rutinaId == this.rutinaId &&
          other.rutinaAsignadaId == this.rutinaAsignadaId &&
          other.fechaInicio == this.fechaInicio &&
          other.fechaFinalizacion == this.fechaFinalizacion &&
          other.completado == this.completado &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn);
}

class EntrenamientosCompanion extends UpdateCompanion<EntrenamientoDb> {
  final Value<String> id;
  final Value<String> alumnoId;
  final Value<String> rutinaId;
  final Value<String?> rutinaAsignadaId;
  final Value<DateTime> fechaInicio;
  final Value<DateTime?> fechaFinalizacion;
  final Value<bool> completado;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  final Value<int> rowid;
  const EntrenamientosCompanion({
    this.id = const Value.absent(),
    this.alumnoId = const Value.absent(),
    this.rutinaId = const Value.absent(),
    this.rutinaAsignadaId = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaFinalizacion = const Value.absent(),
    this.completado = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntrenamientosCompanion.insert({
    required String id,
    required String alumnoId,
    required String rutinaId,
    this.rutinaAsignadaId = const Value.absent(),
    required DateTime fechaInicio,
    this.fechaFinalizacion = const Value.absent(),
    this.completado = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       alumnoId = Value(alumnoId),
       rutinaId = Value(rutinaId),
       fechaInicio = Value(fechaInicio);
  static Insertable<EntrenamientoDb> custom({
    Expression<String>? id,
    Expression<String>? alumnoId,
    Expression<String>? rutinaId,
    Expression<String>? rutinaAsignadaId,
    Expression<DateTime>? fechaInicio,
    Expression<DateTime>? fechaFinalizacion,
    Expression<bool>? completado,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (alumnoId != null) 'alumno_id': alumnoId,
      if (rutinaId != null) 'rutina_id': rutinaId,
      if (rutinaAsignadaId != null) 'rutina_asignada_id': rutinaAsignadaId,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (fechaFinalizacion != null) 'fecha_finalizacion': fechaFinalizacion,
      if (completado != null) 'completado': completado,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntrenamientosCompanion copyWith({
    Value<String>? id,
    Value<String>? alumnoId,
    Value<String>? rutinaId,
    Value<String?>? rutinaAsignadaId,
    Value<DateTime>? fechaInicio,
    Value<DateTime?>? fechaFinalizacion,
    Value<bool>? completado,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
    Value<int>? rowid,
  }) {
    return EntrenamientosCompanion(
      id: id ?? this.id,
      alumnoId: alumnoId ?? this.alumnoId,
      rutinaId: rutinaId ?? this.rutinaId,
      rutinaAsignadaId: rutinaAsignadaId ?? this.rutinaAsignadaId,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFinalizacion: fechaFinalizacion ?? this.fechaFinalizacion,
      completado: completado ?? this.completado,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (alumnoId.present) {
      map['alumno_id'] = Variable<String>(alumnoId.value);
    }
    if (rutinaId.present) {
      map['rutina_id'] = Variable<String>(rutinaId.value);
    }
    if (rutinaAsignadaId.present) {
      map['rutina_asignada_id'] = Variable<String>(rutinaAsignadaId.value);
    }
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio.value);
    }
    if (fechaFinalizacion.present) {
      map['fecha_finalizacion'] = Variable<DateTime>(fechaFinalizacion.value);
    }
    if (completado.present) {
      map['completado'] = Variable<bool>(completado.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntrenamientosCompanion(')
          ..write('id: $id, ')
          ..write('alumnoId: $alumnoId, ')
          ..write('rutinaId: $rutinaId, ')
          ..write('rutinaAsignadaId: $rutinaAsignadaId, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFinalizacion: $fechaFinalizacion, ')
          ..write('completado: $completado, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RegistrosEjercicioTable extends RegistrosEjercicio
    with TableInfo<$RegistrosEjercicioTable, RegistroEjercicioDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegistrosEjercicioTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entrenamientoIdMeta = const VerificationMeta(
    'entrenamientoId',
  );
  @override
  late final GeneratedColumn<String> entrenamientoId = GeneratedColumn<String>(
    'entrenamiento_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ejercicioIdMeta = const VerificationMeta(
    'ejercicioId',
  );
  @override
  late final GeneratedColumn<String> ejercicioId = GeneratedColumn<String>(
    'ejercicio_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreEjercicioMeta = const VerificationMeta(
    'nombreEjercicio',
  );
  @override
  late final GeneratedColumn<String> nombreEjercicio = GeneratedColumn<String>(
    'nombre_ejercicio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seriesMeta = const VerificationMeta('series');
  @override
  late final GeneratedColumn<int> series = GeneratedColumn<int>(
    'series',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeticionesMeta = const VerificationMeta(
    'repeticiones',
  );
  @override
  late final GeneratedColumn<String> repeticiones = GeneratedColumn<String>(
    'repeticiones',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _llevaPesoMeta = const VerificationMeta(
    'llevaPeso',
  );
  @override
  late final GeneratedColumn<bool> llevaPeso = GeneratedColumn<bool>(
    'lleva_peso',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("lleva_peso" IN (0, 1))',
    ),
  );
  static const VerificationMeta _pesoUsadoMeta = const VerificationMeta(
    'pesoUsado',
  );
  @override
  late final GeneratedColumn<double> pesoUsado = GeneratedColumn<double>(
    'peso_usado',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
    'nota',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completadoMeta = const VerificationMeta(
    'completado',
  );
  @override
  late final GeneratedColumn<bool> completado = GeneratedColumn<bool>(
    'completado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ordenMeta = const VerificationMeta('orden');
  @override
  late final GeneratedColumn<int> orden = GeneratedColumn<int>(
    'orden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entrenamientoId,
    ejercicioId,
    nombreEjercicio,
    series,
    repeticiones,
    llevaPeso,
    pesoUsado,
    nota,
    completado,
    orden,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'registros_ejercicio';
  @override
  VerificationContext validateIntegrity(
    Insertable<RegistroEjercicioDb> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entrenamiento_id')) {
      context.handle(
        _entrenamientoIdMeta,
        entrenamientoId.isAcceptableOrUnknown(
          data['entrenamiento_id']!,
          _entrenamientoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entrenamientoIdMeta);
    }
    if (data.containsKey('ejercicio_id')) {
      context.handle(
        _ejercicioIdMeta,
        ejercicioId.isAcceptableOrUnknown(
          data['ejercicio_id']!,
          _ejercicioIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ejercicioIdMeta);
    }
    if (data.containsKey('nombre_ejercicio')) {
      context.handle(
        _nombreEjercicioMeta,
        nombreEjercicio.isAcceptableOrUnknown(
          data['nombre_ejercicio']!,
          _nombreEjercicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreEjercicioMeta);
    }
    if (data.containsKey('series')) {
      context.handle(
        _seriesMeta,
        series.isAcceptableOrUnknown(data['series']!, _seriesMeta),
      );
    } else if (isInserting) {
      context.missing(_seriesMeta);
    }
    if (data.containsKey('repeticiones')) {
      context.handle(
        _repeticionesMeta,
        repeticiones.isAcceptableOrUnknown(
          data['repeticiones']!,
          _repeticionesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repeticionesMeta);
    }
    if (data.containsKey('lleva_peso')) {
      context.handle(
        _llevaPesoMeta,
        llevaPeso.isAcceptableOrUnknown(data['lleva_peso']!, _llevaPesoMeta),
      );
    } else if (isInserting) {
      context.missing(_llevaPesoMeta);
    }
    if (data.containsKey('peso_usado')) {
      context.handle(
        _pesoUsadoMeta,
        pesoUsado.isAcceptableOrUnknown(data['peso_usado']!, _pesoUsadoMeta),
      );
    }
    if (data.containsKey('nota')) {
      context.handle(
        _notaMeta,
        nota.isAcceptableOrUnknown(data['nota']!, _notaMeta),
      );
    }
    if (data.containsKey('completado')) {
      context.handle(
        _completadoMeta,
        completado.isAcceptableOrUnknown(data['completado']!, _completadoMeta),
      );
    }
    if (data.containsKey('orden')) {
      context.handle(
        _ordenMeta,
        orden.isAcceptableOrUnknown(data['orden']!, _ordenMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RegistroEjercicioDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegistroEjercicioDb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entrenamientoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entrenamiento_id'],
      )!,
      ejercicioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ejercicio_id'],
      )!,
      nombreEjercicio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_ejercicio'],
      )!,
      series: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}series'],
      )!,
      repeticiones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeticiones'],
      )!,
      llevaPeso: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}lleva_peso'],
      )!,
      pesoUsado: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peso_usado'],
      ),
      nota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nota'],
      ),
      completado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completado'],
      )!,
      orden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden'],
      )!,
    );
  }

  @override
  $RegistrosEjercicioTable createAlias(String alias) {
    return $RegistrosEjercicioTable(attachedDatabase, alias);
  }
}

class RegistroEjercicioDb extends DataClass
    implements Insertable<RegistroEjercicioDb> {
  final String id;
  final String entrenamientoId;
  final String ejercicioId;
  final String nombreEjercicio;
  final int series;
  final String repeticiones;
  final bool llevaPeso;
  final double? pesoUsado;
  final String? nota;
  final bool completado;
  final int orden;
  const RegistroEjercicioDb({
    required this.id,
    required this.entrenamientoId,
    required this.ejercicioId,
    required this.nombreEjercicio,
    required this.series,
    required this.repeticiones,
    required this.llevaPeso,
    this.pesoUsado,
    this.nota,
    required this.completado,
    required this.orden,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entrenamiento_id'] = Variable<String>(entrenamientoId);
    map['ejercicio_id'] = Variable<String>(ejercicioId);
    map['nombre_ejercicio'] = Variable<String>(nombreEjercicio);
    map['series'] = Variable<int>(series);
    map['repeticiones'] = Variable<String>(repeticiones);
    map['lleva_peso'] = Variable<bool>(llevaPeso);
    if (!nullToAbsent || pesoUsado != null) {
      map['peso_usado'] = Variable<double>(pesoUsado);
    }
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    map['completado'] = Variable<bool>(completado);
    map['orden'] = Variable<int>(orden);
    return map;
  }

  RegistrosEjercicioCompanion toCompanion(bool nullToAbsent) {
    return RegistrosEjercicioCompanion(
      id: Value(id),
      entrenamientoId: Value(entrenamientoId),
      ejercicioId: Value(ejercicioId),
      nombreEjercicio: Value(nombreEjercicio),
      series: Value(series),
      repeticiones: Value(repeticiones),
      llevaPeso: Value(llevaPeso),
      pesoUsado: pesoUsado == null && nullToAbsent
          ? const Value.absent()
          : Value(pesoUsado),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
      completado: Value(completado),
      orden: Value(orden),
    );
  }

  factory RegistroEjercicioDb.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegistroEjercicioDb(
      id: serializer.fromJson<String>(json['id']),
      entrenamientoId: serializer.fromJson<String>(json['entrenamientoId']),
      ejercicioId: serializer.fromJson<String>(json['ejercicioId']),
      nombreEjercicio: serializer.fromJson<String>(json['nombreEjercicio']),
      series: serializer.fromJson<int>(json['series']),
      repeticiones: serializer.fromJson<String>(json['repeticiones']),
      llevaPeso: serializer.fromJson<bool>(json['llevaPeso']),
      pesoUsado: serializer.fromJson<double?>(json['pesoUsado']),
      nota: serializer.fromJson<String?>(json['nota']),
      completado: serializer.fromJson<bool>(json['completado']),
      orden: serializer.fromJson<int>(json['orden']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entrenamientoId': serializer.toJson<String>(entrenamientoId),
      'ejercicioId': serializer.toJson<String>(ejercicioId),
      'nombreEjercicio': serializer.toJson<String>(nombreEjercicio),
      'series': serializer.toJson<int>(series),
      'repeticiones': serializer.toJson<String>(repeticiones),
      'llevaPeso': serializer.toJson<bool>(llevaPeso),
      'pesoUsado': serializer.toJson<double?>(pesoUsado),
      'nota': serializer.toJson<String?>(nota),
      'completado': serializer.toJson<bool>(completado),
      'orden': serializer.toJson<int>(orden),
    };
  }

  RegistroEjercicioDb copyWith({
    String? id,
    String? entrenamientoId,
    String? ejercicioId,
    String? nombreEjercicio,
    int? series,
    String? repeticiones,
    bool? llevaPeso,
    Value<double?> pesoUsado = const Value.absent(),
    Value<String?> nota = const Value.absent(),
    bool? completado,
    int? orden,
  }) => RegistroEjercicioDb(
    id: id ?? this.id,
    entrenamientoId: entrenamientoId ?? this.entrenamientoId,
    ejercicioId: ejercicioId ?? this.ejercicioId,
    nombreEjercicio: nombreEjercicio ?? this.nombreEjercicio,
    series: series ?? this.series,
    repeticiones: repeticiones ?? this.repeticiones,
    llevaPeso: llevaPeso ?? this.llevaPeso,
    pesoUsado: pesoUsado.present ? pesoUsado.value : this.pesoUsado,
    nota: nota.present ? nota.value : this.nota,
    completado: completado ?? this.completado,
    orden: orden ?? this.orden,
  );
  RegistroEjercicioDb copyWithCompanion(RegistrosEjercicioCompanion data) {
    return RegistroEjercicioDb(
      id: data.id.present ? data.id.value : this.id,
      entrenamientoId: data.entrenamientoId.present
          ? data.entrenamientoId.value
          : this.entrenamientoId,
      ejercicioId: data.ejercicioId.present
          ? data.ejercicioId.value
          : this.ejercicioId,
      nombreEjercicio: data.nombreEjercicio.present
          ? data.nombreEjercicio.value
          : this.nombreEjercicio,
      series: data.series.present ? data.series.value : this.series,
      repeticiones: data.repeticiones.present
          ? data.repeticiones.value
          : this.repeticiones,
      llevaPeso: data.llevaPeso.present ? data.llevaPeso.value : this.llevaPeso,
      pesoUsado: data.pesoUsado.present ? data.pesoUsado.value : this.pesoUsado,
      nota: data.nota.present ? data.nota.value : this.nota,
      completado: data.completado.present
          ? data.completado.value
          : this.completado,
      orden: data.orden.present ? data.orden.value : this.orden,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegistroEjercicioDb(')
          ..write('id: $id, ')
          ..write('entrenamientoId: $entrenamientoId, ')
          ..write('ejercicioId: $ejercicioId, ')
          ..write('nombreEjercicio: $nombreEjercicio, ')
          ..write('series: $series, ')
          ..write('repeticiones: $repeticiones, ')
          ..write('llevaPeso: $llevaPeso, ')
          ..write('pesoUsado: $pesoUsado, ')
          ..write('nota: $nota, ')
          ..write('completado: $completado, ')
          ..write('orden: $orden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entrenamientoId,
    ejercicioId,
    nombreEjercicio,
    series,
    repeticiones,
    llevaPeso,
    pesoUsado,
    nota,
    completado,
    orden,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegistroEjercicioDb &&
          other.id == this.id &&
          other.entrenamientoId == this.entrenamientoId &&
          other.ejercicioId == this.ejercicioId &&
          other.nombreEjercicio == this.nombreEjercicio &&
          other.series == this.series &&
          other.repeticiones == this.repeticiones &&
          other.llevaPeso == this.llevaPeso &&
          other.pesoUsado == this.pesoUsado &&
          other.nota == this.nota &&
          other.completado == this.completado &&
          other.orden == this.orden);
}

class RegistrosEjercicioCompanion extends UpdateCompanion<RegistroEjercicioDb> {
  final Value<String> id;
  final Value<String> entrenamientoId;
  final Value<String> ejercicioId;
  final Value<String> nombreEjercicio;
  final Value<int> series;
  final Value<String> repeticiones;
  final Value<bool> llevaPeso;
  final Value<double?> pesoUsado;
  final Value<String?> nota;
  final Value<bool> completado;
  final Value<int> orden;
  final Value<int> rowid;
  const RegistrosEjercicioCompanion({
    this.id = const Value.absent(),
    this.entrenamientoId = const Value.absent(),
    this.ejercicioId = const Value.absent(),
    this.nombreEjercicio = const Value.absent(),
    this.series = const Value.absent(),
    this.repeticiones = const Value.absent(),
    this.llevaPeso = const Value.absent(),
    this.pesoUsado = const Value.absent(),
    this.nota = const Value.absent(),
    this.completado = const Value.absent(),
    this.orden = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RegistrosEjercicioCompanion.insert({
    required String id,
    required String entrenamientoId,
    required String ejercicioId,
    required String nombreEjercicio,
    required int series,
    required String repeticiones,
    required bool llevaPeso,
    this.pesoUsado = const Value.absent(),
    this.nota = const Value.absent(),
    this.completado = const Value.absent(),
    required int orden,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entrenamientoId = Value(entrenamientoId),
       ejercicioId = Value(ejercicioId),
       nombreEjercicio = Value(nombreEjercicio),
       series = Value(series),
       repeticiones = Value(repeticiones),
       llevaPeso = Value(llevaPeso),
       orden = Value(orden);
  static Insertable<RegistroEjercicioDb> custom({
    Expression<String>? id,
    Expression<String>? entrenamientoId,
    Expression<String>? ejercicioId,
    Expression<String>? nombreEjercicio,
    Expression<int>? series,
    Expression<String>? repeticiones,
    Expression<bool>? llevaPeso,
    Expression<double>? pesoUsado,
    Expression<String>? nota,
    Expression<bool>? completado,
    Expression<int>? orden,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entrenamientoId != null) 'entrenamiento_id': entrenamientoId,
      if (ejercicioId != null) 'ejercicio_id': ejercicioId,
      if (nombreEjercicio != null) 'nombre_ejercicio': nombreEjercicio,
      if (series != null) 'series': series,
      if (repeticiones != null) 'repeticiones': repeticiones,
      if (llevaPeso != null) 'lleva_peso': llevaPeso,
      if (pesoUsado != null) 'peso_usado': pesoUsado,
      if (nota != null) 'nota': nota,
      if (completado != null) 'completado': completado,
      if (orden != null) 'orden': orden,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RegistrosEjercicioCompanion copyWith({
    Value<String>? id,
    Value<String>? entrenamientoId,
    Value<String>? ejercicioId,
    Value<String>? nombreEjercicio,
    Value<int>? series,
    Value<String>? repeticiones,
    Value<bool>? llevaPeso,
    Value<double?>? pesoUsado,
    Value<String?>? nota,
    Value<bool>? completado,
    Value<int>? orden,
    Value<int>? rowid,
  }) {
    return RegistrosEjercicioCompanion(
      id: id ?? this.id,
      entrenamientoId: entrenamientoId ?? this.entrenamientoId,
      ejercicioId: ejercicioId ?? this.ejercicioId,
      nombreEjercicio: nombreEjercicio ?? this.nombreEjercicio,
      series: series ?? this.series,
      repeticiones: repeticiones ?? this.repeticiones,
      llevaPeso: llevaPeso ?? this.llevaPeso,
      pesoUsado: pesoUsado ?? this.pesoUsado,
      nota: nota ?? this.nota,
      completado: completado ?? this.completado,
      orden: orden ?? this.orden,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entrenamientoId.present) {
      map['entrenamiento_id'] = Variable<String>(entrenamientoId.value);
    }
    if (ejercicioId.present) {
      map['ejercicio_id'] = Variable<String>(ejercicioId.value);
    }
    if (nombreEjercicio.present) {
      map['nombre_ejercicio'] = Variable<String>(nombreEjercicio.value);
    }
    if (series.present) {
      map['series'] = Variable<int>(series.value);
    }
    if (repeticiones.present) {
      map['repeticiones'] = Variable<String>(repeticiones.value);
    }
    if (llevaPeso.present) {
      map['lleva_peso'] = Variable<bool>(llevaPeso.value);
    }
    if (pesoUsado.present) {
      map['peso_usado'] = Variable<double>(pesoUsado.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (completado.present) {
      map['completado'] = Variable<bool>(completado.value);
    }
    if (orden.present) {
      map['orden'] = Variable<int>(orden.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegistrosEjercicioCompanion(')
          ..write('id: $id, ')
          ..write('entrenamientoId: $entrenamientoId, ')
          ..write('ejercicioId: $ejercicioId, ')
          ..write('nombreEjercicio: $nombreEjercicio, ')
          ..write('series: $series, ')
          ..write('repeticiones: $repeticiones, ')
          ..write('llevaPeso: $llevaPeso, ')
          ..write('pesoUsado: $pesoUsado, ')
          ..write('nota: $nota, ')
          ..write('completado: $completado, ')
          ..write('orden: $orden, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntrenamientosEnCursoTable extends EntrenamientosEnCurso
    with TableInfo<$EntrenamientosEnCursoTable, EntrenamientoEnCursoDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntrenamientosEnCursoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alumnoIdMeta = const VerificationMeta(
    'alumnoId',
  );
  @override
  late final GeneratedColumn<String> alumnoId = GeneratedColumn<String>(
    'alumno_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rutinaIdMeta = const VerificationMeta(
    'rutinaId',
  );
  @override
  late final GeneratedColumn<String> rutinaId = GeneratedColumn<String>(
    'rutina_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaInicioMeta = const VerificationMeta(
    'fechaInicio',
  );
  @override
  late final GeneratedColumn<DateTime> fechaInicio = GeneratedColumn<DateTime>(
    'fecha_inicio',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    alumnoId,
    rutinaId,
    fechaInicio,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entrenamientos_en_curso';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntrenamientoEnCursoDb> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('alumno_id')) {
      context.handle(
        _alumnoIdMeta,
        alumnoId.isAcceptableOrUnknown(data['alumno_id']!, _alumnoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_alumnoIdMeta);
    }
    if (data.containsKey('rutina_id')) {
      context.handle(
        _rutinaIdMeta,
        rutinaId.isAcceptableOrUnknown(data['rutina_id']!, _rutinaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rutinaIdMeta);
    }
    if (data.containsKey('fecha_inicio')) {
      context.handle(
        _fechaInicioMeta,
        fechaInicio.isAcceptableOrUnknown(
          data['fecha_inicio']!,
          _fechaInicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaInicioMeta);
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntrenamientoEnCursoDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntrenamientoEnCursoDb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      alumnoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alumno_id'],
      )!,
      rutinaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rutina_id'],
      )!,
      fechaInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_inicio'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $EntrenamientosEnCursoTable createAlias(String alias) {
    return $EntrenamientosEnCursoTable(attachedDatabase, alias);
  }
}

class EntrenamientoEnCursoDb extends DataClass
    implements Insertable<EntrenamientoEnCursoDb> {
  final String id;
  final String alumnoId;
  final String rutinaId;
  final DateTime fechaInicio;
  final DateTime actualizadoEn;
  const EntrenamientoEnCursoDb({
    required this.id,
    required this.alumnoId,
    required this.rutinaId,
    required this.fechaInicio,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['alumno_id'] = Variable<String>(alumnoId);
    map['rutina_id'] = Variable<String>(rutinaId);
    map['fecha_inicio'] = Variable<DateTime>(fechaInicio);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  EntrenamientosEnCursoCompanion toCompanion(bool nullToAbsent) {
    return EntrenamientosEnCursoCompanion(
      id: Value(id),
      alumnoId: Value(alumnoId),
      rutinaId: Value(rutinaId),
      fechaInicio: Value(fechaInicio),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory EntrenamientoEnCursoDb.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntrenamientoEnCursoDb(
      id: serializer.fromJson<String>(json['id']),
      alumnoId: serializer.fromJson<String>(json['alumnoId']),
      rutinaId: serializer.fromJson<String>(json['rutinaId']),
      fechaInicio: serializer.fromJson<DateTime>(json['fechaInicio']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'alumnoId': serializer.toJson<String>(alumnoId),
      'rutinaId': serializer.toJson<String>(rutinaId),
      'fechaInicio': serializer.toJson<DateTime>(fechaInicio),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  EntrenamientoEnCursoDb copyWith({
    String? id,
    String? alumnoId,
    String? rutinaId,
    DateTime? fechaInicio,
    DateTime? actualizadoEn,
  }) => EntrenamientoEnCursoDb(
    id: id ?? this.id,
    alumnoId: alumnoId ?? this.alumnoId,
    rutinaId: rutinaId ?? this.rutinaId,
    fechaInicio: fechaInicio ?? this.fechaInicio,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  EntrenamientoEnCursoDb copyWithCompanion(
    EntrenamientosEnCursoCompanion data,
  ) {
    return EntrenamientoEnCursoDb(
      id: data.id.present ? data.id.value : this.id,
      alumnoId: data.alumnoId.present ? data.alumnoId.value : this.alumnoId,
      rutinaId: data.rutinaId.present ? data.rutinaId.value : this.rutinaId,
      fechaInicio: data.fechaInicio.present
          ? data.fechaInicio.value
          : this.fechaInicio,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntrenamientoEnCursoDb(')
          ..write('id: $id, ')
          ..write('alumnoId: $alumnoId, ')
          ..write('rutinaId: $rutinaId, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, alumnoId, rutinaId, fechaInicio, actualizadoEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntrenamientoEnCursoDb &&
          other.id == this.id &&
          other.alumnoId == this.alumnoId &&
          other.rutinaId == this.rutinaId &&
          other.fechaInicio == this.fechaInicio &&
          other.actualizadoEn == this.actualizadoEn);
}

class EntrenamientosEnCursoCompanion
    extends UpdateCompanion<EntrenamientoEnCursoDb> {
  final Value<String> id;
  final Value<String> alumnoId;
  final Value<String> rutinaId;
  final Value<DateTime> fechaInicio;
  final Value<DateTime> actualizadoEn;
  final Value<int> rowid;
  const EntrenamientosEnCursoCompanion({
    this.id = const Value.absent(),
    this.alumnoId = const Value.absent(),
    this.rutinaId = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntrenamientosEnCursoCompanion.insert({
    required String id,
    required String alumnoId,
    required String rutinaId,
    required DateTime fechaInicio,
    this.actualizadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       alumnoId = Value(alumnoId),
       rutinaId = Value(rutinaId),
       fechaInicio = Value(fechaInicio);
  static Insertable<EntrenamientoEnCursoDb> custom({
    Expression<String>? id,
    Expression<String>? alumnoId,
    Expression<String>? rutinaId,
    Expression<DateTime>? fechaInicio,
    Expression<DateTime>? actualizadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (alumnoId != null) 'alumno_id': alumnoId,
      if (rutinaId != null) 'rutina_id': rutinaId,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntrenamientosEnCursoCompanion copyWith({
    Value<String>? id,
    Value<String>? alumnoId,
    Value<String>? rutinaId,
    Value<DateTime>? fechaInicio,
    Value<DateTime>? actualizadoEn,
    Value<int>? rowid,
  }) {
    return EntrenamientosEnCursoCompanion(
      id: id ?? this.id,
      alumnoId: alumnoId ?? this.alumnoId,
      rutinaId: rutinaId ?? this.rutinaId,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (alumnoId.present) {
      map['alumno_id'] = Variable<String>(alumnoId.value);
    }
    if (rutinaId.present) {
      map['rutina_id'] = Variable<String>(rutinaId.value);
    }
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntrenamientosEnCursoCompanion(')
          ..write('id: $id, ')
          ..write('alumnoId: $alumnoId, ')
          ..write('rutinaId: $rutinaId, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RegistrosEnCursoTable extends RegistrosEnCurso
    with TableInfo<$RegistrosEnCursoTable, RegistroEnCursoDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegistrosEnCursoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entrenamientoEnCursoIdMeta =
      const VerificationMeta('entrenamientoEnCursoId');
  @override
  late final GeneratedColumn<String> entrenamientoEnCursoId =
      GeneratedColumn<String>(
        'entrenamiento_en_curso_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _ejercicioIdMeta = const VerificationMeta(
    'ejercicioId',
  );
  @override
  late final GeneratedColumn<String> ejercicioId = GeneratedColumn<String>(
    'ejercicio_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ordenMeta = const VerificationMeta('orden');
  @override
  late final GeneratedColumn<int> orden = GeneratedColumn<int>(
    'orden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completadoMeta = const VerificationMeta(
    'completado',
  );
  @override
  late final GeneratedColumn<bool> completado = GeneratedColumn<bool>(
    'completado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pesoTextoMeta = const VerificationMeta(
    'pesoTexto',
  );
  @override
  late final GeneratedColumn<String> pesoTexto = GeneratedColumn<String>(
    'peso_texto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
    'nota',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entrenamientoEnCursoId,
    ejercicioId,
    orden,
    completado,
    pesoTexto,
    nota,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'registros_en_curso';
  @override
  VerificationContext validateIntegrity(
    Insertable<RegistroEnCursoDb> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entrenamiento_en_curso_id')) {
      context.handle(
        _entrenamientoEnCursoIdMeta,
        entrenamientoEnCursoId.isAcceptableOrUnknown(
          data['entrenamiento_en_curso_id']!,
          _entrenamientoEnCursoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entrenamientoEnCursoIdMeta);
    }
    if (data.containsKey('ejercicio_id')) {
      context.handle(
        _ejercicioIdMeta,
        ejercicioId.isAcceptableOrUnknown(
          data['ejercicio_id']!,
          _ejercicioIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ejercicioIdMeta);
    }
    if (data.containsKey('orden')) {
      context.handle(
        _ordenMeta,
        orden.isAcceptableOrUnknown(data['orden']!, _ordenMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenMeta);
    }
    if (data.containsKey('completado')) {
      context.handle(
        _completadoMeta,
        completado.isAcceptableOrUnknown(data['completado']!, _completadoMeta),
      );
    }
    if (data.containsKey('peso_texto')) {
      context.handle(
        _pesoTextoMeta,
        pesoTexto.isAcceptableOrUnknown(data['peso_texto']!, _pesoTextoMeta),
      );
    }
    if (data.containsKey('nota')) {
      context.handle(
        _notaMeta,
        nota.isAcceptableOrUnknown(data['nota']!, _notaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RegistroEnCursoDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegistroEnCursoDb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entrenamientoEnCursoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entrenamiento_en_curso_id'],
      )!,
      ejercicioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ejercicio_id'],
      )!,
      orden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden'],
      )!,
      completado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completado'],
      )!,
      pesoTexto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}peso_texto'],
      )!,
      nota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nota'],
      )!,
    );
  }

  @override
  $RegistrosEnCursoTable createAlias(String alias) {
    return $RegistrosEnCursoTable(attachedDatabase, alias);
  }
}

class RegistroEnCursoDb extends DataClass
    implements Insertable<RegistroEnCursoDb> {
  final String id;
  final String entrenamientoEnCursoId;
  final String ejercicioId;
  final int orden;
  final bool completado;
  final String pesoTexto;
  final String nota;
  const RegistroEnCursoDb({
    required this.id,
    required this.entrenamientoEnCursoId,
    required this.ejercicioId,
    required this.orden,
    required this.completado,
    required this.pesoTexto,
    required this.nota,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entrenamiento_en_curso_id'] = Variable<String>(entrenamientoEnCursoId);
    map['ejercicio_id'] = Variable<String>(ejercicioId);
    map['orden'] = Variable<int>(orden);
    map['completado'] = Variable<bool>(completado);
    map['peso_texto'] = Variable<String>(pesoTexto);
    map['nota'] = Variable<String>(nota);
    return map;
  }

  RegistrosEnCursoCompanion toCompanion(bool nullToAbsent) {
    return RegistrosEnCursoCompanion(
      id: Value(id),
      entrenamientoEnCursoId: Value(entrenamientoEnCursoId),
      ejercicioId: Value(ejercicioId),
      orden: Value(orden),
      completado: Value(completado),
      pesoTexto: Value(pesoTexto),
      nota: Value(nota),
    );
  }

  factory RegistroEnCursoDb.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegistroEnCursoDb(
      id: serializer.fromJson<String>(json['id']),
      entrenamientoEnCursoId: serializer.fromJson<String>(
        json['entrenamientoEnCursoId'],
      ),
      ejercicioId: serializer.fromJson<String>(json['ejercicioId']),
      orden: serializer.fromJson<int>(json['orden']),
      completado: serializer.fromJson<bool>(json['completado']),
      pesoTexto: serializer.fromJson<String>(json['pesoTexto']),
      nota: serializer.fromJson<String>(json['nota']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entrenamientoEnCursoId': serializer.toJson<String>(
        entrenamientoEnCursoId,
      ),
      'ejercicioId': serializer.toJson<String>(ejercicioId),
      'orden': serializer.toJson<int>(orden),
      'completado': serializer.toJson<bool>(completado),
      'pesoTexto': serializer.toJson<String>(pesoTexto),
      'nota': serializer.toJson<String>(nota),
    };
  }

  RegistroEnCursoDb copyWith({
    String? id,
    String? entrenamientoEnCursoId,
    String? ejercicioId,
    int? orden,
    bool? completado,
    String? pesoTexto,
    String? nota,
  }) => RegistroEnCursoDb(
    id: id ?? this.id,
    entrenamientoEnCursoId:
        entrenamientoEnCursoId ?? this.entrenamientoEnCursoId,
    ejercicioId: ejercicioId ?? this.ejercicioId,
    orden: orden ?? this.orden,
    completado: completado ?? this.completado,
    pesoTexto: pesoTexto ?? this.pesoTexto,
    nota: nota ?? this.nota,
  );
  RegistroEnCursoDb copyWithCompanion(RegistrosEnCursoCompanion data) {
    return RegistroEnCursoDb(
      id: data.id.present ? data.id.value : this.id,
      entrenamientoEnCursoId: data.entrenamientoEnCursoId.present
          ? data.entrenamientoEnCursoId.value
          : this.entrenamientoEnCursoId,
      ejercicioId: data.ejercicioId.present
          ? data.ejercicioId.value
          : this.ejercicioId,
      orden: data.orden.present ? data.orden.value : this.orden,
      completado: data.completado.present
          ? data.completado.value
          : this.completado,
      pesoTexto: data.pesoTexto.present ? data.pesoTexto.value : this.pesoTexto,
      nota: data.nota.present ? data.nota.value : this.nota,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegistroEnCursoDb(')
          ..write('id: $id, ')
          ..write('entrenamientoEnCursoId: $entrenamientoEnCursoId, ')
          ..write('ejercicioId: $ejercicioId, ')
          ..write('orden: $orden, ')
          ..write('completado: $completado, ')
          ..write('pesoTexto: $pesoTexto, ')
          ..write('nota: $nota')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entrenamientoEnCursoId,
    ejercicioId,
    orden,
    completado,
    pesoTexto,
    nota,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegistroEnCursoDb &&
          other.id == this.id &&
          other.entrenamientoEnCursoId == this.entrenamientoEnCursoId &&
          other.ejercicioId == this.ejercicioId &&
          other.orden == this.orden &&
          other.completado == this.completado &&
          other.pesoTexto == this.pesoTexto &&
          other.nota == this.nota);
}

class RegistrosEnCursoCompanion extends UpdateCompanion<RegistroEnCursoDb> {
  final Value<String> id;
  final Value<String> entrenamientoEnCursoId;
  final Value<String> ejercicioId;
  final Value<int> orden;
  final Value<bool> completado;
  final Value<String> pesoTexto;
  final Value<String> nota;
  final Value<int> rowid;
  const RegistrosEnCursoCompanion({
    this.id = const Value.absent(),
    this.entrenamientoEnCursoId = const Value.absent(),
    this.ejercicioId = const Value.absent(),
    this.orden = const Value.absent(),
    this.completado = const Value.absent(),
    this.pesoTexto = const Value.absent(),
    this.nota = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RegistrosEnCursoCompanion.insert({
    required String id,
    required String entrenamientoEnCursoId,
    required String ejercicioId,
    required int orden,
    this.completado = const Value.absent(),
    this.pesoTexto = const Value.absent(),
    this.nota = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entrenamientoEnCursoId = Value(entrenamientoEnCursoId),
       ejercicioId = Value(ejercicioId),
       orden = Value(orden);
  static Insertable<RegistroEnCursoDb> custom({
    Expression<String>? id,
    Expression<String>? entrenamientoEnCursoId,
    Expression<String>? ejercicioId,
    Expression<int>? orden,
    Expression<bool>? completado,
    Expression<String>? pesoTexto,
    Expression<String>? nota,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entrenamientoEnCursoId != null)
        'entrenamiento_en_curso_id': entrenamientoEnCursoId,
      if (ejercicioId != null) 'ejercicio_id': ejercicioId,
      if (orden != null) 'orden': orden,
      if (completado != null) 'completado': completado,
      if (pesoTexto != null) 'peso_texto': pesoTexto,
      if (nota != null) 'nota': nota,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RegistrosEnCursoCompanion copyWith({
    Value<String>? id,
    Value<String>? entrenamientoEnCursoId,
    Value<String>? ejercicioId,
    Value<int>? orden,
    Value<bool>? completado,
    Value<String>? pesoTexto,
    Value<String>? nota,
    Value<int>? rowid,
  }) {
    return RegistrosEnCursoCompanion(
      id: id ?? this.id,
      entrenamientoEnCursoId:
          entrenamientoEnCursoId ?? this.entrenamientoEnCursoId,
      ejercicioId: ejercicioId ?? this.ejercicioId,
      orden: orden ?? this.orden,
      completado: completado ?? this.completado,
      pesoTexto: pesoTexto ?? this.pesoTexto,
      nota: nota ?? this.nota,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entrenamientoEnCursoId.present) {
      map['entrenamiento_en_curso_id'] = Variable<String>(
        entrenamientoEnCursoId.value,
      );
    }
    if (ejercicioId.present) {
      map['ejercicio_id'] = Variable<String>(ejercicioId.value);
    }
    if (orden.present) {
      map['orden'] = Variable<int>(orden.value);
    }
    if (completado.present) {
      map['completado'] = Variable<bool>(completado.value);
    }
    if (pesoTexto.present) {
      map['peso_texto'] = Variable<String>(pesoTexto.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegistrosEnCursoCompanion(')
          ..write('id: $id, ')
          ..write('entrenamientoEnCursoId: $entrenamientoEnCursoId, ')
          ..write('ejercicioId: $ejercicioId, ')
          ..write('orden: $orden, ')
          ..write('completado: $completado, ')
          ..write('pesoTexto: $pesoTexto, ')
          ..write('nota: $nota, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsuariosTable usuarios = $UsuariosTable(this);
  late final $RelacionesProfesorAlumnoTable relacionesProfesorAlumno =
      $RelacionesProfesorAlumnoTable(this);
  late final $RegistrosPesoTable registrosPeso = $RegistrosPesoTable(this);
  late final $EjerciciosTable ejercicios = $EjerciciosTable(this);
  late final $RutinasTable rutinas = $RutinasTable(this);
  late final $RutinaEjerciciosTable rutinaEjercicios = $RutinaEjerciciosTable(
    this,
  );
  late final $RutinasAsignadasTable rutinasAsignadas = $RutinasAsignadasTable(
    this,
  );
  late final $EntrenamientosTable entrenamientos = $EntrenamientosTable(this);
  late final $RegistrosEjercicioTable registrosEjercicio =
      $RegistrosEjercicioTable(this);
  late final $EntrenamientosEnCursoTable entrenamientosEnCurso =
      $EntrenamientosEnCursoTable(this);
  late final $RegistrosEnCursoTable registrosEnCurso = $RegistrosEnCursoTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    usuarios,
    relacionesProfesorAlumno,
    registrosPeso,
    ejercicios,
    rutinas,
    rutinaEjercicios,
    rutinasAsignadas,
    entrenamientos,
    registrosEjercicio,
    entrenamientosEnCurso,
    registrosEnCurso,
  ];
}

typedef $$UsuariosTableCreateCompanionBuilder =
    UsuariosCompanion Function({
      required String id,
      required String nombre,
      Value<int?> edad,
      Value<double?> altura,
      Value<double?> pesoActual,
      Value<String?> objetivo,
      Value<String?> correo,
      required String rol,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> eliminado,
      Value<int> rowid,
    });
typedef $$UsuariosTableUpdateCompanionBuilder =
    UsuariosCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<int?> edad,
      Value<double?> altura,
      Value<double?> pesoActual,
      Value<String?> objetivo,
      Value<String?> correo,
      Value<String> rol,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> eliminado,
      Value<int> rowid,
    });

class $$UsuariosTableFilterComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get edad => $composableBuilder(
    column: $table.edad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altura => $composableBuilder(
    column: $table.altura,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pesoActual => $composableBuilder(
    column: $table.pesoActual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get objetivo => $composableBuilder(
    column: $table.objetivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correo => $composableBuilder(
    column: $table.correo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rol => $composableBuilder(
    column: $table.rol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get eliminado => $composableBuilder(
    column: $table.eliminado,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsuariosTableOrderingComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get edad => $composableBuilder(
    column: $table.edad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altura => $composableBuilder(
    column: $table.altura,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pesoActual => $composableBuilder(
    column: $table.pesoActual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get objetivo => $composableBuilder(
    column: $table.objetivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correo => $composableBuilder(
    column: $table.correo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rol => $composableBuilder(
    column: $table.rol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get eliminado => $composableBuilder(
    column: $table.eliminado,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsuariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get edad =>
      $composableBuilder(column: $table.edad, builder: (column) => column);

  GeneratedColumn<double> get altura =>
      $composableBuilder(column: $table.altura, builder: (column) => column);

  GeneratedColumn<double> get pesoActual => $composableBuilder(
    column: $table.pesoActual,
    builder: (column) => column,
  );

  GeneratedColumn<String> get objetivo =>
      $composableBuilder(column: $table.objetivo, builder: (column) => column);

  GeneratedColumn<String> get correo =>
      $composableBuilder(column: $table.correo, builder: (column) => column);

  GeneratedColumn<String> get rol =>
      $composableBuilder(column: $table.rol, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get eliminado =>
      $composableBuilder(column: $table.eliminado, builder: (column) => column);
}

class $$UsuariosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsuariosTable,
          UsuarioDb,
          $$UsuariosTableFilterComposer,
          $$UsuariosTableOrderingComposer,
          $$UsuariosTableAnnotationComposer,
          $$UsuariosTableCreateCompanionBuilder,
          $$UsuariosTableUpdateCompanionBuilder,
          (UsuarioDb, BaseReferences<_$AppDatabase, $UsuariosTable, UsuarioDb>),
          UsuarioDb,
          PrefetchHooks Function()
        > {
  $$UsuariosTableTableManager(_$AppDatabase db, $UsuariosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsuariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsuariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsuariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<int?> edad = const Value.absent(),
                Value<double?> altura = const Value.absent(),
                Value<double?> pesoActual = const Value.absent(),
                Value<String?> objetivo = const Value.absent(),
                Value<String?> correo = const Value.absent(),
                Value<String> rol = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsuariosCompanion(
                id: id,
                nombre: nombre,
                edad: edad,
                altura: altura,
                pesoActual: pesoActual,
                objetivo: objetivo,
                correo: correo,
                rol: rol,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                eliminado: eliminado,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                Value<int?> edad = const Value.absent(),
                Value<double?> altura = const Value.absent(),
                Value<double?> pesoActual = const Value.absent(),
                Value<String?> objetivo = const Value.absent(),
                Value<String?> correo = const Value.absent(),
                required String rol,
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsuariosCompanion.insert(
                id: id,
                nombre: nombre,
                edad: edad,
                altura: altura,
                pesoActual: pesoActual,
                objetivo: objetivo,
                correo: correo,
                rol: rol,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                eliminado: eliminado,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsuariosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsuariosTable,
      UsuarioDb,
      $$UsuariosTableFilterComposer,
      $$UsuariosTableOrderingComposer,
      $$UsuariosTableAnnotationComposer,
      $$UsuariosTableCreateCompanionBuilder,
      $$UsuariosTableUpdateCompanionBuilder,
      (UsuarioDb, BaseReferences<_$AppDatabase, $UsuariosTable, UsuarioDb>),
      UsuarioDb,
      PrefetchHooks Function()
    >;
typedef $$RelacionesProfesorAlumnoTableCreateCompanionBuilder =
    RelacionesProfesorAlumnoCompanion Function({
      required String id,
      required String profesorId,
      required String alumnoId,
      Value<String> estado,
      Value<DateTime> creadoEn,
      Value<int> rowid,
    });
typedef $$RelacionesProfesorAlumnoTableUpdateCompanionBuilder =
    RelacionesProfesorAlumnoCompanion Function({
      Value<String> id,
      Value<String> profesorId,
      Value<String> alumnoId,
      Value<String> estado,
      Value<DateTime> creadoEn,
      Value<int> rowid,
    });

class $$RelacionesProfesorAlumnoTableFilterComposer
    extends Composer<_$AppDatabase, $RelacionesProfesorAlumnoTable> {
  $$RelacionesProfesorAlumnoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profesorId => $composableBuilder(
    column: $table.profesorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alumnoId => $composableBuilder(
    column: $table.alumnoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RelacionesProfesorAlumnoTableOrderingComposer
    extends Composer<_$AppDatabase, $RelacionesProfesorAlumnoTable> {
  $$RelacionesProfesorAlumnoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profesorId => $composableBuilder(
    column: $table.profesorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alumnoId => $composableBuilder(
    column: $table.alumnoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RelacionesProfesorAlumnoTableAnnotationComposer
    extends Composer<_$AppDatabase, $RelacionesProfesorAlumnoTable> {
  $$RelacionesProfesorAlumnoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profesorId => $composableBuilder(
    column: $table.profesorId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get alumnoId =>
      $composableBuilder(column: $table.alumnoId, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);
}

class $$RelacionesProfesorAlumnoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RelacionesProfesorAlumnoTable,
          RelacionProfesorAlumnoDb,
          $$RelacionesProfesorAlumnoTableFilterComposer,
          $$RelacionesProfesorAlumnoTableOrderingComposer,
          $$RelacionesProfesorAlumnoTableAnnotationComposer,
          $$RelacionesProfesorAlumnoTableCreateCompanionBuilder,
          $$RelacionesProfesorAlumnoTableUpdateCompanionBuilder,
          (
            RelacionProfesorAlumnoDb,
            BaseReferences<
              _$AppDatabase,
              $RelacionesProfesorAlumnoTable,
              RelacionProfesorAlumnoDb
            >,
          ),
          RelacionProfesorAlumnoDb,
          PrefetchHooks Function()
        > {
  $$RelacionesProfesorAlumnoTableTableManager(
    _$AppDatabase db,
    $RelacionesProfesorAlumnoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RelacionesProfesorAlumnoTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RelacionesProfesorAlumnoTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RelacionesProfesorAlumnoTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profesorId = const Value.absent(),
                Value<String> alumnoId = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RelacionesProfesorAlumnoCompanion(
                id: id,
                profesorId: profesorId,
                alumnoId: alumnoId,
                estado: estado,
                creadoEn: creadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profesorId,
                required String alumnoId,
                Value<String> estado = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RelacionesProfesorAlumnoCompanion.insert(
                id: id,
                profesorId: profesorId,
                alumnoId: alumnoId,
                estado: estado,
                creadoEn: creadoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RelacionesProfesorAlumnoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RelacionesProfesorAlumnoTable,
      RelacionProfesorAlumnoDb,
      $$RelacionesProfesorAlumnoTableFilterComposer,
      $$RelacionesProfesorAlumnoTableOrderingComposer,
      $$RelacionesProfesorAlumnoTableAnnotationComposer,
      $$RelacionesProfesorAlumnoTableCreateCompanionBuilder,
      $$RelacionesProfesorAlumnoTableUpdateCompanionBuilder,
      (
        RelacionProfesorAlumnoDb,
        BaseReferences<
          _$AppDatabase,
          $RelacionesProfesorAlumnoTable,
          RelacionProfesorAlumnoDb
        >,
      ),
      RelacionProfesorAlumnoDb,
      PrefetchHooks Function()
    >;
typedef $$RegistrosPesoTableCreateCompanionBuilder =
    RegistrosPesoCompanion Function({
      required String id,
      required String usuarioId,
      required double peso,
      required DateTime fecha,
      Value<DateTime> creadoEn,
      Value<int> rowid,
    });
typedef $$RegistrosPesoTableUpdateCompanionBuilder =
    RegistrosPesoCompanion Function({
      Value<String> id,
      Value<String> usuarioId,
      Value<double> peso,
      Value<DateTime> fecha,
      Value<DateTime> creadoEn,
      Value<int> rowid,
    });

class $$RegistrosPesoTableFilterComposer
    extends Composer<_$AppDatabase, $RegistrosPesoTable> {
  $$RegistrosPesoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get peso => $composableBuilder(
    column: $table.peso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RegistrosPesoTableOrderingComposer
    extends Composer<_$AppDatabase, $RegistrosPesoTable> {
  $$RegistrosPesoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get peso => $composableBuilder(
    column: $table.peso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RegistrosPesoTableAnnotationComposer
    extends Composer<_$AppDatabase, $RegistrosPesoTable> {
  $$RegistrosPesoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<double> get peso =>
      $composableBuilder(column: $table.peso, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);
}

class $$RegistrosPesoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RegistrosPesoTable,
          RegistroPesoDb,
          $$RegistrosPesoTableFilterComposer,
          $$RegistrosPesoTableOrderingComposer,
          $$RegistrosPesoTableAnnotationComposer,
          $$RegistrosPesoTableCreateCompanionBuilder,
          $$RegistrosPesoTableUpdateCompanionBuilder,
          (
            RegistroPesoDb,
            BaseReferences<_$AppDatabase, $RegistrosPesoTable, RegistroPesoDb>,
          ),
          RegistroPesoDb,
          PrefetchHooks Function()
        > {
  $$RegistrosPesoTableTableManager(_$AppDatabase db, $RegistrosPesoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegistrosPesoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegistrosPesoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegistrosPesoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<double> peso = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RegistrosPesoCompanion(
                id: id,
                usuarioId: usuarioId,
                peso: peso,
                fecha: fecha,
                creadoEn: creadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String usuarioId,
                required double peso,
                required DateTime fecha,
                Value<DateTime> creadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RegistrosPesoCompanion.insert(
                id: id,
                usuarioId: usuarioId,
                peso: peso,
                fecha: fecha,
                creadoEn: creadoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RegistrosPesoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RegistrosPesoTable,
      RegistroPesoDb,
      $$RegistrosPesoTableFilterComposer,
      $$RegistrosPesoTableOrderingComposer,
      $$RegistrosPesoTableAnnotationComposer,
      $$RegistrosPesoTableCreateCompanionBuilder,
      $$RegistrosPesoTableUpdateCompanionBuilder,
      (
        RegistroPesoDb,
        BaseReferences<_$AppDatabase, $RegistrosPesoTable, RegistroPesoDb>,
      ),
      RegistroPesoDb,
      PrefetchHooks Function()
    >;
typedef $$EjerciciosTableCreateCompanionBuilder =
    EjerciciosCompanion Function({
      required String id,
      required String creadorId,
      required String nombre,
      Value<String?> descripcion,
      Value<bool> llevaPeso,
      Value<String?> grupoMuscular,
      Value<String?> instrucciones,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> eliminado,
      Value<int> rowid,
    });
typedef $$EjerciciosTableUpdateCompanionBuilder =
    EjerciciosCompanion Function({
      Value<String> id,
      Value<String> creadorId,
      Value<String> nombre,
      Value<String?> descripcion,
      Value<bool> llevaPeso,
      Value<String?> grupoMuscular,
      Value<String?> instrucciones,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> eliminado,
      Value<int> rowid,
    });

class $$EjerciciosTableFilterComposer
    extends Composer<_$AppDatabase, $EjerciciosTable> {
  $$EjerciciosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creadorId => $composableBuilder(
    column: $table.creadorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get llevaPeso => $composableBuilder(
    column: $table.llevaPeso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grupoMuscular => $composableBuilder(
    column: $table.grupoMuscular,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instrucciones => $composableBuilder(
    column: $table.instrucciones,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get eliminado => $composableBuilder(
    column: $table.eliminado,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EjerciciosTableOrderingComposer
    extends Composer<_$AppDatabase, $EjerciciosTable> {
  $$EjerciciosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creadorId => $composableBuilder(
    column: $table.creadorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get llevaPeso => $composableBuilder(
    column: $table.llevaPeso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grupoMuscular => $composableBuilder(
    column: $table.grupoMuscular,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instrucciones => $composableBuilder(
    column: $table.instrucciones,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get eliminado => $composableBuilder(
    column: $table.eliminado,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EjerciciosTableAnnotationComposer
    extends Composer<_$AppDatabase, $EjerciciosTable> {
  $$EjerciciosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get creadorId =>
      $composableBuilder(column: $table.creadorId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get llevaPeso =>
      $composableBuilder(column: $table.llevaPeso, builder: (column) => column);

  GeneratedColumn<String> get grupoMuscular => $composableBuilder(
    column: $table.grupoMuscular,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instrucciones => $composableBuilder(
    column: $table.instrucciones,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get eliminado =>
      $composableBuilder(column: $table.eliminado, builder: (column) => column);
}

class $$EjerciciosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EjerciciosTable,
          EjercicioDb,
          $$EjerciciosTableFilterComposer,
          $$EjerciciosTableOrderingComposer,
          $$EjerciciosTableAnnotationComposer,
          $$EjerciciosTableCreateCompanionBuilder,
          $$EjerciciosTableUpdateCompanionBuilder,
          (
            EjercicioDb,
            BaseReferences<_$AppDatabase, $EjerciciosTable, EjercicioDb>,
          ),
          EjercicioDb,
          PrefetchHooks Function()
        > {
  $$EjerciciosTableTableManager(_$AppDatabase db, $EjerciciosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EjerciciosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EjerciciosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EjerciciosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> creadorId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<bool> llevaPeso = const Value.absent(),
                Value<String?> grupoMuscular = const Value.absent(),
                Value<String?> instrucciones = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EjerciciosCompanion(
                id: id,
                creadorId: creadorId,
                nombre: nombre,
                descripcion: descripcion,
                llevaPeso: llevaPeso,
                grupoMuscular: grupoMuscular,
                instrucciones: instrucciones,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                eliminado: eliminado,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String creadorId,
                required String nombre,
                Value<String?> descripcion = const Value.absent(),
                Value<bool> llevaPeso = const Value.absent(),
                Value<String?> grupoMuscular = const Value.absent(),
                Value<String?> instrucciones = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EjerciciosCompanion.insert(
                id: id,
                creadorId: creadorId,
                nombre: nombre,
                descripcion: descripcion,
                llevaPeso: llevaPeso,
                grupoMuscular: grupoMuscular,
                instrucciones: instrucciones,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                eliminado: eliminado,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EjerciciosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EjerciciosTable,
      EjercicioDb,
      $$EjerciciosTableFilterComposer,
      $$EjerciciosTableOrderingComposer,
      $$EjerciciosTableAnnotationComposer,
      $$EjerciciosTableCreateCompanionBuilder,
      $$EjerciciosTableUpdateCompanionBuilder,
      (
        EjercicioDb,
        BaseReferences<_$AppDatabase, $EjerciciosTable, EjercicioDb>,
      ),
      EjercicioDb,
      PrefetchHooks Function()
    >;
typedef $$RutinasTableCreateCompanionBuilder =
    RutinasCompanion Function({
      required String id,
      required String creadorId,
      required String nombre,
      Value<String?> descripcion,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> eliminado,
      Value<int> rowid,
    });
typedef $$RutinasTableUpdateCompanionBuilder =
    RutinasCompanion Function({
      Value<String> id,
      Value<String> creadorId,
      Value<String> nombre,
      Value<String?> descripcion,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> eliminado,
      Value<int> rowid,
    });

class $$RutinasTableFilterComposer
    extends Composer<_$AppDatabase, $RutinasTable> {
  $$RutinasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creadorId => $composableBuilder(
    column: $table.creadorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get eliminado => $composableBuilder(
    column: $table.eliminado,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RutinasTableOrderingComposer
    extends Composer<_$AppDatabase, $RutinasTable> {
  $$RutinasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creadorId => $composableBuilder(
    column: $table.creadorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get eliminado => $composableBuilder(
    column: $table.eliminado,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RutinasTableAnnotationComposer
    extends Composer<_$AppDatabase, $RutinasTable> {
  $$RutinasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get creadorId =>
      $composableBuilder(column: $table.creadorId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get eliminado =>
      $composableBuilder(column: $table.eliminado, builder: (column) => column);
}

class $$RutinasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RutinasTable,
          RutinaDb,
          $$RutinasTableFilterComposer,
          $$RutinasTableOrderingComposer,
          $$RutinasTableAnnotationComposer,
          $$RutinasTableCreateCompanionBuilder,
          $$RutinasTableUpdateCompanionBuilder,
          (RutinaDb, BaseReferences<_$AppDatabase, $RutinasTable, RutinaDb>),
          RutinaDb,
          PrefetchHooks Function()
        > {
  $$RutinasTableTableManager(_$AppDatabase db, $RutinasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RutinasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RutinasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RutinasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> creadorId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RutinasCompanion(
                id: id,
                creadorId: creadorId,
                nombre: nombre,
                descripcion: descripcion,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                eliminado: eliminado,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String creadorId,
                required String nombre,
                Value<String?> descripcion = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> eliminado = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RutinasCompanion.insert(
                id: id,
                creadorId: creadorId,
                nombre: nombre,
                descripcion: descripcion,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                eliminado: eliminado,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RutinasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RutinasTable,
      RutinaDb,
      $$RutinasTableFilterComposer,
      $$RutinasTableOrderingComposer,
      $$RutinasTableAnnotationComposer,
      $$RutinasTableCreateCompanionBuilder,
      $$RutinasTableUpdateCompanionBuilder,
      (RutinaDb, BaseReferences<_$AppDatabase, $RutinasTable, RutinaDb>),
      RutinaDb,
      PrefetchHooks Function()
    >;
typedef $$RutinaEjerciciosTableCreateCompanionBuilder =
    RutinaEjerciciosCompanion Function({
      required String id,
      required String rutinaId,
      required String ejercicioId,
      required int orden,
      required int series,
      required String repeticiones,
      Value<int> descansoSegundos,
      Value<String?> observaciones,
      Value<int> rowid,
    });
typedef $$RutinaEjerciciosTableUpdateCompanionBuilder =
    RutinaEjerciciosCompanion Function({
      Value<String> id,
      Value<String> rutinaId,
      Value<String> ejercicioId,
      Value<int> orden,
      Value<int> series,
      Value<String> repeticiones,
      Value<int> descansoSegundos,
      Value<String?> observaciones,
      Value<int> rowid,
    });

class $$RutinaEjerciciosTableFilterComposer
    extends Composer<_$AppDatabase, $RutinaEjerciciosTable> {
  $$RutinaEjerciciosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rutinaId => $composableBuilder(
    column: $table.rutinaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ejercicioId => $composableBuilder(
    column: $table.ejercicioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get series => $composableBuilder(
    column: $table.series,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeticiones => $composableBuilder(
    column: $table.repeticiones,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get descansoSegundos => $composableBuilder(
    column: $table.descansoSegundos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RutinaEjerciciosTableOrderingComposer
    extends Composer<_$AppDatabase, $RutinaEjerciciosTable> {
  $$RutinaEjerciciosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rutinaId => $composableBuilder(
    column: $table.rutinaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ejercicioId => $composableBuilder(
    column: $table.ejercicioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get series => $composableBuilder(
    column: $table.series,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeticiones => $composableBuilder(
    column: $table.repeticiones,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get descansoSegundos => $composableBuilder(
    column: $table.descansoSegundos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RutinaEjerciciosTableAnnotationComposer
    extends Composer<_$AppDatabase, $RutinaEjerciciosTable> {
  $$RutinaEjerciciosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rutinaId =>
      $composableBuilder(column: $table.rutinaId, builder: (column) => column);

  GeneratedColumn<String> get ejercicioId => $composableBuilder(
    column: $table.ejercicioId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orden =>
      $composableBuilder(column: $table.orden, builder: (column) => column);

  GeneratedColumn<int> get series =>
      $composableBuilder(column: $table.series, builder: (column) => column);

  GeneratedColumn<String> get repeticiones => $composableBuilder(
    column: $table.repeticiones,
    builder: (column) => column,
  );

  GeneratedColumn<int> get descansoSegundos => $composableBuilder(
    column: $table.descansoSegundos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );
}

class $$RutinaEjerciciosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RutinaEjerciciosTable,
          RutinaEjercicioDb,
          $$RutinaEjerciciosTableFilterComposer,
          $$RutinaEjerciciosTableOrderingComposer,
          $$RutinaEjerciciosTableAnnotationComposer,
          $$RutinaEjerciciosTableCreateCompanionBuilder,
          $$RutinaEjerciciosTableUpdateCompanionBuilder,
          (
            RutinaEjercicioDb,
            BaseReferences<
              _$AppDatabase,
              $RutinaEjerciciosTable,
              RutinaEjercicioDb
            >,
          ),
          RutinaEjercicioDb,
          PrefetchHooks Function()
        > {
  $$RutinaEjerciciosTableTableManager(
    _$AppDatabase db,
    $RutinaEjerciciosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RutinaEjerciciosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RutinaEjerciciosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RutinaEjerciciosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rutinaId = const Value.absent(),
                Value<String> ejercicioId = const Value.absent(),
                Value<int> orden = const Value.absent(),
                Value<int> series = const Value.absent(),
                Value<String> repeticiones = const Value.absent(),
                Value<int> descansoSegundos = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RutinaEjerciciosCompanion(
                id: id,
                rutinaId: rutinaId,
                ejercicioId: ejercicioId,
                orden: orden,
                series: series,
                repeticiones: repeticiones,
                descansoSegundos: descansoSegundos,
                observaciones: observaciones,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String rutinaId,
                required String ejercicioId,
                required int orden,
                required int series,
                required String repeticiones,
                Value<int> descansoSegundos = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RutinaEjerciciosCompanion.insert(
                id: id,
                rutinaId: rutinaId,
                ejercicioId: ejercicioId,
                orden: orden,
                series: series,
                repeticiones: repeticiones,
                descansoSegundos: descansoSegundos,
                observaciones: observaciones,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RutinaEjerciciosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RutinaEjerciciosTable,
      RutinaEjercicioDb,
      $$RutinaEjerciciosTableFilterComposer,
      $$RutinaEjerciciosTableOrderingComposer,
      $$RutinaEjerciciosTableAnnotationComposer,
      $$RutinaEjerciciosTableCreateCompanionBuilder,
      $$RutinaEjerciciosTableUpdateCompanionBuilder,
      (
        RutinaEjercicioDb,
        BaseReferences<
          _$AppDatabase,
          $RutinaEjerciciosTable,
          RutinaEjercicioDb
        >,
      ),
      RutinaEjercicioDb,
      PrefetchHooks Function()
    >;
typedef $$RutinasAsignadasTableCreateCompanionBuilder =
    RutinasAsignadasCompanion Function({
      required String id,
      required String rutinaId,
      required String profesorId,
      required String alumnoId,
      required int dia,
      Value<bool> activa,
      required DateTime fechaAsignacion,
      Value<DateTime> creadoEn,
      Value<int> rowid,
    });
typedef $$RutinasAsignadasTableUpdateCompanionBuilder =
    RutinasAsignadasCompanion Function({
      Value<String> id,
      Value<String> rutinaId,
      Value<String> profesorId,
      Value<String> alumnoId,
      Value<int> dia,
      Value<bool> activa,
      Value<DateTime> fechaAsignacion,
      Value<DateTime> creadoEn,
      Value<int> rowid,
    });

class $$RutinasAsignadasTableFilterComposer
    extends Composer<_$AppDatabase, $RutinasAsignadasTable> {
  $$RutinasAsignadasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rutinaId => $composableBuilder(
    column: $table.rutinaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profesorId => $composableBuilder(
    column: $table.profesorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alumnoId => $composableBuilder(
    column: $table.alumnoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dia => $composableBuilder(
    column: $table.dia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activa => $composableBuilder(
    column: $table.activa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaAsignacion => $composableBuilder(
    column: $table.fechaAsignacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RutinasAsignadasTableOrderingComposer
    extends Composer<_$AppDatabase, $RutinasAsignadasTable> {
  $$RutinasAsignadasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rutinaId => $composableBuilder(
    column: $table.rutinaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profesorId => $composableBuilder(
    column: $table.profesorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alumnoId => $composableBuilder(
    column: $table.alumnoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dia => $composableBuilder(
    column: $table.dia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activa => $composableBuilder(
    column: $table.activa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaAsignacion => $composableBuilder(
    column: $table.fechaAsignacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RutinasAsignadasTableAnnotationComposer
    extends Composer<_$AppDatabase, $RutinasAsignadasTable> {
  $$RutinasAsignadasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rutinaId =>
      $composableBuilder(column: $table.rutinaId, builder: (column) => column);

  GeneratedColumn<String> get profesorId => $composableBuilder(
    column: $table.profesorId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get alumnoId =>
      $composableBuilder(column: $table.alumnoId, builder: (column) => column);

  GeneratedColumn<int> get dia =>
      $composableBuilder(column: $table.dia, builder: (column) => column);

  GeneratedColumn<bool> get activa =>
      $composableBuilder(column: $table.activa, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaAsignacion => $composableBuilder(
    column: $table.fechaAsignacion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);
}

class $$RutinasAsignadasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RutinasAsignadasTable,
          RutinaAsignadaDb,
          $$RutinasAsignadasTableFilterComposer,
          $$RutinasAsignadasTableOrderingComposer,
          $$RutinasAsignadasTableAnnotationComposer,
          $$RutinasAsignadasTableCreateCompanionBuilder,
          $$RutinasAsignadasTableUpdateCompanionBuilder,
          (
            RutinaAsignadaDb,
            BaseReferences<
              _$AppDatabase,
              $RutinasAsignadasTable,
              RutinaAsignadaDb
            >,
          ),
          RutinaAsignadaDb,
          PrefetchHooks Function()
        > {
  $$RutinasAsignadasTableTableManager(
    _$AppDatabase db,
    $RutinasAsignadasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RutinasAsignadasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RutinasAsignadasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RutinasAsignadasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rutinaId = const Value.absent(),
                Value<String> profesorId = const Value.absent(),
                Value<String> alumnoId = const Value.absent(),
                Value<int> dia = const Value.absent(),
                Value<bool> activa = const Value.absent(),
                Value<DateTime> fechaAsignacion = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RutinasAsignadasCompanion(
                id: id,
                rutinaId: rutinaId,
                profesorId: profesorId,
                alumnoId: alumnoId,
                dia: dia,
                activa: activa,
                fechaAsignacion: fechaAsignacion,
                creadoEn: creadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String rutinaId,
                required String profesorId,
                required String alumnoId,
                required int dia,
                Value<bool> activa = const Value.absent(),
                required DateTime fechaAsignacion,
                Value<DateTime> creadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RutinasAsignadasCompanion.insert(
                id: id,
                rutinaId: rutinaId,
                profesorId: profesorId,
                alumnoId: alumnoId,
                dia: dia,
                activa: activa,
                fechaAsignacion: fechaAsignacion,
                creadoEn: creadoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RutinasAsignadasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RutinasAsignadasTable,
      RutinaAsignadaDb,
      $$RutinasAsignadasTableFilterComposer,
      $$RutinasAsignadasTableOrderingComposer,
      $$RutinasAsignadasTableAnnotationComposer,
      $$RutinasAsignadasTableCreateCompanionBuilder,
      $$RutinasAsignadasTableUpdateCompanionBuilder,
      (
        RutinaAsignadaDb,
        BaseReferences<_$AppDatabase, $RutinasAsignadasTable, RutinaAsignadaDb>,
      ),
      RutinaAsignadaDb,
      PrefetchHooks Function()
    >;
typedef $$EntrenamientosTableCreateCompanionBuilder =
    EntrenamientosCompanion Function({
      required String id,
      required String alumnoId,
      required String rutinaId,
      Value<String?> rutinaAsignadaId,
      required DateTime fechaInicio,
      Value<DateTime?> fechaFinalizacion,
      Value<bool> completado,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<int> rowid,
    });
typedef $$EntrenamientosTableUpdateCompanionBuilder =
    EntrenamientosCompanion Function({
      Value<String> id,
      Value<String> alumnoId,
      Value<String> rutinaId,
      Value<String?> rutinaAsignadaId,
      Value<DateTime> fechaInicio,
      Value<DateTime?> fechaFinalizacion,
      Value<bool> completado,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<int> rowid,
    });

class $$EntrenamientosTableFilterComposer
    extends Composer<_$AppDatabase, $EntrenamientosTable> {
  $$EntrenamientosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alumnoId => $composableBuilder(
    column: $table.alumnoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rutinaId => $composableBuilder(
    column: $table.rutinaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rutinaAsignadaId => $composableBuilder(
    column: $table.rutinaAsignadaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaFinalizacion => $composableBuilder(
    column: $table.fechaFinalizacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completado => $composableBuilder(
    column: $table.completado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EntrenamientosTableOrderingComposer
    extends Composer<_$AppDatabase, $EntrenamientosTable> {
  $$EntrenamientosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alumnoId => $composableBuilder(
    column: $table.alumnoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rutinaId => $composableBuilder(
    column: $table.rutinaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rutinaAsignadaId => $composableBuilder(
    column: $table.rutinaAsignadaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaFinalizacion => $composableBuilder(
    column: $table.fechaFinalizacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completado => $composableBuilder(
    column: $table.completado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntrenamientosTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntrenamientosTable> {
  $$EntrenamientosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get alumnoId =>
      $composableBuilder(column: $table.alumnoId, builder: (column) => column);

  GeneratedColumn<String> get rutinaId =>
      $composableBuilder(column: $table.rutinaId, builder: (column) => column);

  GeneratedColumn<String> get rutinaAsignadaId => $composableBuilder(
    column: $table.rutinaAsignadaId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaFinalizacion => $composableBuilder(
    column: $table.fechaFinalizacion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completado => $composableBuilder(
    column: $table.completado,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );
}

class $$EntrenamientosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntrenamientosTable,
          EntrenamientoDb,
          $$EntrenamientosTableFilterComposer,
          $$EntrenamientosTableOrderingComposer,
          $$EntrenamientosTableAnnotationComposer,
          $$EntrenamientosTableCreateCompanionBuilder,
          $$EntrenamientosTableUpdateCompanionBuilder,
          (
            EntrenamientoDb,
            BaseReferences<
              _$AppDatabase,
              $EntrenamientosTable,
              EntrenamientoDb
            >,
          ),
          EntrenamientoDb,
          PrefetchHooks Function()
        > {
  $$EntrenamientosTableTableManager(
    _$AppDatabase db,
    $EntrenamientosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntrenamientosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntrenamientosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntrenamientosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> alumnoId = const Value.absent(),
                Value<String> rutinaId = const Value.absent(),
                Value<String?> rutinaAsignadaId = const Value.absent(),
                Value<DateTime> fechaInicio = const Value.absent(),
                Value<DateTime?> fechaFinalizacion = const Value.absent(),
                Value<bool> completado = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntrenamientosCompanion(
                id: id,
                alumnoId: alumnoId,
                rutinaId: rutinaId,
                rutinaAsignadaId: rutinaAsignadaId,
                fechaInicio: fechaInicio,
                fechaFinalizacion: fechaFinalizacion,
                completado: completado,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String alumnoId,
                required String rutinaId,
                Value<String?> rutinaAsignadaId = const Value.absent(),
                required DateTime fechaInicio,
                Value<DateTime?> fechaFinalizacion = const Value.absent(),
                Value<bool> completado = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntrenamientosCompanion.insert(
                id: id,
                alumnoId: alumnoId,
                rutinaId: rutinaId,
                rutinaAsignadaId: rutinaAsignadaId,
                fechaInicio: fechaInicio,
                fechaFinalizacion: fechaFinalizacion,
                completado: completado,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EntrenamientosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntrenamientosTable,
      EntrenamientoDb,
      $$EntrenamientosTableFilterComposer,
      $$EntrenamientosTableOrderingComposer,
      $$EntrenamientosTableAnnotationComposer,
      $$EntrenamientosTableCreateCompanionBuilder,
      $$EntrenamientosTableUpdateCompanionBuilder,
      (
        EntrenamientoDb,
        BaseReferences<_$AppDatabase, $EntrenamientosTable, EntrenamientoDb>,
      ),
      EntrenamientoDb,
      PrefetchHooks Function()
    >;
typedef $$RegistrosEjercicioTableCreateCompanionBuilder =
    RegistrosEjercicioCompanion Function({
      required String id,
      required String entrenamientoId,
      required String ejercicioId,
      required String nombreEjercicio,
      required int series,
      required String repeticiones,
      required bool llevaPeso,
      Value<double?> pesoUsado,
      Value<String?> nota,
      Value<bool> completado,
      required int orden,
      Value<int> rowid,
    });
typedef $$RegistrosEjercicioTableUpdateCompanionBuilder =
    RegistrosEjercicioCompanion Function({
      Value<String> id,
      Value<String> entrenamientoId,
      Value<String> ejercicioId,
      Value<String> nombreEjercicio,
      Value<int> series,
      Value<String> repeticiones,
      Value<bool> llevaPeso,
      Value<double?> pesoUsado,
      Value<String?> nota,
      Value<bool> completado,
      Value<int> orden,
      Value<int> rowid,
    });

class $$RegistrosEjercicioTableFilterComposer
    extends Composer<_$AppDatabase, $RegistrosEjercicioTable> {
  $$RegistrosEjercicioTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entrenamientoId => $composableBuilder(
    column: $table.entrenamientoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ejercicioId => $composableBuilder(
    column: $table.ejercicioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreEjercicio => $composableBuilder(
    column: $table.nombreEjercicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get series => $composableBuilder(
    column: $table.series,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeticiones => $composableBuilder(
    column: $table.repeticiones,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get llevaPeso => $composableBuilder(
    column: $table.llevaPeso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pesoUsado => $composableBuilder(
    column: $table.pesoUsado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completado => $composableBuilder(
    column: $table.completado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RegistrosEjercicioTableOrderingComposer
    extends Composer<_$AppDatabase, $RegistrosEjercicioTable> {
  $$RegistrosEjercicioTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entrenamientoId => $composableBuilder(
    column: $table.entrenamientoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ejercicioId => $composableBuilder(
    column: $table.ejercicioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreEjercicio => $composableBuilder(
    column: $table.nombreEjercicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get series => $composableBuilder(
    column: $table.series,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeticiones => $composableBuilder(
    column: $table.repeticiones,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get llevaPeso => $composableBuilder(
    column: $table.llevaPeso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pesoUsado => $composableBuilder(
    column: $table.pesoUsado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completado => $composableBuilder(
    column: $table.completado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RegistrosEjercicioTableAnnotationComposer
    extends Composer<_$AppDatabase, $RegistrosEjercicioTable> {
  $$RegistrosEjercicioTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entrenamientoId => $composableBuilder(
    column: $table.entrenamientoId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ejercicioId => $composableBuilder(
    column: $table.ejercicioId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombreEjercicio => $composableBuilder(
    column: $table.nombreEjercicio,
    builder: (column) => column,
  );

  GeneratedColumn<int> get series =>
      $composableBuilder(column: $table.series, builder: (column) => column);

  GeneratedColumn<String> get repeticiones => $composableBuilder(
    column: $table.repeticiones,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get llevaPeso =>
      $composableBuilder(column: $table.llevaPeso, builder: (column) => column);

  GeneratedColumn<double> get pesoUsado =>
      $composableBuilder(column: $table.pesoUsado, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  GeneratedColumn<bool> get completado => $composableBuilder(
    column: $table.completado,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orden =>
      $composableBuilder(column: $table.orden, builder: (column) => column);
}

class $$RegistrosEjercicioTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RegistrosEjercicioTable,
          RegistroEjercicioDb,
          $$RegistrosEjercicioTableFilterComposer,
          $$RegistrosEjercicioTableOrderingComposer,
          $$RegistrosEjercicioTableAnnotationComposer,
          $$RegistrosEjercicioTableCreateCompanionBuilder,
          $$RegistrosEjercicioTableUpdateCompanionBuilder,
          (
            RegistroEjercicioDb,
            BaseReferences<
              _$AppDatabase,
              $RegistrosEjercicioTable,
              RegistroEjercicioDb
            >,
          ),
          RegistroEjercicioDb,
          PrefetchHooks Function()
        > {
  $$RegistrosEjercicioTableTableManager(
    _$AppDatabase db,
    $RegistrosEjercicioTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegistrosEjercicioTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegistrosEjercicioTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegistrosEjercicioTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entrenamientoId = const Value.absent(),
                Value<String> ejercicioId = const Value.absent(),
                Value<String> nombreEjercicio = const Value.absent(),
                Value<int> series = const Value.absent(),
                Value<String> repeticiones = const Value.absent(),
                Value<bool> llevaPeso = const Value.absent(),
                Value<double?> pesoUsado = const Value.absent(),
                Value<String?> nota = const Value.absent(),
                Value<bool> completado = const Value.absent(),
                Value<int> orden = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RegistrosEjercicioCompanion(
                id: id,
                entrenamientoId: entrenamientoId,
                ejercicioId: ejercicioId,
                nombreEjercicio: nombreEjercicio,
                series: series,
                repeticiones: repeticiones,
                llevaPeso: llevaPeso,
                pesoUsado: pesoUsado,
                nota: nota,
                completado: completado,
                orden: orden,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entrenamientoId,
                required String ejercicioId,
                required String nombreEjercicio,
                required int series,
                required String repeticiones,
                required bool llevaPeso,
                Value<double?> pesoUsado = const Value.absent(),
                Value<String?> nota = const Value.absent(),
                Value<bool> completado = const Value.absent(),
                required int orden,
                Value<int> rowid = const Value.absent(),
              }) => RegistrosEjercicioCompanion.insert(
                id: id,
                entrenamientoId: entrenamientoId,
                ejercicioId: ejercicioId,
                nombreEjercicio: nombreEjercicio,
                series: series,
                repeticiones: repeticiones,
                llevaPeso: llevaPeso,
                pesoUsado: pesoUsado,
                nota: nota,
                completado: completado,
                orden: orden,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RegistrosEjercicioTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RegistrosEjercicioTable,
      RegistroEjercicioDb,
      $$RegistrosEjercicioTableFilterComposer,
      $$RegistrosEjercicioTableOrderingComposer,
      $$RegistrosEjercicioTableAnnotationComposer,
      $$RegistrosEjercicioTableCreateCompanionBuilder,
      $$RegistrosEjercicioTableUpdateCompanionBuilder,
      (
        RegistroEjercicioDb,
        BaseReferences<
          _$AppDatabase,
          $RegistrosEjercicioTable,
          RegistroEjercicioDb
        >,
      ),
      RegistroEjercicioDb,
      PrefetchHooks Function()
    >;
typedef $$EntrenamientosEnCursoTableCreateCompanionBuilder =
    EntrenamientosEnCursoCompanion Function({
      required String id,
      required String alumnoId,
      required String rutinaId,
      required DateTime fechaInicio,
      Value<DateTime> actualizadoEn,
      Value<int> rowid,
    });
typedef $$EntrenamientosEnCursoTableUpdateCompanionBuilder =
    EntrenamientosEnCursoCompanion Function({
      Value<String> id,
      Value<String> alumnoId,
      Value<String> rutinaId,
      Value<DateTime> fechaInicio,
      Value<DateTime> actualizadoEn,
      Value<int> rowid,
    });

class $$EntrenamientosEnCursoTableFilterComposer
    extends Composer<_$AppDatabase, $EntrenamientosEnCursoTable> {
  $$EntrenamientosEnCursoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alumnoId => $composableBuilder(
    column: $table.alumnoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rutinaId => $composableBuilder(
    column: $table.rutinaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EntrenamientosEnCursoTableOrderingComposer
    extends Composer<_$AppDatabase, $EntrenamientosEnCursoTable> {
  $$EntrenamientosEnCursoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alumnoId => $composableBuilder(
    column: $table.alumnoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rutinaId => $composableBuilder(
    column: $table.rutinaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntrenamientosEnCursoTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntrenamientosEnCursoTable> {
  $$EntrenamientosEnCursoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get alumnoId =>
      $composableBuilder(column: $table.alumnoId, builder: (column) => column);

  GeneratedColumn<String> get rutinaId =>
      $composableBuilder(column: $table.rutinaId, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );
}

class $$EntrenamientosEnCursoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntrenamientosEnCursoTable,
          EntrenamientoEnCursoDb,
          $$EntrenamientosEnCursoTableFilterComposer,
          $$EntrenamientosEnCursoTableOrderingComposer,
          $$EntrenamientosEnCursoTableAnnotationComposer,
          $$EntrenamientosEnCursoTableCreateCompanionBuilder,
          $$EntrenamientosEnCursoTableUpdateCompanionBuilder,
          (
            EntrenamientoEnCursoDb,
            BaseReferences<
              _$AppDatabase,
              $EntrenamientosEnCursoTable,
              EntrenamientoEnCursoDb
            >,
          ),
          EntrenamientoEnCursoDb,
          PrefetchHooks Function()
        > {
  $$EntrenamientosEnCursoTableTableManager(
    _$AppDatabase db,
    $EntrenamientosEnCursoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntrenamientosEnCursoTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EntrenamientosEnCursoTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EntrenamientosEnCursoTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> alumnoId = const Value.absent(),
                Value<String> rutinaId = const Value.absent(),
                Value<DateTime> fechaInicio = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntrenamientosEnCursoCompanion(
                id: id,
                alumnoId: alumnoId,
                rutinaId: rutinaId,
                fechaInicio: fechaInicio,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String alumnoId,
                required String rutinaId,
                required DateTime fechaInicio,
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntrenamientosEnCursoCompanion.insert(
                id: id,
                alumnoId: alumnoId,
                rutinaId: rutinaId,
                fechaInicio: fechaInicio,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EntrenamientosEnCursoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntrenamientosEnCursoTable,
      EntrenamientoEnCursoDb,
      $$EntrenamientosEnCursoTableFilterComposer,
      $$EntrenamientosEnCursoTableOrderingComposer,
      $$EntrenamientosEnCursoTableAnnotationComposer,
      $$EntrenamientosEnCursoTableCreateCompanionBuilder,
      $$EntrenamientosEnCursoTableUpdateCompanionBuilder,
      (
        EntrenamientoEnCursoDb,
        BaseReferences<
          _$AppDatabase,
          $EntrenamientosEnCursoTable,
          EntrenamientoEnCursoDb
        >,
      ),
      EntrenamientoEnCursoDb,
      PrefetchHooks Function()
    >;
typedef $$RegistrosEnCursoTableCreateCompanionBuilder =
    RegistrosEnCursoCompanion Function({
      required String id,
      required String entrenamientoEnCursoId,
      required String ejercicioId,
      required int orden,
      Value<bool> completado,
      Value<String> pesoTexto,
      Value<String> nota,
      Value<int> rowid,
    });
typedef $$RegistrosEnCursoTableUpdateCompanionBuilder =
    RegistrosEnCursoCompanion Function({
      Value<String> id,
      Value<String> entrenamientoEnCursoId,
      Value<String> ejercicioId,
      Value<int> orden,
      Value<bool> completado,
      Value<String> pesoTexto,
      Value<String> nota,
      Value<int> rowid,
    });

class $$RegistrosEnCursoTableFilterComposer
    extends Composer<_$AppDatabase, $RegistrosEnCursoTable> {
  $$RegistrosEnCursoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entrenamientoEnCursoId => $composableBuilder(
    column: $table.entrenamientoEnCursoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ejercicioId => $composableBuilder(
    column: $table.ejercicioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completado => $composableBuilder(
    column: $table.completado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pesoTexto => $composableBuilder(
    column: $table.pesoTexto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RegistrosEnCursoTableOrderingComposer
    extends Composer<_$AppDatabase, $RegistrosEnCursoTable> {
  $$RegistrosEnCursoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entrenamientoEnCursoId => $composableBuilder(
    column: $table.entrenamientoEnCursoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ejercicioId => $composableBuilder(
    column: $table.ejercicioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completado => $composableBuilder(
    column: $table.completado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pesoTexto => $composableBuilder(
    column: $table.pesoTexto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RegistrosEnCursoTableAnnotationComposer
    extends Composer<_$AppDatabase, $RegistrosEnCursoTable> {
  $$RegistrosEnCursoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entrenamientoEnCursoId => $composableBuilder(
    column: $table.entrenamientoEnCursoId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ejercicioId => $composableBuilder(
    column: $table.ejercicioId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orden =>
      $composableBuilder(column: $table.orden, builder: (column) => column);

  GeneratedColumn<bool> get completado => $composableBuilder(
    column: $table.completado,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pesoTexto =>
      $composableBuilder(column: $table.pesoTexto, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);
}

class $$RegistrosEnCursoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RegistrosEnCursoTable,
          RegistroEnCursoDb,
          $$RegistrosEnCursoTableFilterComposer,
          $$RegistrosEnCursoTableOrderingComposer,
          $$RegistrosEnCursoTableAnnotationComposer,
          $$RegistrosEnCursoTableCreateCompanionBuilder,
          $$RegistrosEnCursoTableUpdateCompanionBuilder,
          (
            RegistroEnCursoDb,
            BaseReferences<
              _$AppDatabase,
              $RegistrosEnCursoTable,
              RegistroEnCursoDb
            >,
          ),
          RegistroEnCursoDb,
          PrefetchHooks Function()
        > {
  $$RegistrosEnCursoTableTableManager(
    _$AppDatabase db,
    $RegistrosEnCursoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegistrosEnCursoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegistrosEnCursoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegistrosEnCursoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entrenamientoEnCursoId = const Value.absent(),
                Value<String> ejercicioId = const Value.absent(),
                Value<int> orden = const Value.absent(),
                Value<bool> completado = const Value.absent(),
                Value<String> pesoTexto = const Value.absent(),
                Value<String> nota = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RegistrosEnCursoCompanion(
                id: id,
                entrenamientoEnCursoId: entrenamientoEnCursoId,
                ejercicioId: ejercicioId,
                orden: orden,
                completado: completado,
                pesoTexto: pesoTexto,
                nota: nota,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entrenamientoEnCursoId,
                required String ejercicioId,
                required int orden,
                Value<bool> completado = const Value.absent(),
                Value<String> pesoTexto = const Value.absent(),
                Value<String> nota = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RegistrosEnCursoCompanion.insert(
                id: id,
                entrenamientoEnCursoId: entrenamientoEnCursoId,
                ejercicioId: ejercicioId,
                orden: orden,
                completado: completado,
                pesoTexto: pesoTexto,
                nota: nota,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RegistrosEnCursoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RegistrosEnCursoTable,
      RegistroEnCursoDb,
      $$RegistrosEnCursoTableFilterComposer,
      $$RegistrosEnCursoTableOrderingComposer,
      $$RegistrosEnCursoTableAnnotationComposer,
      $$RegistrosEnCursoTableCreateCompanionBuilder,
      $$RegistrosEnCursoTableUpdateCompanionBuilder,
      (
        RegistroEnCursoDb,
        BaseReferences<
          _$AppDatabase,
          $RegistrosEnCursoTable,
          RegistroEnCursoDb
        >,
      ),
      RegistroEnCursoDb,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db, _db.usuarios);
  $$RelacionesProfesorAlumnoTableTableManager get relacionesProfesorAlumno =>
      $$RelacionesProfesorAlumnoTableTableManager(
        _db,
        _db.relacionesProfesorAlumno,
      );
  $$RegistrosPesoTableTableManager get registrosPeso =>
      $$RegistrosPesoTableTableManager(_db, _db.registrosPeso);
  $$EjerciciosTableTableManager get ejercicios =>
      $$EjerciciosTableTableManager(_db, _db.ejercicios);
  $$RutinasTableTableManager get rutinas =>
      $$RutinasTableTableManager(_db, _db.rutinas);
  $$RutinaEjerciciosTableTableManager get rutinaEjercicios =>
      $$RutinaEjerciciosTableTableManager(_db, _db.rutinaEjercicios);
  $$RutinasAsignadasTableTableManager get rutinasAsignadas =>
      $$RutinasAsignadasTableTableManager(_db, _db.rutinasAsignadas);
  $$EntrenamientosTableTableManager get entrenamientos =>
      $$EntrenamientosTableTableManager(_db, _db.entrenamientos);
  $$RegistrosEjercicioTableTableManager get registrosEjercicio =>
      $$RegistrosEjercicioTableTableManager(_db, _db.registrosEjercicio);
  $$EntrenamientosEnCursoTableTableManager get entrenamientosEnCurso =>
      $$EntrenamientosEnCursoTableTableManager(_db, _db.entrenamientosEnCurso);
  $$RegistrosEnCursoTableTableManager get registrosEnCurso =>
      $$RegistrosEnCursoTableTableManager(_db, _db.registrosEnCurso);
}
