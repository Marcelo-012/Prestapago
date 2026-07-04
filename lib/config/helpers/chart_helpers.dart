/// Helpers para cálculos de ejes en gráficas fl_chart
/// Sigue SOLID: Single Responsibility Principle - cada método hace una sola cosa
class ChartHelpers {
  /// Calcula minY, maxY e intervalo del eje Y de forma estética.
  ///
  /// Orquesta el cálculo completo del eje Y:
  /// 1. Calcula un intervalo "bonito" (1, 2, 2.5, 5, 10, etc.)
  /// 2. Redondea los límites a múltiplos de ese intervalo
  /// 3. Opcionalmente fuerza minY a 0 si no hay valores negativos
  ///
  /// Parámetros:
  /// - [valores]: lista de valores numéricos de la gráfica
  /// - [forzarMinCero]: si true y todos los valores son >=0, minY=0.
  ///   Si false, calcula un mínimo estético con margen (útil para tendencias)
  ///
  /// Retorna:
  /// - [minY]: límite inferior del eje (redondeado)
  /// - [maxY]: límite superior del eje (redondeado)
  /// - [interval]: espaciado entre etiquetas del eje
  ///
  /// Ejemplo:
  /// ```dart
  /// final config = ChartHelpers.calcularEjeY([1500, 2300, 3100, 2800]);
  /// // Resultado: (minY: 0.0, maxY: 3500.0, interval: 500.0)
  /// ```
  static ({double minY, double maxY, double interval}) calcularEjeY(
    List<double> valores, {
    bool forzarMinCero = true,
  }) {
    if (valores.isEmpty) {
      return (minY: 0.0, maxY: 10.0, interval: 2.0);
    }

    final maxValor = valores.reduce((a, b) => a > b ? a : b);
    final minValor = valores.reduce((a, b) => a < b ? a : b);

    // Edge case: todos los valores son iguales
    if (maxValor == minValor) {
      final base = maxValor == 0 ? 10.0 : maxValor;
      return (minY: 0.0, maxY: base, interval: base / 5);
    }

    // Responsabilidad 1: calcular intervalo "bonito" basado en el rango
    final rango = maxValor - minValor;
    final interval = _calcularInterval(rango);

    // Responsabilidad 2: redondear los límites al intervalo
    double minY = (minValor / interval).floorToDouble() * interval;
    double maxY = (maxValor / interval).ceilToDouble() * interval;

    // Responsabilidad 3: aplicar reglas de negocio (forzarMinCero)
    if (minValor >= 0 && forzarMinCero) {
      minY = 0.0;
    }

    // Evitar que minY == maxY (caso extremo muy raro)
    if (minY == maxY) {
      maxY += interval;
    }

    return (minY: minY, maxY: maxY, interval: interval);
  }

  /// Calcula un intervalo "bonito" para dividir uniformemente un rango.
  ///
  /// Responsabilidad única: dado un rango numérico, retorna un intervalo
  /// que sea una "unidad natural" (1, 2, 2.5, 5, 10 × potencia de 10).
  ///
  /// Internamente:
  /// 1. Divide el rango por ~5 (queremos ~5 divisiones)
  /// 2. Extrae la magnitud (potencia de 10)
  /// 3. Redondea a candidatos "bonitos"
  /// 4. Restaura la magnitud
  ///
  /// Parámetro:
  /// - [rango]: la diferencia entre el máximo y mínimo valor
  ///
  /// Retorna:
  /// - intervalo "bonito" que divide el rango en ~5 partes iguales
  ///
  /// Ejemplo:
  /// ```dart
  /// _calcularIntervalBonito(3100) → 500.0 (porque 3100/5 ≈ 620, redondea a 500)
  /// _calcularIntervalBonito(15000) → 2000.0
  /// ```
  static double _calcularInterval(double rango) {
    if (rango == 0) return 1.0;

    // Queremos ~5 divisiones
    final rawInterval = rango / 5;
    final magnitud = _magnitudDe(rawInterval);
    final normalizado = rawInterval / magnitud;

    // Candidatos "bonitos": 1, 2, 2.5, 5, 10
    const candidatos = [1.0, 2.0, 2.5, 5.0, 10.0];
    final intervalNormalizado = candidatos.firstWhere(
      (c) => normalizado <= c,
      orElse: () => 10.0,
    );

    return intervalNormalizado * magnitud;
  }

  /// Extrae la magnitud (potencia de 10) de un número.
  ///
  /// Responsabilidad única: dado un número, retorna su magnitud de orden
  /// (la potencia de 10 en la que "vive").
  ///
  /// Algoritmo: normaliza el número al rango [1, 10) y calcula cuántas
  /// potencias de 10 se necesitaban para llegar ahí.
  ///
  /// Ejemplos:
  /// - 567 → 100 (vive en el rango 100–999)
  /// - 3.4 → 1 (vive en el rango 1–9.9)
  /// - 0.045 → 0.01 (vive en el rango 0.01–0.099)
  /// - 0 → 1 (por defecto)
  static double _magnitudDe(double valor) {
    if (valor == 0) return 1;

    var magnitud = 1.0;
    var v = valor.abs();

    // Divide por 10 hasta que esté en [1, 10)
    while (v >= 10) {
      v /= 10;
      magnitud *= 10;
    }

    // Multiplica por 10 hasta que esté en [1, 10)
    while (v < 1) {
      v *= 10;
      magnitud /= 10;
    }

    return magnitud;
  }
}
