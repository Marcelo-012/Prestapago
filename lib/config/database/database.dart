import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:prestapagos/domain/entities/entities.dart';

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
  TextColumn get estado => textEnum<Status>()();
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
      .customConstraint('REFERENCES deudores(id_deudor)')();
  RealColumn get score => real()();
  DateTimeColumn get fechaCreacion =>
      dateTime().named('fecha_creacion').clientDefault(() => DateTime.now())();
}

class TasasIntereses extends Table {
  IntColumn get id => integer().named('id_tasa_interes').autoIncrement()();
  TextColumn get nombre => text().withLength(max: 35)();
  RealColumn get tasa => real()();
  TextColumn get tipoInteres =>
      textEnum<TiposInteres>().named('tipo_interes')();
  TextColumn get descripcion => text().withLength(max: 150).nullable()();
  TextColumn get estado => textEnum<Status>()();
  DateTimeColumn get fechaCreacion =>
      dateTime().named('fecha_creacion').clientDefault(() => DateTime.now())();
  DateTimeColumn get fechaActualizacion => dateTime()
      .named('fecha_actualizacion')
      .clientDefault(() => DateTime.now())();
}

class Prestamos extends Table {
  IntColumn get id => integer().named('id_prestamo').autoIncrement()();
  IntColumn get idDeudor => integer()
      .named('id_deudor')
      .customConstraint('REFERENCES deudores(id_deudor)')();
  IntColumn get idTasaInteres => integer()
      .named('id_tasa_interes')
      .customConstraint('REFERENCES tasas_intereses(id_tasa_interes)')();
  IntColumn get idTasaMoratoria => integer()
      .named('id_tasa_interes_moratoria')
      .customConstraint('REFERENCES tasas_intereses(id_tasa_interes)')();
  RealColumn get monto => real().nullable()();
  IntColumn get plazoMeses => integer().named('plazo_meses')();
  RealColumn get montoCuota => real().named('monto_cuota')();
  DateTimeColumn get fechaCreacion =>
      dateTime().named('fecha_creacion').clientDefault(() => DateTime.now())();
}

class ConfiguracionPrestamos extends Table {
  IntColumn get id => integer().named('id_configuracion').autoIncrement()();
  IntColumn get idPrestamo => integer()
      .named('id_prestamo')
      .customConstraint('REFERENCES prestamos(id_prestamo)')();
  TextColumn get tipoInteres =>
      textEnum<TiposInteres>().named('tipo_interes')();
  TextColumn get estadoMoratorio =>
      textEnum<Status>().named('estado_moratorio')();
  TextColumn get manejoExcedente =>
      textEnum<ManejoExcedente>().named('manejo_excedente')();
  TextColumn get periodidadIntereses =>
      textEnum<PeriodidadIntereses>().named('periodidad_intereses')();
  TextColumn get estadoPrestamo =>
      textEnum<Status>().named('estado_prestamo')();
  DateTimeColumn get fechaCreacion =>
      dateTime().named('fecha_creacion').clientDefault(() => DateTime.now())();
}

class Pagos extends Table {
  IntColumn get id => integer().named('id_pago').autoIncrement()();
  IntColumn get idPrestamo => integer()
      .named('id_prestamo')
      .customConstraint('REFERENCES prestamos(id_prestamo)')();
  IntColumn get idCuota => integer().named('id_cuota')();

  DateTimeColumn get fechaPago => dateTime().named('fecha_pago')();
  RealColumn get montoInicial => real().named('monto_inicial')();
  RealColumn get montoPagado => real().named('monto_pagado')();
  RealColumn get montoACapital => real().named('monto_capital')();
  RealColumn get montoInteres => real().named('monto_interes')();
  IntColumn get diasMora =>
      integer().named('dias_mora').withDefault(const Constant(0))();
  RealColumn get montoMora => real().named('monto_mora')();
  RealColumn get montoExcedente => real().named('monto_excedente')();
  DateTimeColumn get fechaCreacion =>
      dateTime().named('fecha_creacion').clientDefault(() => DateTime.now())();
}

@DriftDatabase(
  tables: [
    Deudores,
    Scores,
    TasasIntereses,
    Prestamos,
    ConfiguracionPrestamos,
    Pagos,
  ],
)
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}
