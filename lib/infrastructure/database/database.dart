import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:prestapagos/domain/domain.dart';

part 'database.g.dart';

// class TodoItems extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get title => text().withLength(min: 6, max: 32)();
//   TextColumn get content => text().named('body')();
//   DateTimeColumn get createdAt => dateTime().nullable()();
// }

class Deudores extends Table {
  IntColumn get id => integer().named('id_deudor').autoIncrement()();
  TextColumn get nombre => text().withLength(max: 120)();
  TextColumn get telefono => text().withLength(max: 10)();
  TextColumn get correoElectronico =>
      text().named('email').withLength(min: 1, max: 100).unique().nullable()();
  TextColumn get direccion => text().withLength(min: 1, max: 150)();
  TextColumn get numeroIdentificacion =>
      text().named('numero_identificacion').withLength(min: 1, max: 30)();
  IntColumn get edad => integer()();
  TextColumn get estado => textEnum<EstadoCliente>()();
  DateTimeColumn get fechaCreacion =>
      dateTime().named('fecha_creacion').clientDefault(() => DateTime.now())();
  DateTimeColumn get fechaActualizacion => dateTime()
      .named('fecha_actualizacion')
      .clientDefault(() => DateTime.now())();
}

class Scores extends Table {
  IntColumn get id => integer().named('id_score').autoIncrement()();
  IntColumn get idDeudor => integer()
      .named('id_deudor')
      .customConstraint('NOT NULL REFERENCES deudores(id_deudor)')();
  RealColumn get score => real()();
  DateTimeColumn get fechaCreacion =>
      dateTime().named('fecha_creacion').clientDefault(() => DateTime.now())();
}

class Prestamos extends Table {
  IntColumn get id => integer().named('id_prestamo').autoIncrement()();
  IntColumn get idDeudor => integer()
      .named('id_deudor')
      .customConstraint('NOT NULL REFERENCES deudores(id_deudor)')();
  RealColumn get tasaInteres => real().named('tasa_interes')();
  RealColumn get tasaMoratoria => real().named('tasa_interes_moratoria')();
  RealColumn get monto => real()();
  IntColumn get plazoMeses => integer().named('plazo_meses')();
  RealColumn get montoCuota => real().named('monto_cuota')();
  DateTimeColumn get fechaCreacion =>
      dateTime().named('fecha_creacion').clientDefault(() => DateTime.now())();
}

class ConfiguracionPrestamos extends Table {
  IntColumn get id => integer().named('id_configuracion').autoIncrement()();
  IntColumn get idPrestamo => integer()
      .named('id_prestamo')
      .customConstraint('NOT NULL REFERENCES prestamos(id_prestamo)')
      .unique()();
  TextColumn get tipoInteres => textEnum<TipoInteres>().named('tipo_interes')();
  TextColumn get estadoMoratorio =>
      textEnum<EstadoCliente>().named('estado_moratorio')();
  TextColumn get manejoExcedente =>
      textEnum<ManejoExcedente>().named('manejo_excedente')();
  TextColumn get periodidadIntereses =>
      textEnum<PeriodicidadInteres>().named('periodidad_intereses')();
  TextColumn get estadoPrestamo =>
      textEnum<EstadoPrestamo>().named('estado_prestamo')();
  DateTimeColumn get fechaCreacion =>
      dateTime().named('fecha_creacion').clientDefault(() => DateTime.now())();
  DateTimeColumn get fechaActualizacion => dateTime()
      .named('fecha_actualizacion')
      .clientDefault(() => DateTime.now())();
}

class Amortizaciones extends Table {
  IntColumn get id => integer().named('id_amortizacion').autoIncrement()();
  IntColumn get idPrestamo => integer()
      .named('id_prestamo')
      .customConstraint('NOT NULL REFERENCES prestamos(id_prestamo)')();
  IntColumn get idCuota => integer().named('id_cuota')();

  DateTimeColumn get fechaVencimiento =>
      dateTime().named('fecha_vencimiento')();
  DateTimeColumn get fechaPagado =>
      dateTime().named('fecha_pagado').nullable()();
  RealColumn get montoInicial => real().named('monto_inicial')();
  RealColumn get montoPagado => real().named('monto_pagado')();
  RealColumn get montoACapital => real().named('monto_capital')();
  RealColumn get montoInteres => real().named('monto_interes')();
  IntColumn get diasMora =>
      integer().named('dias_mora').withDefault(const Constant(0))();
  RealColumn get montoMora => real().named('monto_mora')();
  RealColumn get montoExcedente => real().named('monto_excedente')();
  TextColumn get estadoAmortizacion =>
      textEnum<EstadoAmortizacion>().named('estado_amortizacion')();
  DateTimeColumn get fechaActualizacion => dateTime()
      .named('fecha_actualizacion')
      .clientDefault(() => DateTime.now())();
}

@DriftDatabase(
  tables: [Deudores, Scores, Prestamos, ConfiguracionPrestamos, Amortizaciones],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: false);

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (migrator, from, to) async {
        if (from == 1) {
          await customStatement(
            "UPDATE deudores SET fecha_creacion = CAST(strftime('%s', fecha_creacion) AS INTEGER), fecha_actualizacion = CAST(strftime('%s', fecha_actualizacion) AS INTEGER)",
          );
          await customStatement(
            "UPDATE scores SET fecha_creacion = CAST(strftime('%s', fecha_creacion) AS INTEGER)",
          );
          await customStatement(
            "UPDATE prestamos SET fecha_creacion = CAST(strftime('%s', fecha_creacion) AS INTEGER)",
          );
          await customStatement(
            "UPDATE configuracion_prestamos SET fecha_creacion = CAST(strftime('%s', fecha_creacion) AS INTEGER), fecha_actualizacion = CAST(strftime('%s', fecha_actualizacion) AS INTEGER)",
          );
          await customStatement(
            "UPDATE amortizaciones SET fecha_vencimiento = CAST(strftime('%s', fecha_vencimiento) AS INTEGER), fecha_pagado = CAST(strftime('%s', fecha_pagado) AS INTEGER), fecha_actualizacion = CAST(strftime('%s', fecha_actualizacion) AS INTEGER)",
          );
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'prestapago_db',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}
