import 'package:intl/intl.dart';

class HumanFormats {
  static String monuted(double? number) {
    final formatterToMounted = NumberFormat.currency(
      //locale: 'es_MX',
      symbol: '\$',
      decimalDigits: 2,
    ).format(number);
    return formatterToMounted;
  }

  static String month(DateTime date) {
    final formatterToMounth = DateFormat.MMMM('es_MX').format(date);
    return formatterToMounth;
  }

  static String nameMonth(String mesYYYYMM) {
    final parts = mesYYYYMM.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final date = DateTime(year, month);
    return HumanFormats.month(date);
  }

  static String dayOfWeek(String numeroDia) {
    final index = int.parse(numeroDia); // 0-6
    final fecha = DateTime(2026, 1, 4 + index); // domingo es 4 de enero 2026
    return DateFormat.EEEE('es_MX').format(fecha); // "lunes", "martes", etc.
  }

  static String date(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'es_MX').format(date);
  }
}
