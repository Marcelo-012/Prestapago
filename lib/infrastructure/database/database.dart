import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:prestapagos/domain/domain.dart';

part 'database.g.dart';

class Deudores extends Table {
  IntColumn get id => integer().named('id_deudor').autoIncrement()();
  TextColumn get nombre => text().withLength(max: 45)();
  TextColumn get telefono => text().withLength(max: 10)();
  TextColumn get correoElectronico =>
      text().named('email').withLength(min: 1, max: 60).unique().nullable()();
  TextColumn get direccion => text().withLength(min: 1, max: 150)();
  TextColumn get numeroIdentificacion =>
      text().named('numero_identificacion').withLength(min: 1, max: 30).unique()();
  IntColumn get edad => integer()();
  TextColumn get estado => textEnum<EstadoCliente>()();
  DateTimeColumn get fechaCreacion =>
      dateTime().named('fecha_creacion').clientDefault(() => DateTime.now())();
  DateTimeColumn get fechaActualizacion => dateTime()
      .named('fecha_actualizacion')
      .clientDefault(() => DateTime.now())();
}

class Scores extends Table {
  IntColumn get idPrestamo => integer()
      .named('id_prestamo')
      .customConstraint('NOT NULL REFERENCES prestamos(id_prestamo)')();
  IntColumn get idDeudor => integer()
      .named('id_deudor')
      .customConstraint('NOT NULL REFERENCES deudores(id_deudor)')();
  RealColumn get score => real()();
  DateTimeColumn get fechaCreacion =>
      dateTime().named('fecha_creacion').clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {idPrestamo};
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
  TextColumn get motivoCancelacion =>
      text().named('motivo_cancelacion').nullable()();
  RealColumn get montoDevuelto =>
      real().named('monto_devuelto').withDefault(const Constant(0.0))();
  TextColumn get motivoCastigo =>
      text().named('motivo_castigo').nullable()();
  RealColumn get montoPerdido =>
      real().named('monto_perdido').withDefault(const Constant(0.0))();
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
  int get schemaVersion => 5;

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
        if (from <= 2) {
          await customStatement("""
            UPDATE amortizaciones SET
              monto_inicial = (
                SELECT p.monto - COALESCE(SUM(prev.monto_capital), 0)
                FROM prestamos p
                LEFT JOIN amortizaciones prev
                  ON prev.id_prestamo = p.id_prestamo
                  AND prev.id_cuota < amortizaciones.id_cuota
                WHERE p.id_prestamo = amortizaciones.id_prestamo
              )
          """);
        }
        if (from <= 3) {
          await customStatement("DROP TABLE IF EXISTS scores");
          await customStatement("""
            CREATE TABLE scores (
              id_prestamo INTEGER NOT NULL PRIMARY KEY REFERENCES prestamos(id_prestamo),
              id_deudor INTEGER NOT NULL REFERENCES deudores(id_deudor),
              score REAL NOT NULL DEFAULT 0,
              fecha_creacion INTEGER NOT NULL DEFAULT (CAST(strftime('%s', 'now') AS INTEGER))
            )
          """);
          await customStatement("""
            INSERT INTO scores (id_prestamo, id_deudor, score, fecha_creacion)
            SELECT
              cp.id_prestamo,
              p.id_deudor,
              ROUND(
                CAST(SUM(CASE WHEN a.dias_mora = 0 THEN 1 ELSE 0 END) AS REAL)
                / CAST(COUNT(*) AS REAL)
                * 100
              ) AS score,
              CAST(strftime('%s', 'now') AS INTEGER)
            FROM configuracion_prestamos cp
            INNER JOIN prestamos p ON cp.id_prestamo = p.id_prestamo
            INNER JOIN amortizaciones a ON a.id_prestamo = p.id_prestamo
            WHERE cp.estado_prestamo = 'finalizado'
            GROUP BY cp.id_prestamo
          """);
        }
        if (from <= 4) {
          await customStatement("ALTER TABLE configuracion_prestamos ADD COLUMN motivo_cancelacion TEXT");
          await customStatement("ALTER TABLE configuracion_prestamos ADD COLUMN monto_devuelto REAL NOT NULL DEFAULT 0");
          await customStatement("ALTER TABLE configuracion_prestamos ADD COLUMN motivo_castigo TEXT");
          await customStatement("ALTER TABLE configuracion_prestamos ADD COLUMN monto_perdido REAL NOT NULL DEFAULT 0");
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'prestapago_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
