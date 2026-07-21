// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DeudoresTable extends Deudores with TableInfo<$DeudoresTable, Deudore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeudoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id_deudor',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 45),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correoElectronicoMeta = const VerificationMeta(
    'correoElectronico',
  );
  @override
  late final GeneratedColumn<String> correoElectronico =
      GeneratedColumn<String>(
        'email',
        aliasedName,
        true,
        additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 1,
          maxTextLength: 60,
        ),
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
      );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 150,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroIdentificacionMeta =
      const VerificationMeta('numeroIdentificacion');
  @override
  late final GeneratedColumn<String> numeroIdentificacion =
      GeneratedColumn<String>(
        'numero_identificacion',
        aliasedName,
        false,
        additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 1,
          maxTextLength: 30,
        ),
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
      );
  static const VerificationMeta _edadMeta = const VerificationMeta('edad');
  @override
  late final GeneratedColumn<int> edad = GeneratedColumn<int>(
    'edad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EstadoCliente, String> estado =
      GeneratedColumn<String>(
        'estado',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EstadoCliente>($DeudoresTable.$converterestado);
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now(),
      );
  static const VerificationMeta _fechaActualizacionMeta =
      const VerificationMeta('fechaActualizacion');
  @override
  late final GeneratedColumn<DateTime> fechaActualizacion =
      GeneratedColumn<DateTime>(
        'fecha_actualizacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now(),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    telefono,
    correoElectronico,
    direccion,
    numeroIdentificacion,
    edad,
    estado,
    fechaCreacion,
    fechaActualizacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deudores';
  @override
  VerificationContext validateIntegrity(
    Insertable<Deudore> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_deudor')) {
      context.handle(
        _idMeta,
        id.isAcceptableOrUnknown(data['id_deudor']!, _idMeta),
      );
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    } else if (isInserting) {
      context.missing(_telefonoMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _correoElectronicoMeta,
        correoElectronico.isAcceptableOrUnknown(
          data['email']!,
          _correoElectronicoMeta,
        ),
      );
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    } else if (isInserting) {
      context.missing(_direccionMeta);
    }
    if (data.containsKey('numero_identificacion')) {
      context.handle(
        _numeroIdentificacionMeta,
        numeroIdentificacion.isAcceptableOrUnknown(
          data['numero_identificacion']!,
          _numeroIdentificacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numeroIdentificacionMeta);
    }
    if (data.containsKey('edad')) {
      context.handle(
        _edadMeta,
        edad.isAcceptableOrUnknown(data['edad']!, _edadMeta),
      );
    } else if (isInserting) {
      context.missing(_edadMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    }
    if (data.containsKey('fecha_actualizacion')) {
      context.handle(
        _fechaActualizacionMeta,
        fechaActualizacion.isAcceptableOrUnknown(
          data['fecha_actualizacion']!,
          _fechaActualizacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Deudore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Deudore(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_deudor'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      )!,
      correoElectronico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      )!,
      numeroIdentificacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_identificacion'],
      )!,
      edad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}edad'],
      )!,
      estado: $DeudoresTable.$converterestado.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}estado'],
        )!,
      ),
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      )!,
      fechaActualizacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_actualizacion'],
      )!,
    );
  }

  @override
  $DeudoresTable createAlias(String alias) {
    return $DeudoresTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EstadoCliente, String, String> $converterestado =
      const EnumNameConverter<EstadoCliente>(EstadoCliente.values);
}

class Deudore extends DataClass implements Insertable<Deudore> {
  final int id;
  final String nombre;
  final String telefono;
  final String? correoElectronico;
  final String direccion;
  final String numeroIdentificacion;
  final int edad;
  final EstadoCliente estado;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;
  const Deudore({
    required this.id,
    required this.nombre,
    required this.telefono,
    this.correoElectronico,
    required this.direccion,
    required this.numeroIdentificacion,
    required this.edad,
    required this.estado,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_deudor'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['telefono'] = Variable<String>(telefono);
    if (!nullToAbsent || correoElectronico != null) {
      map['email'] = Variable<String>(correoElectronico);
    }
    map['direccion'] = Variable<String>(direccion);
    map['numero_identificacion'] = Variable<String>(numeroIdentificacion);
    map['edad'] = Variable<int>(edad);
    {
      map['estado'] = Variable<String>(
        $DeudoresTable.$converterestado.toSql(estado),
      );
    }
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['fecha_actualizacion'] = Variable<DateTime>(fechaActualizacion);
    return map;
  }

  DeudoresCompanion toCompanion(bool nullToAbsent) {
    return DeudoresCompanion(
      id: Value(id),
      nombre: Value(nombre),
      telefono: Value(telefono),
      correoElectronico: correoElectronico == null && nullToAbsent
          ? const Value.absent()
          : Value(correoElectronico),
      direccion: Value(direccion),
      numeroIdentificacion: Value(numeroIdentificacion),
      edad: Value(edad),
      estado: Value(estado),
      fechaCreacion: Value(fechaCreacion),
      fechaActualizacion: Value(fechaActualizacion),
    );
  }

  factory Deudore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Deudore(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      telefono: serializer.fromJson<String>(json['telefono']),
      correoElectronico: serializer.fromJson<String?>(
        json['correoElectronico'],
      ),
      direccion: serializer.fromJson<String>(json['direccion']),
      numeroIdentificacion: serializer.fromJson<String>(
        json['numeroIdentificacion'],
      ),
      edad: serializer.fromJson<int>(json['edad']),
      estado: $DeudoresTable.$converterestado.fromJson(
        serializer.fromJson<String>(json['estado']),
      ),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
      fechaActualizacion: serializer.fromJson<DateTime>(
        json['fechaActualizacion'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'telefono': serializer.toJson<String>(telefono),
      'correoElectronico': serializer.toJson<String?>(correoElectronico),
      'direccion': serializer.toJson<String>(direccion),
      'numeroIdentificacion': serializer.toJson<String>(numeroIdentificacion),
      'edad': serializer.toJson<int>(edad),
      'estado': serializer.toJson<String>(
        $DeudoresTable.$converterestado.toJson(estado),
      ),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'fechaActualizacion': serializer.toJson<DateTime>(fechaActualizacion),
    };
  }

  Deudore copyWith({
    int? id,
    String? nombre,
    String? telefono,
    Value<String?> correoElectronico = const Value.absent(),
    String? direccion,
    String? numeroIdentificacion,
    int? edad,
    EstadoCliente? estado,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) => Deudore(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    telefono: telefono ?? this.telefono,
    correoElectronico: correoElectronico.present
        ? correoElectronico.value
        : this.correoElectronico,
    direccion: direccion ?? this.direccion,
    numeroIdentificacion: numeroIdentificacion ?? this.numeroIdentificacion,
    edad: edad ?? this.edad,
    estado: estado ?? this.estado,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
  );
  Deudore copyWithCompanion(DeudoresCompanion data) {
    return Deudore(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      correoElectronico: data.correoElectronico.present
          ? data.correoElectronico.value
          : this.correoElectronico,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      numeroIdentificacion: data.numeroIdentificacion.present
          ? data.numeroIdentificacion.value
          : this.numeroIdentificacion,
      edad: data.edad.present ? data.edad.value : this.edad,
      estado: data.estado.present ? data.estado.value : this.estado,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaActualizacion: data.fechaActualizacion.present
          ? data.fechaActualizacion.value
          : this.fechaActualizacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Deudore(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('correoElectronico: $correoElectronico, ')
          ..write('direccion: $direccion, ')
          ..write('numeroIdentificacion: $numeroIdentificacion, ')
          ..write('edad: $edad, ')
          ..write('estado: $estado, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    telefono,
    correoElectronico,
    direccion,
    numeroIdentificacion,
    edad,
    estado,
    fechaCreacion,
    fechaActualizacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Deudore &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.telefono == this.telefono &&
          other.correoElectronico == this.correoElectronico &&
          other.direccion == this.direccion &&
          other.numeroIdentificacion == this.numeroIdentificacion &&
          other.edad == this.edad &&
          other.estado == this.estado &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaActualizacion == this.fechaActualizacion);
}

class DeudoresCompanion extends UpdateCompanion<Deudore> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> telefono;
  final Value<String?> correoElectronico;
  final Value<String> direccion;
  final Value<String> numeroIdentificacion;
  final Value<int> edad;
  final Value<EstadoCliente> estado;
  final Value<DateTime> fechaCreacion;
  final Value<DateTime> fechaActualizacion;
  const DeudoresCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.telefono = const Value.absent(),
    this.correoElectronico = const Value.absent(),
    this.direccion = const Value.absent(),
    this.numeroIdentificacion = const Value.absent(),
    this.edad = const Value.absent(),
    this.estado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaActualizacion = const Value.absent(),
  });
  DeudoresCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String telefono,
    this.correoElectronico = const Value.absent(),
    required String direccion,
    required String numeroIdentificacion,
    required int edad,
    required EstadoCliente estado,
    this.fechaCreacion = const Value.absent(),
    this.fechaActualizacion = const Value.absent(),
  }) : nombre = Value(nombre),
       telefono = Value(telefono),
       direccion = Value(direccion),
       numeroIdentificacion = Value(numeroIdentificacion),
       edad = Value(edad),
       estado = Value(estado);
  static Insertable<Deudore> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? telefono,
    Expression<String>? correoElectronico,
    Expression<String>? direccion,
    Expression<String>? numeroIdentificacion,
    Expression<int>? edad,
    Expression<String>? estado,
    Expression<DateTime>? fechaCreacion,
    Expression<DateTime>? fechaActualizacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id_deudor': id,
      if (nombre != null) 'nombre': nombre,
      if (telefono != null) 'telefono': telefono,
      if (correoElectronico != null) 'email': correoElectronico,
      if (direccion != null) 'direccion': direccion,
      if (numeroIdentificacion != null)
        'numero_identificacion': numeroIdentificacion,
      if (edad != null) 'edad': edad,
      if (estado != null) 'estado': estado,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaActualizacion != null) 'fecha_actualizacion': fechaActualizacion,
    });
  }

  DeudoresCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? telefono,
    Value<String?>? correoElectronico,
    Value<String>? direccion,
    Value<String>? numeroIdentificacion,
    Value<int>? edad,
    Value<EstadoCliente>? estado,
    Value<DateTime>? fechaCreacion,
    Value<DateTime>? fechaActualizacion,
  }) {
    return DeudoresCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      correoElectronico: correoElectronico ?? this.correoElectronico,
      direccion: direccion ?? this.direccion,
      numeroIdentificacion: numeroIdentificacion ?? this.numeroIdentificacion,
      edad: edad ?? this.edad,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id_deudor'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (correoElectronico.present) {
      map['email'] = Variable<String>(correoElectronico.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (numeroIdentificacion.present) {
      map['numero_identificacion'] = Variable<String>(
        numeroIdentificacion.value,
      );
    }
    if (edad.present) {
      map['edad'] = Variable<int>(edad.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(
        $DeudoresTable.$converterestado.toSql(estado.value),
      );
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    if (fechaActualizacion.present) {
      map['fecha_actualizacion'] = Variable<DateTime>(fechaActualizacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeudoresCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('correoElectronico: $correoElectronico, ')
          ..write('direccion: $direccion, ')
          ..write('numeroIdentificacion: $numeroIdentificacion, ')
          ..write('edad: $edad, ')
          ..write('estado: $estado, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }
}

class $PrestamosTable extends Prestamos
    with TableInfo<$PrestamosTable, Prestamo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrestamosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id_prestamo',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idDeudorMeta = const VerificationMeta(
    'idDeudor',
  );
  @override
  late final GeneratedColumn<int> idDeudor = GeneratedColumn<int>(
    'id_deudor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES deudores(id_deudor)',
  );
  static const VerificationMeta _tasaInteresMeta = const VerificationMeta(
    'tasaInteres',
  );
  @override
  late final GeneratedColumn<double> tasaInteres = GeneratedColumn<double>(
    'tasa_interes',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tasaMoratoriaMeta = const VerificationMeta(
    'tasaMoratoria',
  );
  @override
  late final GeneratedColumn<double> tasaMoratoria = GeneratedColumn<double>(
    'tasa_interes_moratoria',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoMeta = const VerificationMeta('monto');
  @override
  late final GeneratedColumn<double> monto = GeneratedColumn<double>(
    'monto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plazoMesesMeta = const VerificationMeta(
    'plazoMeses',
  );
  @override
  late final GeneratedColumn<int> plazoMeses = GeneratedColumn<int>(
    'plazo_meses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoCuotaMeta = const VerificationMeta(
    'montoCuota',
  );
  @override
  late final GeneratedColumn<double> montoCuota = GeneratedColumn<double>(
    'monto_cuota',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now(),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idDeudor,
    tasaInteres,
    tasaMoratoria,
    monto,
    plazoMeses,
    montoCuota,
    fechaCreacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prestamos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Prestamo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_prestamo')) {
      context.handle(
        _idMeta,
        id.isAcceptableOrUnknown(data['id_prestamo']!, _idMeta),
      );
    }
    if (data.containsKey('id_deudor')) {
      context.handle(
        _idDeudorMeta,
        idDeudor.isAcceptableOrUnknown(data['id_deudor']!, _idDeudorMeta),
      );
    } else if (isInserting) {
      context.missing(_idDeudorMeta);
    }
    if (data.containsKey('tasa_interes')) {
      context.handle(
        _tasaInteresMeta,
        tasaInteres.isAcceptableOrUnknown(
          data['tasa_interes']!,
          _tasaInteresMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tasaInteresMeta);
    }
    if (data.containsKey('tasa_interes_moratoria')) {
      context.handle(
        _tasaMoratoriaMeta,
        tasaMoratoria.isAcceptableOrUnknown(
          data['tasa_interes_moratoria']!,
          _tasaMoratoriaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tasaMoratoriaMeta);
    }
    if (data.containsKey('monto')) {
      context.handle(
        _montoMeta,
        monto.isAcceptableOrUnknown(data['monto']!, _montoMeta),
      );
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('plazo_meses')) {
      context.handle(
        _plazoMesesMeta,
        plazoMeses.isAcceptableOrUnknown(data['plazo_meses']!, _plazoMesesMeta),
      );
    } else if (isInserting) {
      context.missing(_plazoMesesMeta);
    }
    if (data.containsKey('monto_cuota')) {
      context.handle(
        _montoCuotaMeta,
        montoCuota.isAcceptableOrUnknown(data['monto_cuota']!, _montoCuotaMeta),
      );
    } else if (isInserting) {
      context.missing(_montoCuotaMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Prestamo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Prestamo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_prestamo'],
      )!,
      idDeudor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_deudor'],
      )!,
      tasaInteres: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tasa_interes'],
      )!,
      tasaMoratoria: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tasa_interes_moratoria'],
      )!,
      monto: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto'],
      )!,
      plazoMeses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plazo_meses'],
      )!,
      montoCuota: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto_cuota'],
      )!,
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      )!,
    );
  }

  @override
  $PrestamosTable createAlias(String alias) {
    return $PrestamosTable(attachedDatabase, alias);
  }
}

class Prestamo extends DataClass implements Insertable<Prestamo> {
  final int id;
  final int idDeudor;
  final double tasaInteres;
  final double tasaMoratoria;
  final double monto;
  final int plazoMeses;
  final double montoCuota;
  final DateTime fechaCreacion;
  const Prestamo({
    required this.id,
    required this.idDeudor,
    required this.tasaInteres,
    required this.tasaMoratoria,
    required this.monto,
    required this.plazoMeses,
    required this.montoCuota,
    required this.fechaCreacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_prestamo'] = Variable<int>(id);
    map['id_deudor'] = Variable<int>(idDeudor);
    map['tasa_interes'] = Variable<double>(tasaInteres);
    map['tasa_interes_moratoria'] = Variable<double>(tasaMoratoria);
    map['monto'] = Variable<double>(monto);
    map['plazo_meses'] = Variable<int>(plazoMeses);
    map['monto_cuota'] = Variable<double>(montoCuota);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    return map;
  }

  PrestamosCompanion toCompanion(bool nullToAbsent) {
    return PrestamosCompanion(
      id: Value(id),
      idDeudor: Value(idDeudor),
      tasaInteres: Value(tasaInteres),
      tasaMoratoria: Value(tasaMoratoria),
      monto: Value(monto),
      plazoMeses: Value(plazoMeses),
      montoCuota: Value(montoCuota),
      fechaCreacion: Value(fechaCreacion),
    );
  }

  factory Prestamo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Prestamo(
      id: serializer.fromJson<int>(json['id']),
      idDeudor: serializer.fromJson<int>(json['idDeudor']),
      tasaInteres: serializer.fromJson<double>(json['tasaInteres']),
      tasaMoratoria: serializer.fromJson<double>(json['tasaMoratoria']),
      monto: serializer.fromJson<double>(json['monto']),
      plazoMeses: serializer.fromJson<int>(json['plazoMeses']),
      montoCuota: serializer.fromJson<double>(json['montoCuota']),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idDeudor': serializer.toJson<int>(idDeudor),
      'tasaInteres': serializer.toJson<double>(tasaInteres),
      'tasaMoratoria': serializer.toJson<double>(tasaMoratoria),
      'monto': serializer.toJson<double>(monto),
      'plazoMeses': serializer.toJson<int>(plazoMeses),
      'montoCuota': serializer.toJson<double>(montoCuota),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
    };
  }

  Prestamo copyWith({
    int? id,
    int? idDeudor,
    double? tasaInteres,
    double? tasaMoratoria,
    double? monto,
    int? plazoMeses,
    double? montoCuota,
    DateTime? fechaCreacion,
  }) => Prestamo(
    id: id ?? this.id,
    idDeudor: idDeudor ?? this.idDeudor,
    tasaInteres: tasaInteres ?? this.tasaInteres,
    tasaMoratoria: tasaMoratoria ?? this.tasaMoratoria,
    monto: monto ?? this.monto,
    plazoMeses: plazoMeses ?? this.plazoMeses,
    montoCuota: montoCuota ?? this.montoCuota,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
  );
  Prestamo copyWithCompanion(PrestamosCompanion data) {
    return Prestamo(
      id: data.id.present ? data.id.value : this.id,
      idDeudor: data.idDeudor.present ? data.idDeudor.value : this.idDeudor,
      tasaInteres: data.tasaInteres.present
          ? data.tasaInteres.value
          : this.tasaInteres,
      tasaMoratoria: data.tasaMoratoria.present
          ? data.tasaMoratoria.value
          : this.tasaMoratoria,
      monto: data.monto.present ? data.monto.value : this.monto,
      plazoMeses: data.plazoMeses.present
          ? data.plazoMeses.value
          : this.plazoMeses,
      montoCuota: data.montoCuota.present
          ? data.montoCuota.value
          : this.montoCuota,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Prestamo(')
          ..write('id: $id, ')
          ..write('idDeudor: $idDeudor, ')
          ..write('tasaInteres: $tasaInteres, ')
          ..write('tasaMoratoria: $tasaMoratoria, ')
          ..write('monto: $monto, ')
          ..write('plazoMeses: $plazoMeses, ')
          ..write('montoCuota: $montoCuota, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idDeudor,
    tasaInteres,
    tasaMoratoria,
    monto,
    plazoMeses,
    montoCuota,
    fechaCreacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Prestamo &&
          other.id == this.id &&
          other.idDeudor == this.idDeudor &&
          other.tasaInteres == this.tasaInteres &&
          other.tasaMoratoria == this.tasaMoratoria &&
          other.monto == this.monto &&
          other.plazoMeses == this.plazoMeses &&
          other.montoCuota == this.montoCuota &&
          other.fechaCreacion == this.fechaCreacion);
}

class PrestamosCompanion extends UpdateCompanion<Prestamo> {
  final Value<int> id;
  final Value<int> idDeudor;
  final Value<double> tasaInteres;
  final Value<double> tasaMoratoria;
  final Value<double> monto;
  final Value<int> plazoMeses;
  final Value<double> montoCuota;
  final Value<DateTime> fechaCreacion;
  const PrestamosCompanion({
    this.id = const Value.absent(),
    this.idDeudor = const Value.absent(),
    this.tasaInteres = const Value.absent(),
    this.tasaMoratoria = const Value.absent(),
    this.monto = const Value.absent(),
    this.plazoMeses = const Value.absent(),
    this.montoCuota = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
  });
  PrestamosCompanion.insert({
    this.id = const Value.absent(),
    required int idDeudor,
    required double tasaInteres,
    required double tasaMoratoria,
    required double monto,
    required int plazoMeses,
    required double montoCuota,
    this.fechaCreacion = const Value.absent(),
  }) : idDeudor = Value(idDeudor),
       tasaInteres = Value(tasaInteres),
       tasaMoratoria = Value(tasaMoratoria),
       monto = Value(monto),
       plazoMeses = Value(plazoMeses),
       montoCuota = Value(montoCuota);
  static Insertable<Prestamo> custom({
    Expression<int>? id,
    Expression<int>? idDeudor,
    Expression<double>? tasaInteres,
    Expression<double>? tasaMoratoria,
    Expression<double>? monto,
    Expression<int>? plazoMeses,
    Expression<double>? montoCuota,
    Expression<DateTime>? fechaCreacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id_prestamo': id,
      if (idDeudor != null) 'id_deudor': idDeudor,
      if (tasaInteres != null) 'tasa_interes': tasaInteres,
      if (tasaMoratoria != null) 'tasa_interes_moratoria': tasaMoratoria,
      if (monto != null) 'monto': monto,
      if (plazoMeses != null) 'plazo_meses': plazoMeses,
      if (montoCuota != null) 'monto_cuota': montoCuota,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
    });
  }

  PrestamosCompanion copyWith({
    Value<int>? id,
    Value<int>? idDeudor,
    Value<double>? tasaInteres,
    Value<double>? tasaMoratoria,
    Value<double>? monto,
    Value<int>? plazoMeses,
    Value<double>? montoCuota,
    Value<DateTime>? fechaCreacion,
  }) {
    return PrestamosCompanion(
      id: id ?? this.id,
      idDeudor: idDeudor ?? this.idDeudor,
      tasaInteres: tasaInteres ?? this.tasaInteres,
      tasaMoratoria: tasaMoratoria ?? this.tasaMoratoria,
      monto: monto ?? this.monto,
      plazoMeses: plazoMeses ?? this.plazoMeses,
      montoCuota: montoCuota ?? this.montoCuota,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id_prestamo'] = Variable<int>(id.value);
    }
    if (idDeudor.present) {
      map['id_deudor'] = Variable<int>(idDeudor.value);
    }
    if (tasaInteres.present) {
      map['tasa_interes'] = Variable<double>(tasaInteres.value);
    }
    if (tasaMoratoria.present) {
      map['tasa_interes_moratoria'] = Variable<double>(tasaMoratoria.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (plazoMeses.present) {
      map['plazo_meses'] = Variable<int>(plazoMeses.value);
    }
    if (montoCuota.present) {
      map['monto_cuota'] = Variable<double>(montoCuota.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrestamosCompanion(')
          ..write('id: $id, ')
          ..write('idDeudor: $idDeudor, ')
          ..write('tasaInteres: $tasaInteres, ')
          ..write('tasaMoratoria: $tasaMoratoria, ')
          ..write('monto: $monto, ')
          ..write('plazoMeses: $plazoMeses, ')
          ..write('montoCuota: $montoCuota, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }
}

class $ScoresTable extends Scores with TableInfo<$ScoresTable, Score> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idPrestamoMeta = const VerificationMeta(
    'idPrestamo',
  );
  @override
  late final GeneratedColumn<int> idPrestamo = GeneratedColumn<int>(
    'id_prestamo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL REFERENCES prestamos(id_prestamo)',
  );
  static const VerificationMeta _idDeudorMeta = const VerificationMeta(
    'idDeudor',
  );
  @override
  late final GeneratedColumn<int> idDeudor = GeneratedColumn<int>(
    'id_deudor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES deudores(id_deudor)',
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now(),
      );
  @override
  List<GeneratedColumn> get $columns => [
    idPrestamo,
    idDeudor,
    score,
    fechaCreacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scores';
  @override
  VerificationContext validateIntegrity(
    Insertable<Score> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_prestamo')) {
      context.handle(
        _idPrestamoMeta,
        idPrestamo.isAcceptableOrUnknown(data['id_prestamo']!, _idPrestamoMeta),
      );
    }
    if (data.containsKey('id_deudor')) {
      context.handle(
        _idDeudorMeta,
        idDeudor.isAcceptableOrUnknown(data['id_deudor']!, _idDeudorMeta),
      );
    } else if (isInserting) {
      context.missing(_idDeudorMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idPrestamo};
  @override
  Score map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Score(
      idPrestamo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_prestamo'],
      )!,
      idDeudor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_deudor'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      )!,
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      )!,
    );
  }

  @override
  $ScoresTable createAlias(String alias) {
    return $ScoresTable(attachedDatabase, alias);
  }
}

class Score extends DataClass implements Insertable<Score> {
  final int idPrestamo;
  final int idDeudor;
  final double score;
  final DateTime fechaCreacion;
  const Score({
    required this.idPrestamo,
    required this.idDeudor,
    required this.score,
    required this.fechaCreacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_prestamo'] = Variable<int>(idPrestamo);
    map['id_deudor'] = Variable<int>(idDeudor);
    map['score'] = Variable<double>(score);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    return map;
  }

  ScoresCompanion toCompanion(bool nullToAbsent) {
    return ScoresCompanion(
      idPrestamo: Value(idPrestamo),
      idDeudor: Value(idDeudor),
      score: Value(score),
      fechaCreacion: Value(fechaCreacion),
    );
  }

  factory Score.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Score(
      idPrestamo: serializer.fromJson<int>(json['idPrestamo']),
      idDeudor: serializer.fromJson<int>(json['idDeudor']),
      score: serializer.fromJson<double>(json['score']),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idPrestamo': serializer.toJson<int>(idPrestamo),
      'idDeudor': serializer.toJson<int>(idDeudor),
      'score': serializer.toJson<double>(score),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
    };
  }

  Score copyWith({
    int? idPrestamo,
    int? idDeudor,
    double? score,
    DateTime? fechaCreacion,
  }) => Score(
    idPrestamo: idPrestamo ?? this.idPrestamo,
    idDeudor: idDeudor ?? this.idDeudor,
    score: score ?? this.score,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
  );
  Score copyWithCompanion(ScoresCompanion data) {
    return Score(
      idPrestamo: data.idPrestamo.present
          ? data.idPrestamo.value
          : this.idPrestamo,
      idDeudor: data.idDeudor.present ? data.idDeudor.value : this.idDeudor,
      score: data.score.present ? data.score.value : this.score,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Score(')
          ..write('idPrestamo: $idPrestamo, ')
          ..write('idDeudor: $idDeudor, ')
          ..write('score: $score, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idPrestamo, idDeudor, score, fechaCreacion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Score &&
          other.idPrestamo == this.idPrestamo &&
          other.idDeudor == this.idDeudor &&
          other.score == this.score &&
          other.fechaCreacion == this.fechaCreacion);
}

class ScoresCompanion extends UpdateCompanion<Score> {
  final Value<int> idPrestamo;
  final Value<int> idDeudor;
  final Value<double> score;
  final Value<DateTime> fechaCreacion;
  const ScoresCompanion({
    this.idPrestamo = const Value.absent(),
    this.idDeudor = const Value.absent(),
    this.score = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
  });
  ScoresCompanion.insert({
    this.idPrestamo = const Value.absent(),
    required int idDeudor,
    required double score,
    this.fechaCreacion = const Value.absent(),
  }) : idDeudor = Value(idDeudor),
       score = Value(score);
  static Insertable<Score> custom({
    Expression<int>? idPrestamo,
    Expression<int>? idDeudor,
    Expression<double>? score,
    Expression<DateTime>? fechaCreacion,
  }) {
    return RawValuesInsertable({
      if (idPrestamo != null) 'id_prestamo': idPrestamo,
      if (idDeudor != null) 'id_deudor': idDeudor,
      if (score != null) 'score': score,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
    });
  }

  ScoresCompanion copyWith({
    Value<int>? idPrestamo,
    Value<int>? idDeudor,
    Value<double>? score,
    Value<DateTime>? fechaCreacion,
  }) {
    return ScoresCompanion(
      idPrestamo: idPrestamo ?? this.idPrestamo,
      idDeudor: idDeudor ?? this.idDeudor,
      score: score ?? this.score,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idPrestamo.present) {
      map['id_prestamo'] = Variable<int>(idPrestamo.value);
    }
    if (idDeudor.present) {
      map['id_deudor'] = Variable<int>(idDeudor.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScoresCompanion(')
          ..write('idPrestamo: $idPrestamo, ')
          ..write('idDeudor: $idDeudor, ')
          ..write('score: $score, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }
}

class $ConfiguracionPrestamosTable extends ConfiguracionPrestamos
    with TableInfo<$ConfiguracionPrestamosTable, ConfiguracionPrestamo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfiguracionPrestamosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id_configuracion',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idPrestamoMeta = const VerificationMeta(
    'idPrestamo',
  );
  @override
  late final GeneratedColumn<int> idPrestamo = GeneratedColumn<int>(
    'id_prestamo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES prestamos(id_prestamo)',
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoInteres, String> tipoInteres =
      GeneratedColumn<String>(
        'tipo_interes',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoInteres>(
        $ConfiguracionPrestamosTable.$convertertipoInteres,
      );
  @override
  late final GeneratedColumnWithTypeConverter<EstadoMoratorio, String>
  estadoMoratorio =
      GeneratedColumn<String>(
        'estado_moratorio',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EstadoMoratorio>(
        $ConfiguracionPrestamosTable.$converterestadoMoratorio,
      );
  @override
  late final GeneratedColumnWithTypeConverter<ManejoExcedente, String>
  manejoExcedente =
      GeneratedColumn<String>(
        'manejo_excedente',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ManejoExcedente>(
        $ConfiguracionPrestamosTable.$convertermanejoExcedente,
      );
  @override
  late final GeneratedColumnWithTypeConverter<PeriodicidadInteres, String>
  periodidadIntereses =
      GeneratedColumn<String>(
        'periodidad_intereses',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PeriodicidadInteres>(
        $ConfiguracionPrestamosTable.$converterperiodidadIntereses,
      );
  @override
  late final GeneratedColumnWithTypeConverter<EstadoPrestamo, String>
  estadoPrestamo =
      GeneratedColumn<String>(
        'estado_prestamo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EstadoPrestamo>(
        $ConfiguracionPrestamosTable.$converterestadoPrestamo,
      );
  static const VerificationMeta _motivoCancelacionMeta = const VerificationMeta(
    'motivoCancelacion',
  );
  @override
  late final GeneratedColumn<String> motivoCancelacion =
      GeneratedColumn<String>(
        'motivo_cancelacion',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _montoDevueltoMeta = const VerificationMeta(
    'montoDevuelto',
  );
  @override
  late final GeneratedColumn<double> montoDevuelto = GeneratedColumn<double>(
    'monto_devuelto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _motivoCastigoMeta = const VerificationMeta(
    'motivoCastigo',
  );
  @override
  late final GeneratedColumn<String> motivoCastigo = GeneratedColumn<String>(
    'motivo_castigo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _montoPerdidoMeta = const VerificationMeta(
    'montoPerdido',
  );
  @override
  late final GeneratedColumn<double> montoPerdido = GeneratedColumn<double>(
    'monto_perdido',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now(),
      );
  static const VerificationMeta _fechaActualizacionMeta =
      const VerificationMeta('fechaActualizacion');
  @override
  late final GeneratedColumn<DateTime> fechaActualizacion =
      GeneratedColumn<DateTime>(
        'fecha_actualizacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now(),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idPrestamo,
    tipoInteres,
    estadoMoratorio,
    manejoExcedente,
    periodidadIntereses,
    estadoPrestamo,
    motivoCancelacion,
    montoDevuelto,
    motivoCastigo,
    montoPerdido,
    fechaCreacion,
    fechaActualizacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'configuracion_prestamos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConfiguracionPrestamo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_configuracion')) {
      context.handle(
        _idMeta,
        id.isAcceptableOrUnknown(data['id_configuracion']!, _idMeta),
      );
    }
    if (data.containsKey('id_prestamo')) {
      context.handle(
        _idPrestamoMeta,
        idPrestamo.isAcceptableOrUnknown(data['id_prestamo']!, _idPrestamoMeta),
      );
    } else if (isInserting) {
      context.missing(_idPrestamoMeta);
    }
    if (data.containsKey('motivo_cancelacion')) {
      context.handle(
        _motivoCancelacionMeta,
        motivoCancelacion.isAcceptableOrUnknown(
          data['motivo_cancelacion']!,
          _motivoCancelacionMeta,
        ),
      );
    }
    if (data.containsKey('monto_devuelto')) {
      context.handle(
        _montoDevueltoMeta,
        montoDevuelto.isAcceptableOrUnknown(
          data['monto_devuelto']!,
          _montoDevueltoMeta,
        ),
      );
    }
    if (data.containsKey('motivo_castigo')) {
      context.handle(
        _motivoCastigoMeta,
        motivoCastigo.isAcceptableOrUnknown(
          data['motivo_castigo']!,
          _motivoCastigoMeta,
        ),
      );
    }
    if (data.containsKey('monto_perdido')) {
      context.handle(
        _montoPerdidoMeta,
        montoPerdido.isAcceptableOrUnknown(
          data['monto_perdido']!,
          _montoPerdidoMeta,
        ),
      );
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    }
    if (data.containsKey('fecha_actualizacion')) {
      context.handle(
        _fechaActualizacionMeta,
        fechaActualizacion.isAcceptableOrUnknown(
          data['fecha_actualizacion']!,
          _fechaActualizacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfiguracionPrestamo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfiguracionPrestamo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_configuracion'],
      )!,
      idPrestamo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_prestamo'],
      )!,
      tipoInteres: $ConfiguracionPrestamosTable.$convertertipoInteres.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo_interes'],
        )!,
      ),
      estadoMoratorio: $ConfiguracionPrestamosTable.$converterestadoMoratorio
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}estado_moratorio'],
            )!,
          ),
      manejoExcedente: $ConfiguracionPrestamosTable.$convertermanejoExcedente
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}manejo_excedente'],
            )!,
          ),
      periodidadIntereses: $ConfiguracionPrestamosTable
          .$converterperiodidadIntereses
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}periodidad_intereses'],
            )!,
          ),
      estadoPrestamo: $ConfiguracionPrestamosTable.$converterestadoPrestamo
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}estado_prestamo'],
            )!,
          ),
      motivoCancelacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motivo_cancelacion'],
      ),
      montoDevuelto: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto_devuelto'],
      )!,
      motivoCastigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motivo_castigo'],
      ),
      montoPerdido: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto_perdido'],
      )!,
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      )!,
      fechaActualizacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_actualizacion'],
      )!,
    );
  }

  @override
  $ConfiguracionPrestamosTable createAlias(String alias) {
    return $ConfiguracionPrestamosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoInteres, String, String> $convertertipoInteres =
      const EnumNameConverter<TipoInteres>(TipoInteres.values);
  static JsonTypeConverter2<EstadoMoratorio, String, String>
  $converterestadoMoratorio = const EnumNameConverter<EstadoMoratorio>(
    EstadoMoratorio.values,
  );
  static JsonTypeConverter2<ManejoExcedente, String, String>
  $convertermanejoExcedente = const EnumNameConverter<ManejoExcedente>(
    ManejoExcedente.values,
  );
  static JsonTypeConverter2<PeriodicidadInteres, String, String>
  $converterperiodidadIntereses = const EnumNameConverter<PeriodicidadInteres>(
    PeriodicidadInteres.values,
  );
  static JsonTypeConverter2<EstadoPrestamo, String, String>
  $converterestadoPrestamo = const EnumNameConverter<EstadoPrestamo>(
    EstadoPrestamo.values,
  );
}

class ConfiguracionPrestamo extends DataClass
    implements Insertable<ConfiguracionPrestamo> {
  final int id;
  final int idPrestamo;
  final TipoInteres tipoInteres;
  final EstadoMoratorio estadoMoratorio;
  final ManejoExcedente manejoExcedente;
  final PeriodicidadInteres periodidadIntereses;
  final EstadoPrestamo estadoPrestamo;
  final String? motivoCancelacion;
  final double montoDevuelto;
  final String? motivoCastigo;
  final double montoPerdido;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;
  const ConfiguracionPrestamo({
    required this.id,
    required this.idPrestamo,
    required this.tipoInteres,
    required this.estadoMoratorio,
    required this.manejoExcedente,
    required this.periodidadIntereses,
    required this.estadoPrestamo,
    this.motivoCancelacion,
    required this.montoDevuelto,
    this.motivoCastigo,
    required this.montoPerdido,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_configuracion'] = Variable<int>(id);
    map['id_prestamo'] = Variable<int>(idPrestamo);
    {
      map['tipo_interes'] = Variable<String>(
        $ConfiguracionPrestamosTable.$convertertipoInteres.toSql(tipoInteres),
      );
    }
    {
      map['estado_moratorio'] = Variable<String>(
        $ConfiguracionPrestamosTable.$converterestadoMoratorio.toSql(
          estadoMoratorio,
        ),
      );
    }
    {
      map['manejo_excedente'] = Variable<String>(
        $ConfiguracionPrestamosTable.$convertermanejoExcedente.toSql(
          manejoExcedente,
        ),
      );
    }
    {
      map['periodidad_intereses'] = Variable<String>(
        $ConfiguracionPrestamosTable.$converterperiodidadIntereses.toSql(
          periodidadIntereses,
        ),
      );
    }
    {
      map['estado_prestamo'] = Variable<String>(
        $ConfiguracionPrestamosTable.$converterestadoPrestamo.toSql(
          estadoPrestamo,
        ),
      );
    }
    if (!nullToAbsent || motivoCancelacion != null) {
      map['motivo_cancelacion'] = Variable<String>(motivoCancelacion);
    }
    map['monto_devuelto'] = Variable<double>(montoDevuelto);
    if (!nullToAbsent || motivoCastigo != null) {
      map['motivo_castigo'] = Variable<String>(motivoCastigo);
    }
    map['monto_perdido'] = Variable<double>(montoPerdido);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['fecha_actualizacion'] = Variable<DateTime>(fechaActualizacion);
    return map;
  }

  ConfiguracionPrestamosCompanion toCompanion(bool nullToAbsent) {
    return ConfiguracionPrestamosCompanion(
      id: Value(id),
      idPrestamo: Value(idPrestamo),
      tipoInteres: Value(tipoInteres),
      estadoMoratorio: Value(estadoMoratorio),
      manejoExcedente: Value(manejoExcedente),
      periodidadIntereses: Value(periodidadIntereses),
      estadoPrestamo: Value(estadoPrestamo),
      motivoCancelacion: motivoCancelacion == null && nullToAbsent
          ? const Value.absent()
          : Value(motivoCancelacion),
      montoDevuelto: Value(montoDevuelto),
      motivoCastigo: motivoCastigo == null && nullToAbsent
          ? const Value.absent()
          : Value(motivoCastigo),
      montoPerdido: Value(montoPerdido),
      fechaCreacion: Value(fechaCreacion),
      fechaActualizacion: Value(fechaActualizacion),
    );
  }

  factory ConfiguracionPrestamo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfiguracionPrestamo(
      id: serializer.fromJson<int>(json['id']),
      idPrestamo: serializer.fromJson<int>(json['idPrestamo']),
      tipoInteres: $ConfiguracionPrestamosTable.$convertertipoInteres.fromJson(
        serializer.fromJson<String>(json['tipoInteres']),
      ),
      estadoMoratorio: $ConfiguracionPrestamosTable.$converterestadoMoratorio
          .fromJson(serializer.fromJson<String>(json['estadoMoratorio'])),
      manejoExcedente: $ConfiguracionPrestamosTable.$convertermanejoExcedente
          .fromJson(serializer.fromJson<String>(json['manejoExcedente'])),
      periodidadIntereses: $ConfiguracionPrestamosTable
          .$converterperiodidadIntereses
          .fromJson(serializer.fromJson<String>(json['periodidadIntereses'])),
      estadoPrestamo: $ConfiguracionPrestamosTable.$converterestadoPrestamo
          .fromJson(serializer.fromJson<String>(json['estadoPrestamo'])),
      motivoCancelacion: serializer.fromJson<String?>(
        json['motivoCancelacion'],
      ),
      montoDevuelto: serializer.fromJson<double>(json['montoDevuelto']),
      motivoCastigo: serializer.fromJson<String?>(json['motivoCastigo']),
      montoPerdido: serializer.fromJson<double>(json['montoPerdido']),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
      fechaActualizacion: serializer.fromJson<DateTime>(
        json['fechaActualizacion'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idPrestamo': serializer.toJson<int>(idPrestamo),
      'tipoInteres': serializer.toJson<String>(
        $ConfiguracionPrestamosTable.$convertertipoInteres.toJson(tipoInteres),
      ),
      'estadoMoratorio': serializer.toJson<String>(
        $ConfiguracionPrestamosTable.$converterestadoMoratorio.toJson(
          estadoMoratorio,
        ),
      ),
      'manejoExcedente': serializer.toJson<String>(
        $ConfiguracionPrestamosTable.$convertermanejoExcedente.toJson(
          manejoExcedente,
        ),
      ),
      'periodidadIntereses': serializer.toJson<String>(
        $ConfiguracionPrestamosTable.$converterperiodidadIntereses.toJson(
          periodidadIntereses,
        ),
      ),
      'estadoPrestamo': serializer.toJson<String>(
        $ConfiguracionPrestamosTable.$converterestadoPrestamo.toJson(
          estadoPrestamo,
        ),
      ),
      'motivoCancelacion': serializer.toJson<String?>(motivoCancelacion),
      'montoDevuelto': serializer.toJson<double>(montoDevuelto),
      'motivoCastigo': serializer.toJson<String?>(motivoCastigo),
      'montoPerdido': serializer.toJson<double>(montoPerdido),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'fechaActualizacion': serializer.toJson<DateTime>(fechaActualizacion),
    };
  }

  ConfiguracionPrestamo copyWith({
    int? id,
    int? idPrestamo,
    TipoInteres? tipoInteres,
    EstadoMoratorio? estadoMoratorio,
    ManejoExcedente? manejoExcedente,
    PeriodicidadInteres? periodidadIntereses,
    EstadoPrestamo? estadoPrestamo,
    Value<String?> motivoCancelacion = const Value.absent(),
    double? montoDevuelto,
    Value<String?> motivoCastigo = const Value.absent(),
    double? montoPerdido,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) => ConfiguracionPrestamo(
    id: id ?? this.id,
    idPrestamo: idPrestamo ?? this.idPrestamo,
    tipoInteres: tipoInteres ?? this.tipoInteres,
    estadoMoratorio: estadoMoratorio ?? this.estadoMoratorio,
    manejoExcedente: manejoExcedente ?? this.manejoExcedente,
    periodidadIntereses: periodidadIntereses ?? this.periodidadIntereses,
    estadoPrestamo: estadoPrestamo ?? this.estadoPrestamo,
    motivoCancelacion: motivoCancelacion.present
        ? motivoCancelacion.value
        : this.motivoCancelacion,
    montoDevuelto: montoDevuelto ?? this.montoDevuelto,
    motivoCastigo: motivoCastigo.present
        ? motivoCastigo.value
        : this.motivoCastigo,
    montoPerdido: montoPerdido ?? this.montoPerdido,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
  );
  ConfiguracionPrestamo copyWithCompanion(
    ConfiguracionPrestamosCompanion data,
  ) {
    return ConfiguracionPrestamo(
      id: data.id.present ? data.id.value : this.id,
      idPrestamo: data.idPrestamo.present
          ? data.idPrestamo.value
          : this.idPrestamo,
      tipoInteres: data.tipoInteres.present
          ? data.tipoInteres.value
          : this.tipoInteres,
      estadoMoratorio: data.estadoMoratorio.present
          ? data.estadoMoratorio.value
          : this.estadoMoratorio,
      manejoExcedente: data.manejoExcedente.present
          ? data.manejoExcedente.value
          : this.manejoExcedente,
      periodidadIntereses: data.periodidadIntereses.present
          ? data.periodidadIntereses.value
          : this.periodidadIntereses,
      estadoPrestamo: data.estadoPrestamo.present
          ? data.estadoPrestamo.value
          : this.estadoPrestamo,
      motivoCancelacion: data.motivoCancelacion.present
          ? data.motivoCancelacion.value
          : this.motivoCancelacion,
      montoDevuelto: data.montoDevuelto.present
          ? data.montoDevuelto.value
          : this.montoDevuelto,
      motivoCastigo: data.motivoCastigo.present
          ? data.motivoCastigo.value
          : this.motivoCastigo,
      montoPerdido: data.montoPerdido.present
          ? data.montoPerdido.value
          : this.montoPerdido,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaActualizacion: data.fechaActualizacion.present
          ? data.fechaActualizacion.value
          : this.fechaActualizacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracionPrestamo(')
          ..write('id: $id, ')
          ..write('idPrestamo: $idPrestamo, ')
          ..write('tipoInteres: $tipoInteres, ')
          ..write('estadoMoratorio: $estadoMoratorio, ')
          ..write('manejoExcedente: $manejoExcedente, ')
          ..write('periodidadIntereses: $periodidadIntereses, ')
          ..write('estadoPrestamo: $estadoPrestamo, ')
          ..write('motivoCancelacion: $motivoCancelacion, ')
          ..write('montoDevuelto: $montoDevuelto, ')
          ..write('motivoCastigo: $motivoCastigo, ')
          ..write('montoPerdido: $montoPerdido, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idPrestamo,
    tipoInteres,
    estadoMoratorio,
    manejoExcedente,
    periodidadIntereses,
    estadoPrestamo,
    motivoCancelacion,
    montoDevuelto,
    motivoCastigo,
    montoPerdido,
    fechaCreacion,
    fechaActualizacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfiguracionPrestamo &&
          other.id == this.id &&
          other.idPrestamo == this.idPrestamo &&
          other.tipoInteres == this.tipoInteres &&
          other.estadoMoratorio == this.estadoMoratorio &&
          other.manejoExcedente == this.manejoExcedente &&
          other.periodidadIntereses == this.periodidadIntereses &&
          other.estadoPrestamo == this.estadoPrestamo &&
          other.motivoCancelacion == this.motivoCancelacion &&
          other.montoDevuelto == this.montoDevuelto &&
          other.motivoCastigo == this.motivoCastigo &&
          other.montoPerdido == this.montoPerdido &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaActualizacion == this.fechaActualizacion);
}

class ConfiguracionPrestamosCompanion
    extends UpdateCompanion<ConfiguracionPrestamo> {
  final Value<int> id;
  final Value<int> idPrestamo;
  final Value<TipoInteres> tipoInteres;
  final Value<EstadoMoratorio> estadoMoratorio;
  final Value<ManejoExcedente> manejoExcedente;
  final Value<PeriodicidadInteres> periodidadIntereses;
  final Value<EstadoPrestamo> estadoPrestamo;
  final Value<String?> motivoCancelacion;
  final Value<double> montoDevuelto;
  final Value<String?> motivoCastigo;
  final Value<double> montoPerdido;
  final Value<DateTime> fechaCreacion;
  final Value<DateTime> fechaActualizacion;
  const ConfiguracionPrestamosCompanion({
    this.id = const Value.absent(),
    this.idPrestamo = const Value.absent(),
    this.tipoInteres = const Value.absent(),
    this.estadoMoratorio = const Value.absent(),
    this.manejoExcedente = const Value.absent(),
    this.periodidadIntereses = const Value.absent(),
    this.estadoPrestamo = const Value.absent(),
    this.motivoCancelacion = const Value.absent(),
    this.montoDevuelto = const Value.absent(),
    this.motivoCastigo = const Value.absent(),
    this.montoPerdido = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaActualizacion = const Value.absent(),
  });
  ConfiguracionPrestamosCompanion.insert({
    this.id = const Value.absent(),
    required int idPrestamo,
    required TipoInteres tipoInteres,
    required EstadoMoratorio estadoMoratorio,
    required ManejoExcedente manejoExcedente,
    required PeriodicidadInteres periodidadIntereses,
    required EstadoPrestamo estadoPrestamo,
    this.motivoCancelacion = const Value.absent(),
    this.montoDevuelto = const Value.absent(),
    this.motivoCastigo = const Value.absent(),
    this.montoPerdido = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaActualizacion = const Value.absent(),
  }) : idPrestamo = Value(idPrestamo),
       tipoInteres = Value(tipoInteres),
       estadoMoratorio = Value(estadoMoratorio),
       manejoExcedente = Value(manejoExcedente),
       periodidadIntereses = Value(periodidadIntereses),
       estadoPrestamo = Value(estadoPrestamo);
  static Insertable<ConfiguracionPrestamo> custom({
    Expression<int>? id,
    Expression<int>? idPrestamo,
    Expression<String>? tipoInteres,
    Expression<String>? estadoMoratorio,
    Expression<String>? manejoExcedente,
    Expression<String>? periodidadIntereses,
    Expression<String>? estadoPrestamo,
    Expression<String>? motivoCancelacion,
    Expression<double>? montoDevuelto,
    Expression<String>? motivoCastigo,
    Expression<double>? montoPerdido,
    Expression<DateTime>? fechaCreacion,
    Expression<DateTime>? fechaActualizacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id_configuracion': id,
      if (idPrestamo != null) 'id_prestamo': idPrestamo,
      if (tipoInteres != null) 'tipo_interes': tipoInteres,
      if (estadoMoratorio != null) 'estado_moratorio': estadoMoratorio,
      if (manejoExcedente != null) 'manejo_excedente': manejoExcedente,
      if (periodidadIntereses != null)
        'periodidad_intereses': periodidadIntereses,
      if (estadoPrestamo != null) 'estado_prestamo': estadoPrestamo,
      if (motivoCancelacion != null) 'motivo_cancelacion': motivoCancelacion,
      if (montoDevuelto != null) 'monto_devuelto': montoDevuelto,
      if (motivoCastigo != null) 'motivo_castigo': motivoCastigo,
      if (montoPerdido != null) 'monto_perdido': montoPerdido,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaActualizacion != null) 'fecha_actualizacion': fechaActualizacion,
    });
  }

  ConfiguracionPrestamosCompanion copyWith({
    Value<int>? id,
    Value<int>? idPrestamo,
    Value<TipoInteres>? tipoInteres,
    Value<EstadoMoratorio>? estadoMoratorio,
    Value<ManejoExcedente>? manejoExcedente,
    Value<PeriodicidadInteres>? periodidadIntereses,
    Value<EstadoPrestamo>? estadoPrestamo,
    Value<String?>? motivoCancelacion,
    Value<double>? montoDevuelto,
    Value<String?>? motivoCastigo,
    Value<double>? montoPerdido,
    Value<DateTime>? fechaCreacion,
    Value<DateTime>? fechaActualizacion,
  }) {
    return ConfiguracionPrestamosCompanion(
      id: id ?? this.id,
      idPrestamo: idPrestamo ?? this.idPrestamo,
      tipoInteres: tipoInteres ?? this.tipoInteres,
      estadoMoratorio: estadoMoratorio ?? this.estadoMoratorio,
      manejoExcedente: manejoExcedente ?? this.manejoExcedente,
      periodidadIntereses: periodidadIntereses ?? this.periodidadIntereses,
      estadoPrestamo: estadoPrestamo ?? this.estadoPrestamo,
      motivoCancelacion: motivoCancelacion ?? this.motivoCancelacion,
      montoDevuelto: montoDevuelto ?? this.montoDevuelto,
      motivoCastigo: motivoCastigo ?? this.motivoCastigo,
      montoPerdido: montoPerdido ?? this.montoPerdido,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id_configuracion'] = Variable<int>(id.value);
    }
    if (idPrestamo.present) {
      map['id_prestamo'] = Variable<int>(idPrestamo.value);
    }
    if (tipoInteres.present) {
      map['tipo_interes'] = Variable<String>(
        $ConfiguracionPrestamosTable.$convertertipoInteres.toSql(
          tipoInteres.value,
        ),
      );
    }
    if (estadoMoratorio.present) {
      map['estado_moratorio'] = Variable<String>(
        $ConfiguracionPrestamosTable.$converterestadoMoratorio.toSql(
          estadoMoratorio.value,
        ),
      );
    }
    if (manejoExcedente.present) {
      map['manejo_excedente'] = Variable<String>(
        $ConfiguracionPrestamosTable.$convertermanejoExcedente.toSql(
          manejoExcedente.value,
        ),
      );
    }
    if (periodidadIntereses.present) {
      map['periodidad_intereses'] = Variable<String>(
        $ConfiguracionPrestamosTable.$converterperiodidadIntereses.toSql(
          periodidadIntereses.value,
        ),
      );
    }
    if (estadoPrestamo.present) {
      map['estado_prestamo'] = Variable<String>(
        $ConfiguracionPrestamosTable.$converterestadoPrestamo.toSql(
          estadoPrestamo.value,
        ),
      );
    }
    if (motivoCancelacion.present) {
      map['motivo_cancelacion'] = Variable<String>(motivoCancelacion.value);
    }
    if (montoDevuelto.present) {
      map['monto_devuelto'] = Variable<double>(montoDevuelto.value);
    }
    if (motivoCastigo.present) {
      map['motivo_castigo'] = Variable<String>(motivoCastigo.value);
    }
    if (montoPerdido.present) {
      map['monto_perdido'] = Variable<double>(montoPerdido.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    if (fechaActualizacion.present) {
      map['fecha_actualizacion'] = Variable<DateTime>(fechaActualizacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracionPrestamosCompanion(')
          ..write('id: $id, ')
          ..write('idPrestamo: $idPrestamo, ')
          ..write('tipoInteres: $tipoInteres, ')
          ..write('estadoMoratorio: $estadoMoratorio, ')
          ..write('manejoExcedente: $manejoExcedente, ')
          ..write('periodidadIntereses: $periodidadIntereses, ')
          ..write('estadoPrestamo: $estadoPrestamo, ')
          ..write('motivoCancelacion: $motivoCancelacion, ')
          ..write('montoDevuelto: $montoDevuelto, ')
          ..write('motivoCastigo: $motivoCastigo, ')
          ..write('montoPerdido: $montoPerdido, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }
}

class $AmortizacionesTable extends Amortizaciones
    with TableInfo<$AmortizacionesTable, Amortizacione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AmortizacionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id_amortizacion',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idPrestamoMeta = const VerificationMeta(
    'idPrestamo',
  );
  @override
  late final GeneratedColumn<int> idPrestamo = GeneratedColumn<int>(
    'id_prestamo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES prestamos(id_prestamo)',
  );
  static const VerificationMeta _idCuotaMeta = const VerificationMeta(
    'idCuota',
  );
  @override
  late final GeneratedColumn<int> idCuota = GeneratedColumn<int>(
    'id_cuota',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaVencimientoMeta = const VerificationMeta(
    'fechaVencimiento',
  );
  @override
  late final GeneratedColumn<DateTime> fechaVencimiento =
      GeneratedColumn<DateTime>(
        'fecha_vencimiento',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _fechaPagadoMeta = const VerificationMeta(
    'fechaPagado',
  );
  @override
  late final GeneratedColumn<DateTime> fechaPagado = GeneratedColumn<DateTime>(
    'fecha_pagado',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _montoInicialMeta = const VerificationMeta(
    'montoInicial',
  );
  @override
  late final GeneratedColumn<double> montoInicial = GeneratedColumn<double>(
    'monto_inicial',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoPagadoMeta = const VerificationMeta(
    'montoPagado',
  );
  @override
  late final GeneratedColumn<double> montoPagado = GeneratedColumn<double>(
    'monto_pagado',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoACapitalMeta = const VerificationMeta(
    'montoACapital',
  );
  @override
  late final GeneratedColumn<double> montoACapital = GeneratedColumn<double>(
    'monto_capital',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoInteresMeta = const VerificationMeta(
    'montoInteres',
  );
  @override
  late final GeneratedColumn<double> montoInteres = GeneratedColumn<double>(
    'monto_interes',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diasMoraMeta = const VerificationMeta(
    'diasMora',
  );
  @override
  late final GeneratedColumn<int> diasMora = GeneratedColumn<int>(
    'dias_mora',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _montoMoraMeta = const VerificationMeta(
    'montoMora',
  );
  @override
  late final GeneratedColumn<double> montoMora = GeneratedColumn<double>(
    'monto_mora',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoExcedenteMeta = const VerificationMeta(
    'montoExcedente',
  );
  @override
  late final GeneratedColumn<double> montoExcedente = GeneratedColumn<double>(
    'monto_excedente',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EstadoAmortizacion, String>
  estadoAmortizacion =
      GeneratedColumn<String>(
        'estado_amortizacion',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EstadoAmortizacion>(
        $AmortizacionesTable.$converterestadoAmortizacion,
      );
  static const VerificationMeta _fechaActualizacionMeta =
      const VerificationMeta('fechaActualizacion');
  @override
  late final GeneratedColumn<DateTime> fechaActualizacion =
      GeneratedColumn<DateTime>(
        'fecha_actualizacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now(),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idPrestamo,
    idCuota,
    fechaVencimiento,
    fechaPagado,
    montoInicial,
    montoPagado,
    montoACapital,
    montoInteres,
    diasMora,
    montoMora,
    montoExcedente,
    estadoAmortizacion,
    fechaActualizacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'amortizaciones';
  @override
  VerificationContext validateIntegrity(
    Insertable<Amortizacione> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_amortizacion')) {
      context.handle(
        _idMeta,
        id.isAcceptableOrUnknown(data['id_amortizacion']!, _idMeta),
      );
    }
    if (data.containsKey('id_prestamo')) {
      context.handle(
        _idPrestamoMeta,
        idPrestamo.isAcceptableOrUnknown(data['id_prestamo']!, _idPrestamoMeta),
      );
    } else if (isInserting) {
      context.missing(_idPrestamoMeta);
    }
    if (data.containsKey('id_cuota')) {
      context.handle(
        _idCuotaMeta,
        idCuota.isAcceptableOrUnknown(data['id_cuota']!, _idCuotaMeta),
      );
    } else if (isInserting) {
      context.missing(_idCuotaMeta);
    }
    if (data.containsKey('fecha_vencimiento')) {
      context.handle(
        _fechaVencimientoMeta,
        fechaVencimiento.isAcceptableOrUnknown(
          data['fecha_vencimiento']!,
          _fechaVencimientoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaVencimientoMeta);
    }
    if (data.containsKey('fecha_pagado')) {
      context.handle(
        _fechaPagadoMeta,
        fechaPagado.isAcceptableOrUnknown(
          data['fecha_pagado']!,
          _fechaPagadoMeta,
        ),
      );
    }
    if (data.containsKey('monto_inicial')) {
      context.handle(
        _montoInicialMeta,
        montoInicial.isAcceptableOrUnknown(
          data['monto_inicial']!,
          _montoInicialMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoInicialMeta);
    }
    if (data.containsKey('monto_pagado')) {
      context.handle(
        _montoPagadoMeta,
        montoPagado.isAcceptableOrUnknown(
          data['monto_pagado']!,
          _montoPagadoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoPagadoMeta);
    }
    if (data.containsKey('monto_capital')) {
      context.handle(
        _montoACapitalMeta,
        montoACapital.isAcceptableOrUnknown(
          data['monto_capital']!,
          _montoACapitalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoACapitalMeta);
    }
    if (data.containsKey('monto_interes')) {
      context.handle(
        _montoInteresMeta,
        montoInteres.isAcceptableOrUnknown(
          data['monto_interes']!,
          _montoInteresMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoInteresMeta);
    }
    if (data.containsKey('dias_mora')) {
      context.handle(
        _diasMoraMeta,
        diasMora.isAcceptableOrUnknown(data['dias_mora']!, _diasMoraMeta),
      );
    }
    if (data.containsKey('monto_mora')) {
      context.handle(
        _montoMoraMeta,
        montoMora.isAcceptableOrUnknown(data['monto_mora']!, _montoMoraMeta),
      );
    } else if (isInserting) {
      context.missing(_montoMoraMeta);
    }
    if (data.containsKey('monto_excedente')) {
      context.handle(
        _montoExcedenteMeta,
        montoExcedente.isAcceptableOrUnknown(
          data['monto_excedente']!,
          _montoExcedenteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoExcedenteMeta);
    }
    if (data.containsKey('fecha_actualizacion')) {
      context.handle(
        _fechaActualizacionMeta,
        fechaActualizacion.isAcceptableOrUnknown(
          data['fecha_actualizacion']!,
          _fechaActualizacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Amortizacione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Amortizacione(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_amortizacion'],
      )!,
      idPrestamo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_prestamo'],
      )!,
      idCuota: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_cuota'],
      )!,
      fechaVencimiento: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_vencimiento'],
      )!,
      fechaPagado: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_pagado'],
      ),
      montoInicial: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto_inicial'],
      )!,
      montoPagado: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto_pagado'],
      )!,
      montoACapital: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto_capital'],
      )!,
      montoInteres: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto_interes'],
      )!,
      diasMora: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dias_mora'],
      )!,
      montoMora: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto_mora'],
      )!,
      montoExcedente: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto_excedente'],
      )!,
      estadoAmortizacion: $AmortizacionesTable.$converterestadoAmortizacion
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}estado_amortizacion'],
            )!,
          ),
      fechaActualizacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_actualizacion'],
      )!,
    );
  }

  @override
  $AmortizacionesTable createAlias(String alias) {
    return $AmortizacionesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EstadoAmortizacion, String, String>
  $converterestadoAmortizacion = const EnumNameConverter<EstadoAmortizacion>(
    EstadoAmortizacion.values,
  );
}

class Amortizacione extends DataClass implements Insertable<Amortizacione> {
  final int id;
  final int idPrestamo;
  final int idCuota;
  final DateTime fechaVencimiento;
  final DateTime? fechaPagado;
  final double montoInicial;
  final double montoPagado;
  final double montoACapital;
  final double montoInteres;
  final int diasMora;
  final double montoMora;
  final double montoExcedente;
  final EstadoAmortizacion estadoAmortizacion;
  final DateTime fechaActualizacion;
  const Amortizacione({
    required this.id,
    required this.idPrestamo,
    required this.idCuota,
    required this.fechaVencimiento,
    this.fechaPagado,
    required this.montoInicial,
    required this.montoPagado,
    required this.montoACapital,
    required this.montoInteres,
    required this.diasMora,
    required this.montoMora,
    required this.montoExcedente,
    required this.estadoAmortizacion,
    required this.fechaActualizacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_amortizacion'] = Variable<int>(id);
    map['id_prestamo'] = Variable<int>(idPrestamo);
    map['id_cuota'] = Variable<int>(idCuota);
    map['fecha_vencimiento'] = Variable<DateTime>(fechaVencimiento);
    if (!nullToAbsent || fechaPagado != null) {
      map['fecha_pagado'] = Variable<DateTime>(fechaPagado);
    }
    map['monto_inicial'] = Variable<double>(montoInicial);
    map['monto_pagado'] = Variable<double>(montoPagado);
    map['monto_capital'] = Variable<double>(montoACapital);
    map['monto_interes'] = Variable<double>(montoInteres);
    map['dias_mora'] = Variable<int>(diasMora);
    map['monto_mora'] = Variable<double>(montoMora);
    map['monto_excedente'] = Variable<double>(montoExcedente);
    {
      map['estado_amortizacion'] = Variable<String>(
        $AmortizacionesTable.$converterestadoAmortizacion.toSql(
          estadoAmortizacion,
        ),
      );
    }
    map['fecha_actualizacion'] = Variable<DateTime>(fechaActualizacion);
    return map;
  }

  AmortizacionesCompanion toCompanion(bool nullToAbsent) {
    return AmortizacionesCompanion(
      id: Value(id),
      idPrestamo: Value(idPrestamo),
      idCuota: Value(idCuota),
      fechaVencimiento: Value(fechaVencimiento),
      fechaPagado: fechaPagado == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaPagado),
      montoInicial: Value(montoInicial),
      montoPagado: Value(montoPagado),
      montoACapital: Value(montoACapital),
      montoInteres: Value(montoInteres),
      diasMora: Value(diasMora),
      montoMora: Value(montoMora),
      montoExcedente: Value(montoExcedente),
      estadoAmortizacion: Value(estadoAmortizacion),
      fechaActualizacion: Value(fechaActualizacion),
    );
  }

  factory Amortizacione.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Amortizacione(
      id: serializer.fromJson<int>(json['id']),
      idPrestamo: serializer.fromJson<int>(json['idPrestamo']),
      idCuota: serializer.fromJson<int>(json['idCuota']),
      fechaVencimiento: serializer.fromJson<DateTime>(json['fechaVencimiento']),
      fechaPagado: serializer.fromJson<DateTime?>(json['fechaPagado']),
      montoInicial: serializer.fromJson<double>(json['montoInicial']),
      montoPagado: serializer.fromJson<double>(json['montoPagado']),
      montoACapital: serializer.fromJson<double>(json['montoACapital']),
      montoInteres: serializer.fromJson<double>(json['montoInteres']),
      diasMora: serializer.fromJson<int>(json['diasMora']),
      montoMora: serializer.fromJson<double>(json['montoMora']),
      montoExcedente: serializer.fromJson<double>(json['montoExcedente']),
      estadoAmortizacion: $AmortizacionesTable.$converterestadoAmortizacion
          .fromJson(serializer.fromJson<String>(json['estadoAmortizacion'])),
      fechaActualizacion: serializer.fromJson<DateTime>(
        json['fechaActualizacion'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idPrestamo': serializer.toJson<int>(idPrestamo),
      'idCuota': serializer.toJson<int>(idCuota),
      'fechaVencimiento': serializer.toJson<DateTime>(fechaVencimiento),
      'fechaPagado': serializer.toJson<DateTime?>(fechaPagado),
      'montoInicial': serializer.toJson<double>(montoInicial),
      'montoPagado': serializer.toJson<double>(montoPagado),
      'montoACapital': serializer.toJson<double>(montoACapital),
      'montoInteres': serializer.toJson<double>(montoInteres),
      'diasMora': serializer.toJson<int>(diasMora),
      'montoMora': serializer.toJson<double>(montoMora),
      'montoExcedente': serializer.toJson<double>(montoExcedente),
      'estadoAmortizacion': serializer.toJson<String>(
        $AmortizacionesTable.$converterestadoAmortizacion.toJson(
          estadoAmortizacion,
        ),
      ),
      'fechaActualizacion': serializer.toJson<DateTime>(fechaActualizacion),
    };
  }

  Amortizacione copyWith({
    int? id,
    int? idPrestamo,
    int? idCuota,
    DateTime? fechaVencimiento,
    Value<DateTime?> fechaPagado = const Value.absent(),
    double? montoInicial,
    double? montoPagado,
    double? montoACapital,
    double? montoInteres,
    int? diasMora,
    double? montoMora,
    double? montoExcedente,
    EstadoAmortizacion? estadoAmortizacion,
    DateTime? fechaActualizacion,
  }) => Amortizacione(
    id: id ?? this.id,
    idPrestamo: idPrestamo ?? this.idPrestamo,
    idCuota: idCuota ?? this.idCuota,
    fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
    fechaPagado: fechaPagado.present ? fechaPagado.value : this.fechaPagado,
    montoInicial: montoInicial ?? this.montoInicial,
    montoPagado: montoPagado ?? this.montoPagado,
    montoACapital: montoACapital ?? this.montoACapital,
    montoInteres: montoInteres ?? this.montoInteres,
    diasMora: diasMora ?? this.diasMora,
    montoMora: montoMora ?? this.montoMora,
    montoExcedente: montoExcedente ?? this.montoExcedente,
    estadoAmortizacion: estadoAmortizacion ?? this.estadoAmortizacion,
    fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
  );
  Amortizacione copyWithCompanion(AmortizacionesCompanion data) {
    return Amortizacione(
      id: data.id.present ? data.id.value : this.id,
      idPrestamo: data.idPrestamo.present
          ? data.idPrestamo.value
          : this.idPrestamo,
      idCuota: data.idCuota.present ? data.idCuota.value : this.idCuota,
      fechaVencimiento: data.fechaVencimiento.present
          ? data.fechaVencimiento.value
          : this.fechaVencimiento,
      fechaPagado: data.fechaPagado.present
          ? data.fechaPagado.value
          : this.fechaPagado,
      montoInicial: data.montoInicial.present
          ? data.montoInicial.value
          : this.montoInicial,
      montoPagado: data.montoPagado.present
          ? data.montoPagado.value
          : this.montoPagado,
      montoACapital: data.montoACapital.present
          ? data.montoACapital.value
          : this.montoACapital,
      montoInteres: data.montoInteres.present
          ? data.montoInteres.value
          : this.montoInteres,
      diasMora: data.diasMora.present ? data.diasMora.value : this.diasMora,
      montoMora: data.montoMora.present ? data.montoMora.value : this.montoMora,
      montoExcedente: data.montoExcedente.present
          ? data.montoExcedente.value
          : this.montoExcedente,
      estadoAmortizacion: data.estadoAmortizacion.present
          ? data.estadoAmortizacion.value
          : this.estadoAmortizacion,
      fechaActualizacion: data.fechaActualizacion.present
          ? data.fechaActualizacion.value
          : this.fechaActualizacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Amortizacione(')
          ..write('id: $id, ')
          ..write('idPrestamo: $idPrestamo, ')
          ..write('idCuota: $idCuota, ')
          ..write('fechaVencimiento: $fechaVencimiento, ')
          ..write('fechaPagado: $fechaPagado, ')
          ..write('montoInicial: $montoInicial, ')
          ..write('montoPagado: $montoPagado, ')
          ..write('montoACapital: $montoACapital, ')
          ..write('montoInteres: $montoInteres, ')
          ..write('diasMora: $diasMora, ')
          ..write('montoMora: $montoMora, ')
          ..write('montoExcedente: $montoExcedente, ')
          ..write('estadoAmortizacion: $estadoAmortizacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idPrestamo,
    idCuota,
    fechaVencimiento,
    fechaPagado,
    montoInicial,
    montoPagado,
    montoACapital,
    montoInteres,
    diasMora,
    montoMora,
    montoExcedente,
    estadoAmortizacion,
    fechaActualizacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Amortizacione &&
          other.id == this.id &&
          other.idPrestamo == this.idPrestamo &&
          other.idCuota == this.idCuota &&
          other.fechaVencimiento == this.fechaVencimiento &&
          other.fechaPagado == this.fechaPagado &&
          other.montoInicial == this.montoInicial &&
          other.montoPagado == this.montoPagado &&
          other.montoACapital == this.montoACapital &&
          other.montoInteres == this.montoInteres &&
          other.diasMora == this.diasMora &&
          other.montoMora == this.montoMora &&
          other.montoExcedente == this.montoExcedente &&
          other.estadoAmortizacion == this.estadoAmortizacion &&
          other.fechaActualizacion == this.fechaActualizacion);
}

class AmortizacionesCompanion extends UpdateCompanion<Amortizacione> {
  final Value<int> id;
  final Value<int> idPrestamo;
  final Value<int> idCuota;
  final Value<DateTime> fechaVencimiento;
  final Value<DateTime?> fechaPagado;
  final Value<double> montoInicial;
  final Value<double> montoPagado;
  final Value<double> montoACapital;
  final Value<double> montoInteres;
  final Value<int> diasMora;
  final Value<double> montoMora;
  final Value<double> montoExcedente;
  final Value<EstadoAmortizacion> estadoAmortizacion;
  final Value<DateTime> fechaActualizacion;
  const AmortizacionesCompanion({
    this.id = const Value.absent(),
    this.idPrestamo = const Value.absent(),
    this.idCuota = const Value.absent(),
    this.fechaVencimiento = const Value.absent(),
    this.fechaPagado = const Value.absent(),
    this.montoInicial = const Value.absent(),
    this.montoPagado = const Value.absent(),
    this.montoACapital = const Value.absent(),
    this.montoInteres = const Value.absent(),
    this.diasMora = const Value.absent(),
    this.montoMora = const Value.absent(),
    this.montoExcedente = const Value.absent(),
    this.estadoAmortizacion = const Value.absent(),
    this.fechaActualizacion = const Value.absent(),
  });
  AmortizacionesCompanion.insert({
    this.id = const Value.absent(),
    required int idPrestamo,
    required int idCuota,
    required DateTime fechaVencimiento,
    this.fechaPagado = const Value.absent(),
    required double montoInicial,
    required double montoPagado,
    required double montoACapital,
    required double montoInteres,
    this.diasMora = const Value.absent(),
    required double montoMora,
    required double montoExcedente,
    required EstadoAmortizacion estadoAmortizacion,
    this.fechaActualizacion = const Value.absent(),
  }) : idPrestamo = Value(idPrestamo),
       idCuota = Value(idCuota),
       fechaVencimiento = Value(fechaVencimiento),
       montoInicial = Value(montoInicial),
       montoPagado = Value(montoPagado),
       montoACapital = Value(montoACapital),
       montoInteres = Value(montoInteres),
       montoMora = Value(montoMora),
       montoExcedente = Value(montoExcedente),
       estadoAmortizacion = Value(estadoAmortizacion);
  static Insertable<Amortizacione> custom({
    Expression<int>? id,
    Expression<int>? idPrestamo,
    Expression<int>? idCuota,
    Expression<DateTime>? fechaVencimiento,
    Expression<DateTime>? fechaPagado,
    Expression<double>? montoInicial,
    Expression<double>? montoPagado,
    Expression<double>? montoACapital,
    Expression<double>? montoInteres,
    Expression<int>? diasMora,
    Expression<double>? montoMora,
    Expression<double>? montoExcedente,
    Expression<String>? estadoAmortizacion,
    Expression<DateTime>? fechaActualizacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id_amortizacion': id,
      if (idPrestamo != null) 'id_prestamo': idPrestamo,
      if (idCuota != null) 'id_cuota': idCuota,
      if (fechaVencimiento != null) 'fecha_vencimiento': fechaVencimiento,
      if (fechaPagado != null) 'fecha_pagado': fechaPagado,
      if (montoInicial != null) 'monto_inicial': montoInicial,
      if (montoPagado != null) 'monto_pagado': montoPagado,
      if (montoACapital != null) 'monto_capital': montoACapital,
      if (montoInteres != null) 'monto_interes': montoInteres,
      if (diasMora != null) 'dias_mora': diasMora,
      if (montoMora != null) 'monto_mora': montoMora,
      if (montoExcedente != null) 'monto_excedente': montoExcedente,
      if (estadoAmortizacion != null) 'estado_amortizacion': estadoAmortizacion,
      if (fechaActualizacion != null) 'fecha_actualizacion': fechaActualizacion,
    });
  }

  AmortizacionesCompanion copyWith({
    Value<int>? id,
    Value<int>? idPrestamo,
    Value<int>? idCuota,
    Value<DateTime>? fechaVencimiento,
    Value<DateTime?>? fechaPagado,
    Value<double>? montoInicial,
    Value<double>? montoPagado,
    Value<double>? montoACapital,
    Value<double>? montoInteres,
    Value<int>? diasMora,
    Value<double>? montoMora,
    Value<double>? montoExcedente,
    Value<EstadoAmortizacion>? estadoAmortizacion,
    Value<DateTime>? fechaActualizacion,
  }) {
    return AmortizacionesCompanion(
      id: id ?? this.id,
      idPrestamo: idPrestamo ?? this.idPrestamo,
      idCuota: idCuota ?? this.idCuota,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      fechaPagado: fechaPagado ?? this.fechaPagado,
      montoInicial: montoInicial ?? this.montoInicial,
      montoPagado: montoPagado ?? this.montoPagado,
      montoACapital: montoACapital ?? this.montoACapital,
      montoInteres: montoInteres ?? this.montoInteres,
      diasMora: diasMora ?? this.diasMora,
      montoMora: montoMora ?? this.montoMora,
      montoExcedente: montoExcedente ?? this.montoExcedente,
      estadoAmortizacion: estadoAmortizacion ?? this.estadoAmortizacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id_amortizacion'] = Variable<int>(id.value);
    }
    if (idPrestamo.present) {
      map['id_prestamo'] = Variable<int>(idPrestamo.value);
    }
    if (idCuota.present) {
      map['id_cuota'] = Variable<int>(idCuota.value);
    }
    if (fechaVencimiento.present) {
      map['fecha_vencimiento'] = Variable<DateTime>(fechaVencimiento.value);
    }
    if (fechaPagado.present) {
      map['fecha_pagado'] = Variable<DateTime>(fechaPagado.value);
    }
    if (montoInicial.present) {
      map['monto_inicial'] = Variable<double>(montoInicial.value);
    }
    if (montoPagado.present) {
      map['monto_pagado'] = Variable<double>(montoPagado.value);
    }
    if (montoACapital.present) {
      map['monto_capital'] = Variable<double>(montoACapital.value);
    }
    if (montoInteres.present) {
      map['monto_interes'] = Variable<double>(montoInteres.value);
    }
    if (diasMora.present) {
      map['dias_mora'] = Variable<int>(diasMora.value);
    }
    if (montoMora.present) {
      map['monto_mora'] = Variable<double>(montoMora.value);
    }
    if (montoExcedente.present) {
      map['monto_excedente'] = Variable<double>(montoExcedente.value);
    }
    if (estadoAmortizacion.present) {
      map['estado_amortizacion'] = Variable<String>(
        $AmortizacionesTable.$converterestadoAmortizacion.toSql(
          estadoAmortizacion.value,
        ),
      );
    }
    if (fechaActualizacion.present) {
      map['fecha_actualizacion'] = Variable<DateTime>(fechaActualizacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AmortizacionesCompanion(')
          ..write('id: $id, ')
          ..write('idPrestamo: $idPrestamo, ')
          ..write('idCuota: $idCuota, ')
          ..write('fechaVencimiento: $fechaVencimiento, ')
          ..write('fechaPagado: $fechaPagado, ')
          ..write('montoInicial: $montoInicial, ')
          ..write('montoPagado: $montoPagado, ')
          ..write('montoACapital: $montoACapital, ')
          ..write('montoInteres: $montoInteres, ')
          ..write('diasMora: $diasMora, ')
          ..write('montoMora: $montoMora, ')
          ..write('montoExcedente: $montoExcedente, ')
          ..write('estadoAmortizacion: $estadoAmortizacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DeudoresTable deudores = $DeudoresTable(this);
  late final $PrestamosTable prestamos = $PrestamosTable(this);
  late final $ScoresTable scores = $ScoresTable(this);
  late final $ConfiguracionPrestamosTable configuracionPrestamos =
      $ConfiguracionPrestamosTable(this);
  late final $AmortizacionesTable amortizaciones = $AmortizacionesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    deudores,
    prestamos,
    scores,
    configuracionPrestamos,
    amortizaciones,
  ];
}

typedef $$DeudoresTableCreateCompanionBuilder =
    DeudoresCompanion Function({
      Value<int> id,
      required String nombre,
      required String telefono,
      Value<String?> correoElectronico,
      required String direccion,
      required String numeroIdentificacion,
      required int edad,
      required EstadoCliente estado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaActualizacion,
    });
typedef $$DeudoresTableUpdateCompanionBuilder =
    DeudoresCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> telefono,
      Value<String?> correoElectronico,
      Value<String> direccion,
      Value<String> numeroIdentificacion,
      Value<int> edad,
      Value<EstadoCliente> estado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaActualizacion,
    });

final class $$DeudoresTableReferences
    extends BaseReferences<_$AppDatabase, $DeudoresTable, Deudore> {
  $$DeudoresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PrestamosTable, List<Prestamo>>
  _prestamosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.prestamos,
    aliasName: 'deudores__id_deudor__prestamos__id_deudor',
  );

  $$PrestamosTableProcessedTableManager get prestamosRefs {
    final manager = $$PrestamosTableTableManager(
      $_db,
      $_db.prestamos,
    ).filter((f) => f.idDeudor.id.sqlEquals($_itemColumn<int>('id_deudor')!));

    final cache = $_typedResult.readTableOrNull(_prestamosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ScoresTable, List<Score>> _scoresRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.scores,
    aliasName: 'deudores__id_deudor__scores__id_deudor',
  );

  $$ScoresTableProcessedTableManager get scoresRefs {
    final manager = $$ScoresTableTableManager(
      $_db,
      $_db.scores,
    ).filter((f) => f.idDeudor.id.sqlEquals($_itemColumn<int>('id_deudor')!));

    final cache = $_typedResult.readTableOrNull(_scoresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DeudoresTableFilterComposer
    extends Composer<_$AppDatabase, $DeudoresTable> {
  $$DeudoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correoElectronico => $composableBuilder(
    column: $table.correoElectronico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroIdentificacion => $composableBuilder(
    column: $table.numeroIdentificacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get edad => $composableBuilder(
    column: $table.edad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EstadoCliente, EstadoCliente, String>
  get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaActualizacion => $composableBuilder(
    column: $table.fechaActualizacion,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> prestamosRefs(
    Expression<bool> Function($$PrestamosTableFilterComposer f) f,
  ) {
    final $$PrestamosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.prestamos,
      getReferencedColumn: (t) => t.idDeudor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestamosTableFilterComposer(
            $db: $db,
            $table: $db.prestamos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> scoresRefs(
    Expression<bool> Function($$ScoresTableFilterComposer f) f,
  ) {
    final $$ScoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scores,
      getReferencedColumn: (t) => t.idDeudor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScoresTableFilterComposer(
            $db: $db,
            $table: $db.scores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DeudoresTableOrderingComposer
    extends Composer<_$AppDatabase, $DeudoresTable> {
  $$DeudoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correoElectronico => $composableBuilder(
    column: $table.correoElectronico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroIdentificacion => $composableBuilder(
    column: $table.numeroIdentificacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get edad => $composableBuilder(
    column: $table.edad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaActualizacion => $composableBuilder(
    column: $table.fechaActualizacion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeudoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeudoresTable> {
  $$DeudoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get correoElectronico => $composableBuilder(
    column: $table.correoElectronico,
    builder: (column) => column,
  );

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get numeroIdentificacion => $composableBuilder(
    column: $table.numeroIdentificacion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get edad =>
      $composableBuilder(column: $table.edad, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EstadoCliente, String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaActualizacion => $composableBuilder(
    column: $table.fechaActualizacion,
    builder: (column) => column,
  );

  Expression<T> prestamosRefs<T extends Object>(
    Expression<T> Function($$PrestamosTableAnnotationComposer a) f,
  ) {
    final $$PrestamosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.prestamos,
      getReferencedColumn: (t) => t.idDeudor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestamosTableAnnotationComposer(
            $db: $db,
            $table: $db.prestamos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> scoresRefs<T extends Object>(
    Expression<T> Function($$ScoresTableAnnotationComposer a) f,
  ) {
    final $$ScoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scores,
      getReferencedColumn: (t) => t.idDeudor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScoresTableAnnotationComposer(
            $db: $db,
            $table: $db.scores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DeudoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeudoresTable,
          Deudore,
          $$DeudoresTableFilterComposer,
          $$DeudoresTableOrderingComposer,
          $$DeudoresTableAnnotationComposer,
          $$DeudoresTableCreateCompanionBuilder,
          $$DeudoresTableUpdateCompanionBuilder,
          (Deudore, $$DeudoresTableReferences),
          Deudore,
          PrefetchHooks Function({bool prestamosRefs, bool scoresRefs})
        > {
  $$DeudoresTableTableManager(_$AppDatabase db, $DeudoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeudoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeudoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeudoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String?> correoElectronico = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String> numeroIdentificacion = const Value.absent(),
                Value<int> edad = const Value.absent(),
                Value<EstadoCliente> estado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaActualizacion = const Value.absent(),
              }) => DeudoresCompanion(
                id: id,
                nombre: nombre,
                telefono: telefono,
                correoElectronico: correoElectronico,
                direccion: direccion,
                numeroIdentificacion: numeroIdentificacion,
                edad: edad,
                estado: estado,
                fechaCreacion: fechaCreacion,
                fechaActualizacion: fechaActualizacion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String telefono,
                Value<String?> correoElectronico = const Value.absent(),
                required String direccion,
                required String numeroIdentificacion,
                required int edad,
                required EstadoCliente estado,
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaActualizacion = const Value.absent(),
              }) => DeudoresCompanion.insert(
                id: id,
                nombre: nombre,
                telefono: telefono,
                correoElectronico: correoElectronico,
                direccion: direccion,
                numeroIdentificacion: numeroIdentificacion,
                edad: edad,
                estado: estado,
                fechaCreacion: fechaCreacion,
                fechaActualizacion: fechaActualizacion,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DeudoresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({prestamosRefs = false, scoresRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (prestamosRefs) db.prestamos,
                if (scoresRefs) db.scores,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (prestamosRefs)
                    await $_getPrefetchedData<
                      Deudore,
                      $DeudoresTable,
                      Prestamo
                    >(
                      currentTable: table,
                      referencedTable: $$DeudoresTableReferences
                          ._prestamosRefsTable(db),
                      managerFromTypedResult: (p0) => $$DeudoresTableReferences(
                        db,
                        table,
                        p0,
                      ).prestamosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.idDeudor == item.id),
                      typedResults: items,
                    ),
                  if (scoresRefs)
                    await $_getPrefetchedData<Deudore, $DeudoresTable, Score>(
                      currentTable: table,
                      referencedTable: $$DeudoresTableReferences
                          ._scoresRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DeudoresTableReferences(db, table, p0).scoresRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.idDeudor == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DeudoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeudoresTable,
      Deudore,
      $$DeudoresTableFilterComposer,
      $$DeudoresTableOrderingComposer,
      $$DeudoresTableAnnotationComposer,
      $$DeudoresTableCreateCompanionBuilder,
      $$DeudoresTableUpdateCompanionBuilder,
      (Deudore, $$DeudoresTableReferences),
      Deudore,
      PrefetchHooks Function({bool prestamosRefs, bool scoresRefs})
    >;
typedef $$PrestamosTableCreateCompanionBuilder =
    PrestamosCompanion Function({
      Value<int> id,
      required int idDeudor,
      required double tasaInteres,
      required double tasaMoratoria,
      required double monto,
      required int plazoMeses,
      required double montoCuota,
      Value<DateTime> fechaCreacion,
    });
typedef $$PrestamosTableUpdateCompanionBuilder =
    PrestamosCompanion Function({
      Value<int> id,
      Value<int> idDeudor,
      Value<double> tasaInteres,
      Value<double> tasaMoratoria,
      Value<double> monto,
      Value<int> plazoMeses,
      Value<double> montoCuota,
      Value<DateTime> fechaCreacion,
    });

final class $$PrestamosTableReferences
    extends BaseReferences<_$AppDatabase, $PrestamosTable, Prestamo> {
  $$PrestamosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DeudoresTable _idDeudorTable(_$AppDatabase db) =>
      db.deudores.createAlias('prestamos__id_deudor__deudores__id_deudor');

  $$DeudoresTableProcessedTableManager get idDeudor {
    final $_column = $_itemColumn<int>('id_deudor')!;

    final manager = $$DeudoresTableTableManager(
      $_db,
      $_db.deudores,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idDeudorTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ScoresTable, List<Score>> _scoresRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.scores,
    aliasName: 'prestamos__id_prestamo__scores__id_prestamo',
  );

  $$ScoresTableProcessedTableManager get scoresRefs {
    final manager = $$ScoresTableTableManager($_db, $_db.scores).filter(
      (f) => f.idPrestamo.id.sqlEquals($_itemColumn<int>('id_prestamo')!),
    );

    final cache = $_typedResult.readTableOrNull(_scoresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ConfiguracionPrestamosTable,
    List<ConfiguracionPrestamo>
  >
  _configuracionPrestamosRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.configuracionPrestamos,
        aliasName:
            'prestamos__id_prestamo__configuracion_prestamos__id_prestamo',
      );

  $$ConfiguracionPrestamosTableProcessedTableManager
  get configuracionPrestamosRefs {
    final manager =
        $$ConfiguracionPrestamosTableTableManager(
          $_db,
          $_db.configuracionPrestamos,
        ).filter(
          (f) => f.idPrestamo.id.sqlEquals($_itemColumn<int>('id_prestamo')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _configuracionPrestamosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AmortizacionesTable, List<Amortizacione>>
  _amortizacionesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.amortizaciones,
    aliasName: 'prestamos__id_prestamo__amortizaciones__id_prestamo',
  );

  $$AmortizacionesTableProcessedTableManager get amortizacionesRefs {
    final manager = $$AmortizacionesTableTableManager($_db, $_db.amortizaciones)
        .filter(
          (f) => f.idPrestamo.id.sqlEquals($_itemColumn<int>('id_prestamo')!),
        );

    final cache = $_typedResult.readTableOrNull(_amortizacionesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PrestamosTableFilterComposer
    extends Composer<_$AppDatabase, $PrestamosTable> {
  $$PrestamosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tasaInteres => $composableBuilder(
    column: $table.tasaInteres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tasaMoratoria => $composableBuilder(
    column: $table.tasaMoratoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plazoMeses => $composableBuilder(
    column: $table.plazoMeses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montoCuota => $composableBuilder(
    column: $table.montoCuota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  $$DeudoresTableFilterComposer get idDeudor {
    final $$DeudoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDeudor,
      referencedTable: $db.deudores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeudoresTableFilterComposer(
            $db: $db,
            $table: $db.deudores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> scoresRefs(
    Expression<bool> Function($$ScoresTableFilterComposer f) f,
  ) {
    final $$ScoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scores,
      getReferencedColumn: (t) => t.idPrestamo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScoresTableFilterComposer(
            $db: $db,
            $table: $db.scores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> configuracionPrestamosRefs(
    Expression<bool> Function($$ConfiguracionPrestamosTableFilterComposer f) f,
  ) {
    final $$ConfiguracionPrestamosTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.configuracionPrestamos,
          getReferencedColumn: (t) => t.idPrestamo,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ConfiguracionPrestamosTableFilterComposer(
                $db: $db,
                $table: $db.configuracionPrestamos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> amortizacionesRefs(
    Expression<bool> Function($$AmortizacionesTableFilterComposer f) f,
  ) {
    final $$AmortizacionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.amortizaciones,
      getReferencedColumn: (t) => t.idPrestamo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AmortizacionesTableFilterComposer(
            $db: $db,
            $table: $db.amortizaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PrestamosTableOrderingComposer
    extends Composer<_$AppDatabase, $PrestamosTable> {
  $$PrestamosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tasaInteres => $composableBuilder(
    column: $table.tasaInteres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tasaMoratoria => $composableBuilder(
    column: $table.tasaMoratoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plazoMeses => $composableBuilder(
    column: $table.plazoMeses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montoCuota => $composableBuilder(
    column: $table.montoCuota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  $$DeudoresTableOrderingComposer get idDeudor {
    final $$DeudoresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDeudor,
      referencedTable: $db.deudores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeudoresTableOrderingComposer(
            $db: $db,
            $table: $db.deudores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrestamosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrestamosTable> {
  $$PrestamosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get tasaInteres => $composableBuilder(
    column: $table.tasaInteres,
    builder: (column) => column,
  );

  GeneratedColumn<double> get tasaMoratoria => $composableBuilder(
    column: $table.tasaMoratoria,
    builder: (column) => column,
  );

  GeneratedColumn<double> get monto =>
      $composableBuilder(column: $table.monto, builder: (column) => column);

  GeneratedColumn<int> get plazoMeses => $composableBuilder(
    column: $table.plazoMeses,
    builder: (column) => column,
  );

  GeneratedColumn<double> get montoCuota => $composableBuilder(
    column: $table.montoCuota,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  $$DeudoresTableAnnotationComposer get idDeudor {
    final $$DeudoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDeudor,
      referencedTable: $db.deudores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeudoresTableAnnotationComposer(
            $db: $db,
            $table: $db.deudores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> scoresRefs<T extends Object>(
    Expression<T> Function($$ScoresTableAnnotationComposer a) f,
  ) {
    final $$ScoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scores,
      getReferencedColumn: (t) => t.idPrestamo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScoresTableAnnotationComposer(
            $db: $db,
            $table: $db.scores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> configuracionPrestamosRefs<T extends Object>(
    Expression<T> Function($$ConfiguracionPrestamosTableAnnotationComposer a) f,
  ) {
    final $$ConfiguracionPrestamosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.configuracionPrestamos,
          getReferencedColumn: (t) => t.idPrestamo,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ConfiguracionPrestamosTableAnnotationComposer(
                $db: $db,
                $table: $db.configuracionPrestamos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> amortizacionesRefs<T extends Object>(
    Expression<T> Function($$AmortizacionesTableAnnotationComposer a) f,
  ) {
    final $$AmortizacionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.amortizaciones,
      getReferencedColumn: (t) => t.idPrestamo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AmortizacionesTableAnnotationComposer(
            $db: $db,
            $table: $db.amortizaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PrestamosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrestamosTable,
          Prestamo,
          $$PrestamosTableFilterComposer,
          $$PrestamosTableOrderingComposer,
          $$PrestamosTableAnnotationComposer,
          $$PrestamosTableCreateCompanionBuilder,
          $$PrestamosTableUpdateCompanionBuilder,
          (Prestamo, $$PrestamosTableReferences),
          Prestamo,
          PrefetchHooks Function({
            bool idDeudor,
            bool scoresRefs,
            bool configuracionPrestamosRefs,
            bool amortizacionesRefs,
          })
        > {
  $$PrestamosTableTableManager(_$AppDatabase db, $PrestamosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrestamosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrestamosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrestamosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> idDeudor = const Value.absent(),
                Value<double> tasaInteres = const Value.absent(),
                Value<double> tasaMoratoria = const Value.absent(),
                Value<double> monto = const Value.absent(),
                Value<int> plazoMeses = const Value.absent(),
                Value<double> montoCuota = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
              }) => PrestamosCompanion(
                id: id,
                idDeudor: idDeudor,
                tasaInteres: tasaInteres,
                tasaMoratoria: tasaMoratoria,
                monto: monto,
                plazoMeses: plazoMeses,
                montoCuota: montoCuota,
                fechaCreacion: fechaCreacion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int idDeudor,
                required double tasaInteres,
                required double tasaMoratoria,
                required double monto,
                required int plazoMeses,
                required double montoCuota,
                Value<DateTime> fechaCreacion = const Value.absent(),
              }) => PrestamosCompanion.insert(
                id: id,
                idDeudor: idDeudor,
                tasaInteres: tasaInteres,
                tasaMoratoria: tasaMoratoria,
                monto: monto,
                plazoMeses: plazoMeses,
                montoCuota: montoCuota,
                fechaCreacion: fechaCreacion,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PrestamosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                idDeudor = false,
                scoresRefs = false,
                configuracionPrestamosRefs = false,
                amortizacionesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (scoresRefs) db.scores,
                    if (configuracionPrestamosRefs) db.configuracionPrestamos,
                    if (amortizacionesRefs) db.amortizaciones,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (idDeudor) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idDeudor,
                                    referencedTable: $$PrestamosTableReferences
                                        ._idDeudorTable(db),
                                    referencedColumn: $$PrestamosTableReferences
                                        ._idDeudorTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (scoresRefs)
                        await $_getPrefetchedData<
                          Prestamo,
                          $PrestamosTable,
                          Score
                        >(
                          currentTable: table,
                          referencedTable: $$PrestamosTableReferences
                              ._scoresRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PrestamosTableReferences(
                                db,
                                table,
                                p0,
                              ).scoresRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idPrestamo == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (configuracionPrestamosRefs)
                        await $_getPrefetchedData<
                          Prestamo,
                          $PrestamosTable,
                          ConfiguracionPrestamo
                        >(
                          currentTable: table,
                          referencedTable: $$PrestamosTableReferences
                              ._configuracionPrestamosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PrestamosTableReferences(
                                db,
                                table,
                                p0,
                              ).configuracionPrestamosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idPrestamo == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (amortizacionesRefs)
                        await $_getPrefetchedData<
                          Prestamo,
                          $PrestamosTable,
                          Amortizacione
                        >(
                          currentTable: table,
                          referencedTable: $$PrestamosTableReferences
                              ._amortizacionesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PrestamosTableReferences(
                                db,
                                table,
                                p0,
                              ).amortizacionesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idPrestamo == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PrestamosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrestamosTable,
      Prestamo,
      $$PrestamosTableFilterComposer,
      $$PrestamosTableOrderingComposer,
      $$PrestamosTableAnnotationComposer,
      $$PrestamosTableCreateCompanionBuilder,
      $$PrestamosTableUpdateCompanionBuilder,
      (Prestamo, $$PrestamosTableReferences),
      Prestamo,
      PrefetchHooks Function({
        bool idDeudor,
        bool scoresRefs,
        bool configuracionPrestamosRefs,
        bool amortizacionesRefs,
      })
    >;
typedef $$ScoresTableCreateCompanionBuilder =
    ScoresCompanion Function({
      Value<int> idPrestamo,
      required int idDeudor,
      required double score,
      Value<DateTime> fechaCreacion,
    });
typedef $$ScoresTableUpdateCompanionBuilder =
    ScoresCompanion Function({
      Value<int> idPrestamo,
      Value<int> idDeudor,
      Value<double> score,
      Value<DateTime> fechaCreacion,
    });

final class $$ScoresTableReferences
    extends BaseReferences<_$AppDatabase, $ScoresTable, Score> {
  $$ScoresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PrestamosTable _idPrestamoTable(_$AppDatabase db) =>
      db.prestamos.createAlias('scores__id_prestamo__prestamos__id_prestamo');

  $$PrestamosTableProcessedTableManager get idPrestamo {
    final $_column = $_itemColumn<int>('id_prestamo')!;

    final manager = $$PrestamosTableTableManager(
      $_db,
      $_db.prestamos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idPrestamoTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DeudoresTable _idDeudorTable(_$AppDatabase db) =>
      db.deudores.createAlias('scores__id_deudor__deudores__id_deudor');

  $$DeudoresTableProcessedTableManager get idDeudor {
    final $_column = $_itemColumn<int>('id_deudor')!;

    final manager = $$DeudoresTableTableManager(
      $_db,
      $_db.deudores,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idDeudorTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScoresTableFilterComposer
    extends Composer<_$AppDatabase, $ScoresTable> {
  $$ScoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  $$PrestamosTableFilterComposer get idPrestamo {
    final $$PrestamosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idPrestamo,
      referencedTable: $db.prestamos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestamosTableFilterComposer(
            $db: $db,
            $table: $db.prestamos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DeudoresTableFilterComposer get idDeudor {
    final $$DeudoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDeudor,
      referencedTable: $db.deudores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeudoresTableFilterComposer(
            $db: $db,
            $table: $db.deudores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScoresTableOrderingComposer
    extends Composer<_$AppDatabase, $ScoresTable> {
  $$ScoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  $$PrestamosTableOrderingComposer get idPrestamo {
    final $$PrestamosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idPrestamo,
      referencedTable: $db.prestamos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestamosTableOrderingComposer(
            $db: $db,
            $table: $db.prestamos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DeudoresTableOrderingComposer get idDeudor {
    final $$DeudoresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDeudor,
      referencedTable: $db.deudores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeudoresTableOrderingComposer(
            $db: $db,
            $table: $db.deudores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScoresTable> {
  $$ScoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  $$PrestamosTableAnnotationComposer get idPrestamo {
    final $$PrestamosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idPrestamo,
      referencedTable: $db.prestamos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestamosTableAnnotationComposer(
            $db: $db,
            $table: $db.prestamos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DeudoresTableAnnotationComposer get idDeudor {
    final $$DeudoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDeudor,
      referencedTable: $db.deudores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeudoresTableAnnotationComposer(
            $db: $db,
            $table: $db.deudores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScoresTable,
          Score,
          $$ScoresTableFilterComposer,
          $$ScoresTableOrderingComposer,
          $$ScoresTableAnnotationComposer,
          $$ScoresTableCreateCompanionBuilder,
          $$ScoresTableUpdateCompanionBuilder,
          (Score, $$ScoresTableReferences),
          Score,
          PrefetchHooks Function({bool idPrestamo, bool idDeudor})
        > {
  $$ScoresTableTableManager(_$AppDatabase db, $ScoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idPrestamo = const Value.absent(),
                Value<int> idDeudor = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
              }) => ScoresCompanion(
                idPrestamo: idPrestamo,
                idDeudor: idDeudor,
                score: score,
                fechaCreacion: fechaCreacion,
              ),
          createCompanionCallback:
              ({
                Value<int> idPrestamo = const Value.absent(),
                required int idDeudor,
                required double score,
                Value<DateTime> fechaCreacion = const Value.absent(),
              }) => ScoresCompanion.insert(
                idPrestamo: idPrestamo,
                idDeudor: idDeudor,
                score: score,
                fechaCreacion: fechaCreacion,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ScoresTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({idPrestamo = false, idDeudor = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idPrestamo) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idPrestamo,
                                referencedTable: $$ScoresTableReferences
                                    ._idPrestamoTable(db),
                                referencedColumn: $$ScoresTableReferences
                                    ._idPrestamoTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (idDeudor) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idDeudor,
                                referencedTable: $$ScoresTableReferences
                                    ._idDeudorTable(db),
                                referencedColumn: $$ScoresTableReferences
                                    ._idDeudorTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScoresTable,
      Score,
      $$ScoresTableFilterComposer,
      $$ScoresTableOrderingComposer,
      $$ScoresTableAnnotationComposer,
      $$ScoresTableCreateCompanionBuilder,
      $$ScoresTableUpdateCompanionBuilder,
      (Score, $$ScoresTableReferences),
      Score,
      PrefetchHooks Function({bool idPrestamo, bool idDeudor})
    >;
typedef $$ConfiguracionPrestamosTableCreateCompanionBuilder =
    ConfiguracionPrestamosCompanion Function({
      Value<int> id,
      required int idPrestamo,
      required TipoInteres tipoInteres,
      required EstadoMoratorio estadoMoratorio,
      required ManejoExcedente manejoExcedente,
      required PeriodicidadInteres periodidadIntereses,
      required EstadoPrestamo estadoPrestamo,
      Value<String?> motivoCancelacion,
      Value<double> montoDevuelto,
      Value<String?> motivoCastigo,
      Value<double> montoPerdido,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaActualizacion,
    });
typedef $$ConfiguracionPrestamosTableUpdateCompanionBuilder =
    ConfiguracionPrestamosCompanion Function({
      Value<int> id,
      Value<int> idPrestamo,
      Value<TipoInteres> tipoInteres,
      Value<EstadoMoratorio> estadoMoratorio,
      Value<ManejoExcedente> manejoExcedente,
      Value<PeriodicidadInteres> periodidadIntereses,
      Value<EstadoPrestamo> estadoPrestamo,
      Value<String?> motivoCancelacion,
      Value<double> montoDevuelto,
      Value<String?> motivoCastigo,
      Value<double> montoPerdido,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaActualizacion,
    });

final class $$ConfiguracionPrestamosTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ConfiguracionPrestamosTable,
          ConfiguracionPrestamo
        > {
  $$ConfiguracionPrestamosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PrestamosTable _idPrestamoTable(_$AppDatabase db) =>
      db.prestamos.createAlias(
        'configuracion_prestamos__id_prestamo__prestamos__id_prestamo',
      );

  $$PrestamosTableProcessedTableManager get idPrestamo {
    final $_column = $_itemColumn<int>('id_prestamo')!;

    final manager = $$PrestamosTableTableManager(
      $_db,
      $_db.prestamos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idPrestamoTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ConfiguracionPrestamosTableFilterComposer
    extends Composer<_$AppDatabase, $ConfiguracionPrestamosTable> {
  $$ConfiguracionPrestamosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoInteres, TipoInteres, String>
  get tipoInteres => $composableBuilder(
    column: $table.tipoInteres,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<EstadoMoratorio, EstadoMoratorio, String>
  get estadoMoratorio => $composableBuilder(
    column: $table.estadoMoratorio,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ManejoExcedente, ManejoExcedente, String>
  get manejoExcedente => $composableBuilder(
    column: $table.manejoExcedente,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    PeriodicidadInteres,
    PeriodicidadInteres,
    String
  >
  get periodidadIntereses => $composableBuilder(
    column: $table.periodidadIntereses,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<EstadoPrestamo, EstadoPrestamo, String>
  get estadoPrestamo => $composableBuilder(
    column: $table.estadoPrestamo,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get motivoCancelacion => $composableBuilder(
    column: $table.motivoCancelacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montoDevuelto => $composableBuilder(
    column: $table.montoDevuelto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motivoCastigo => $composableBuilder(
    column: $table.motivoCastigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montoPerdido => $composableBuilder(
    column: $table.montoPerdido,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaActualizacion => $composableBuilder(
    column: $table.fechaActualizacion,
    builder: (column) => ColumnFilters(column),
  );

  $$PrestamosTableFilterComposer get idPrestamo {
    final $$PrestamosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idPrestamo,
      referencedTable: $db.prestamos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestamosTableFilterComposer(
            $db: $db,
            $table: $db.prestamos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConfiguracionPrestamosTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfiguracionPrestamosTable> {
  $$ConfiguracionPrestamosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoInteres => $composableBuilder(
    column: $table.tipoInteres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estadoMoratorio => $composableBuilder(
    column: $table.estadoMoratorio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manejoExcedente => $composableBuilder(
    column: $table.manejoExcedente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodidadIntereses => $composableBuilder(
    column: $table.periodidadIntereses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estadoPrestamo => $composableBuilder(
    column: $table.estadoPrestamo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motivoCancelacion => $composableBuilder(
    column: $table.motivoCancelacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montoDevuelto => $composableBuilder(
    column: $table.montoDevuelto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motivoCastigo => $composableBuilder(
    column: $table.motivoCastigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montoPerdido => $composableBuilder(
    column: $table.montoPerdido,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaActualizacion => $composableBuilder(
    column: $table.fechaActualizacion,
    builder: (column) => ColumnOrderings(column),
  );

  $$PrestamosTableOrderingComposer get idPrestamo {
    final $$PrestamosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idPrestamo,
      referencedTable: $db.prestamos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestamosTableOrderingComposer(
            $db: $db,
            $table: $db.prestamos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConfiguracionPrestamosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfiguracionPrestamosTable> {
  $$ConfiguracionPrestamosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoInteres, String> get tipoInteres =>
      $composableBuilder(
        column: $table.tipoInteres,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<EstadoMoratorio, String>
  get estadoMoratorio => $composableBuilder(
    column: $table.estadoMoratorio,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ManejoExcedente, String>
  get manejoExcedente => $composableBuilder(
    column: $table.manejoExcedente,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PeriodicidadInteres, String>
  get periodidadIntereses => $composableBuilder(
    column: $table.periodidadIntereses,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<EstadoPrestamo, String> get estadoPrestamo =>
      $composableBuilder(
        column: $table.estadoPrestamo,
        builder: (column) => column,
      );

  GeneratedColumn<String> get motivoCancelacion => $composableBuilder(
    column: $table.motivoCancelacion,
    builder: (column) => column,
  );

  GeneratedColumn<double> get montoDevuelto => $composableBuilder(
    column: $table.montoDevuelto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get motivoCastigo => $composableBuilder(
    column: $table.motivoCastigo,
    builder: (column) => column,
  );

  GeneratedColumn<double> get montoPerdido => $composableBuilder(
    column: $table.montoPerdido,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaActualizacion => $composableBuilder(
    column: $table.fechaActualizacion,
    builder: (column) => column,
  );

  $$PrestamosTableAnnotationComposer get idPrestamo {
    final $$PrestamosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idPrestamo,
      referencedTable: $db.prestamos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestamosTableAnnotationComposer(
            $db: $db,
            $table: $db.prestamos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConfiguracionPrestamosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConfiguracionPrestamosTable,
          ConfiguracionPrestamo,
          $$ConfiguracionPrestamosTableFilterComposer,
          $$ConfiguracionPrestamosTableOrderingComposer,
          $$ConfiguracionPrestamosTableAnnotationComposer,
          $$ConfiguracionPrestamosTableCreateCompanionBuilder,
          $$ConfiguracionPrestamosTableUpdateCompanionBuilder,
          (ConfiguracionPrestamo, $$ConfiguracionPrestamosTableReferences),
          ConfiguracionPrestamo,
          PrefetchHooks Function({bool idPrestamo})
        > {
  $$ConfiguracionPrestamosTableTableManager(
    _$AppDatabase db,
    $ConfiguracionPrestamosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfiguracionPrestamosTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ConfiguracionPrestamosTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ConfiguracionPrestamosTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> idPrestamo = const Value.absent(),
                Value<TipoInteres> tipoInteres = const Value.absent(),
                Value<EstadoMoratorio> estadoMoratorio = const Value.absent(),
                Value<ManejoExcedente> manejoExcedente = const Value.absent(),
                Value<PeriodicidadInteres> periodidadIntereses =
                    const Value.absent(),
                Value<EstadoPrestamo> estadoPrestamo = const Value.absent(),
                Value<String?> motivoCancelacion = const Value.absent(),
                Value<double> montoDevuelto = const Value.absent(),
                Value<String?> motivoCastigo = const Value.absent(),
                Value<double> montoPerdido = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaActualizacion = const Value.absent(),
              }) => ConfiguracionPrestamosCompanion(
                id: id,
                idPrestamo: idPrestamo,
                tipoInteres: tipoInteres,
                estadoMoratorio: estadoMoratorio,
                manejoExcedente: manejoExcedente,
                periodidadIntereses: periodidadIntereses,
                estadoPrestamo: estadoPrestamo,
                motivoCancelacion: motivoCancelacion,
                montoDevuelto: montoDevuelto,
                motivoCastigo: motivoCastigo,
                montoPerdido: montoPerdido,
                fechaCreacion: fechaCreacion,
                fechaActualizacion: fechaActualizacion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int idPrestamo,
                required TipoInteres tipoInteres,
                required EstadoMoratorio estadoMoratorio,
                required ManejoExcedente manejoExcedente,
                required PeriodicidadInteres periodidadIntereses,
                required EstadoPrestamo estadoPrestamo,
                Value<String?> motivoCancelacion = const Value.absent(),
                Value<double> montoDevuelto = const Value.absent(),
                Value<String?> motivoCastigo = const Value.absent(),
                Value<double> montoPerdido = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaActualizacion = const Value.absent(),
              }) => ConfiguracionPrestamosCompanion.insert(
                id: id,
                idPrestamo: idPrestamo,
                tipoInteres: tipoInteres,
                estadoMoratorio: estadoMoratorio,
                manejoExcedente: manejoExcedente,
                periodidadIntereses: periodidadIntereses,
                estadoPrestamo: estadoPrestamo,
                motivoCancelacion: motivoCancelacion,
                montoDevuelto: montoDevuelto,
                motivoCastigo: motivoCastigo,
                montoPerdido: montoPerdido,
                fechaCreacion: fechaCreacion,
                fechaActualizacion: fechaActualizacion,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ConfiguracionPrestamosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idPrestamo = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idPrestamo) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idPrestamo,
                                referencedTable:
                                    $$ConfiguracionPrestamosTableReferences
                                        ._idPrestamoTable(db),
                                referencedColumn:
                                    $$ConfiguracionPrestamosTableReferences
                                        ._idPrestamoTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ConfiguracionPrestamosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConfiguracionPrestamosTable,
      ConfiguracionPrestamo,
      $$ConfiguracionPrestamosTableFilterComposer,
      $$ConfiguracionPrestamosTableOrderingComposer,
      $$ConfiguracionPrestamosTableAnnotationComposer,
      $$ConfiguracionPrestamosTableCreateCompanionBuilder,
      $$ConfiguracionPrestamosTableUpdateCompanionBuilder,
      (ConfiguracionPrestamo, $$ConfiguracionPrestamosTableReferences),
      ConfiguracionPrestamo,
      PrefetchHooks Function({bool idPrestamo})
    >;
typedef $$AmortizacionesTableCreateCompanionBuilder =
    AmortizacionesCompanion Function({
      Value<int> id,
      required int idPrestamo,
      required int idCuota,
      required DateTime fechaVencimiento,
      Value<DateTime?> fechaPagado,
      required double montoInicial,
      required double montoPagado,
      required double montoACapital,
      required double montoInteres,
      Value<int> diasMora,
      required double montoMora,
      required double montoExcedente,
      required EstadoAmortizacion estadoAmortizacion,
      Value<DateTime> fechaActualizacion,
    });
typedef $$AmortizacionesTableUpdateCompanionBuilder =
    AmortizacionesCompanion Function({
      Value<int> id,
      Value<int> idPrestamo,
      Value<int> idCuota,
      Value<DateTime> fechaVencimiento,
      Value<DateTime?> fechaPagado,
      Value<double> montoInicial,
      Value<double> montoPagado,
      Value<double> montoACapital,
      Value<double> montoInteres,
      Value<int> diasMora,
      Value<double> montoMora,
      Value<double> montoExcedente,
      Value<EstadoAmortizacion> estadoAmortizacion,
      Value<DateTime> fechaActualizacion,
    });

final class $$AmortizacionesTableReferences
    extends BaseReferences<_$AppDatabase, $AmortizacionesTable, Amortizacione> {
  $$AmortizacionesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PrestamosTable _idPrestamoTable(_$AppDatabase db) => db.prestamos
      .createAlias('amortizaciones__id_prestamo__prestamos__id_prestamo');

  $$PrestamosTableProcessedTableManager get idPrestamo {
    final $_column = $_itemColumn<int>('id_prestamo')!;

    final manager = $$PrestamosTableTableManager(
      $_db,
      $_db.prestamos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idPrestamoTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AmortizacionesTableFilterComposer
    extends Composer<_$AppDatabase, $AmortizacionesTable> {
  $$AmortizacionesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idCuota => $composableBuilder(
    column: $table.idCuota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaVencimiento => $composableBuilder(
    column: $table.fechaVencimiento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaPagado => $composableBuilder(
    column: $table.fechaPagado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montoInicial => $composableBuilder(
    column: $table.montoInicial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montoPagado => $composableBuilder(
    column: $table.montoPagado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montoACapital => $composableBuilder(
    column: $table.montoACapital,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montoInteres => $composableBuilder(
    column: $table.montoInteres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diasMora => $composableBuilder(
    column: $table.diasMora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montoMora => $composableBuilder(
    column: $table.montoMora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montoExcedente => $composableBuilder(
    column: $table.montoExcedente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EstadoAmortizacion, EstadoAmortizacion, String>
  get estadoAmortizacion => $composableBuilder(
    column: $table.estadoAmortizacion,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get fechaActualizacion => $composableBuilder(
    column: $table.fechaActualizacion,
    builder: (column) => ColumnFilters(column),
  );

  $$PrestamosTableFilterComposer get idPrestamo {
    final $$PrestamosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idPrestamo,
      referencedTable: $db.prestamos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestamosTableFilterComposer(
            $db: $db,
            $table: $db.prestamos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AmortizacionesTableOrderingComposer
    extends Composer<_$AppDatabase, $AmortizacionesTable> {
  $$AmortizacionesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idCuota => $composableBuilder(
    column: $table.idCuota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaVencimiento => $composableBuilder(
    column: $table.fechaVencimiento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaPagado => $composableBuilder(
    column: $table.fechaPagado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montoInicial => $composableBuilder(
    column: $table.montoInicial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montoPagado => $composableBuilder(
    column: $table.montoPagado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montoACapital => $composableBuilder(
    column: $table.montoACapital,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montoInteres => $composableBuilder(
    column: $table.montoInteres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diasMora => $composableBuilder(
    column: $table.diasMora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montoMora => $composableBuilder(
    column: $table.montoMora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montoExcedente => $composableBuilder(
    column: $table.montoExcedente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estadoAmortizacion => $composableBuilder(
    column: $table.estadoAmortizacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaActualizacion => $composableBuilder(
    column: $table.fechaActualizacion,
    builder: (column) => ColumnOrderings(column),
  );

  $$PrestamosTableOrderingComposer get idPrestamo {
    final $$PrestamosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idPrestamo,
      referencedTable: $db.prestamos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestamosTableOrderingComposer(
            $db: $db,
            $table: $db.prestamos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AmortizacionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AmortizacionesTable> {
  $$AmortizacionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get idCuota =>
      $composableBuilder(column: $table.idCuota, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaVencimiento => $composableBuilder(
    column: $table.fechaVencimiento,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaPagado => $composableBuilder(
    column: $table.fechaPagado,
    builder: (column) => column,
  );

  GeneratedColumn<double> get montoInicial => $composableBuilder(
    column: $table.montoInicial,
    builder: (column) => column,
  );

  GeneratedColumn<double> get montoPagado => $composableBuilder(
    column: $table.montoPagado,
    builder: (column) => column,
  );

  GeneratedColumn<double> get montoACapital => $composableBuilder(
    column: $table.montoACapital,
    builder: (column) => column,
  );

  GeneratedColumn<double> get montoInteres => $composableBuilder(
    column: $table.montoInteres,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diasMora =>
      $composableBuilder(column: $table.diasMora, builder: (column) => column);

  GeneratedColumn<double> get montoMora =>
      $composableBuilder(column: $table.montoMora, builder: (column) => column);

  GeneratedColumn<double> get montoExcedente => $composableBuilder(
    column: $table.montoExcedente,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<EstadoAmortizacion, String>
  get estadoAmortizacion => $composableBuilder(
    column: $table.estadoAmortizacion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaActualizacion => $composableBuilder(
    column: $table.fechaActualizacion,
    builder: (column) => column,
  );

  $$PrestamosTableAnnotationComposer get idPrestamo {
    final $$PrestamosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idPrestamo,
      referencedTable: $db.prestamos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestamosTableAnnotationComposer(
            $db: $db,
            $table: $db.prestamos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AmortizacionesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AmortizacionesTable,
          Amortizacione,
          $$AmortizacionesTableFilterComposer,
          $$AmortizacionesTableOrderingComposer,
          $$AmortizacionesTableAnnotationComposer,
          $$AmortizacionesTableCreateCompanionBuilder,
          $$AmortizacionesTableUpdateCompanionBuilder,
          (Amortizacione, $$AmortizacionesTableReferences),
          Amortizacione,
          PrefetchHooks Function({bool idPrestamo})
        > {
  $$AmortizacionesTableTableManager(
    _$AppDatabase db,
    $AmortizacionesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AmortizacionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AmortizacionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AmortizacionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> idPrestamo = const Value.absent(),
                Value<int> idCuota = const Value.absent(),
                Value<DateTime> fechaVencimiento = const Value.absent(),
                Value<DateTime?> fechaPagado = const Value.absent(),
                Value<double> montoInicial = const Value.absent(),
                Value<double> montoPagado = const Value.absent(),
                Value<double> montoACapital = const Value.absent(),
                Value<double> montoInteres = const Value.absent(),
                Value<int> diasMora = const Value.absent(),
                Value<double> montoMora = const Value.absent(),
                Value<double> montoExcedente = const Value.absent(),
                Value<EstadoAmortizacion> estadoAmortizacion =
                    const Value.absent(),
                Value<DateTime> fechaActualizacion = const Value.absent(),
              }) => AmortizacionesCompanion(
                id: id,
                idPrestamo: idPrestamo,
                idCuota: idCuota,
                fechaVencimiento: fechaVencimiento,
                fechaPagado: fechaPagado,
                montoInicial: montoInicial,
                montoPagado: montoPagado,
                montoACapital: montoACapital,
                montoInteres: montoInteres,
                diasMora: diasMora,
                montoMora: montoMora,
                montoExcedente: montoExcedente,
                estadoAmortizacion: estadoAmortizacion,
                fechaActualizacion: fechaActualizacion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int idPrestamo,
                required int idCuota,
                required DateTime fechaVencimiento,
                Value<DateTime?> fechaPagado = const Value.absent(),
                required double montoInicial,
                required double montoPagado,
                required double montoACapital,
                required double montoInteres,
                Value<int> diasMora = const Value.absent(),
                required double montoMora,
                required double montoExcedente,
                required EstadoAmortizacion estadoAmortizacion,
                Value<DateTime> fechaActualizacion = const Value.absent(),
              }) => AmortizacionesCompanion.insert(
                id: id,
                idPrestamo: idPrestamo,
                idCuota: idCuota,
                fechaVencimiento: fechaVencimiento,
                fechaPagado: fechaPagado,
                montoInicial: montoInicial,
                montoPagado: montoPagado,
                montoACapital: montoACapital,
                montoInteres: montoInteres,
                diasMora: diasMora,
                montoMora: montoMora,
                montoExcedente: montoExcedente,
                estadoAmortizacion: estadoAmortizacion,
                fechaActualizacion: fechaActualizacion,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AmortizacionesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idPrestamo = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idPrestamo) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idPrestamo,
                                referencedTable: $$AmortizacionesTableReferences
                                    ._idPrestamoTable(db),
                                referencedColumn:
                                    $$AmortizacionesTableReferences
                                        ._idPrestamoTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AmortizacionesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AmortizacionesTable,
      Amortizacione,
      $$AmortizacionesTableFilterComposer,
      $$AmortizacionesTableOrderingComposer,
      $$AmortizacionesTableAnnotationComposer,
      $$AmortizacionesTableCreateCompanionBuilder,
      $$AmortizacionesTableUpdateCompanionBuilder,
      (Amortizacione, $$AmortizacionesTableReferences),
      Amortizacione,
      PrefetchHooks Function({bool idPrestamo})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DeudoresTableTableManager get deudores =>
      $$DeudoresTableTableManager(_db, _db.deudores);
  $$PrestamosTableTableManager get prestamos =>
      $$PrestamosTableTableManager(_db, _db.prestamos);
  $$ScoresTableTableManager get scores =>
      $$ScoresTableTableManager(_db, _db.scores);
  $$ConfiguracionPrestamosTableTableManager get configuracionPrestamos =>
      $$ConfiguracionPrestamosTableTableManager(
        _db,
        _db.configuracionPrestamos,
      );
  $$AmortizacionesTableTableManager get amortizaciones =>
      $$AmortizacionesTableTableManager(_db, _db.amortizaciones);
}
