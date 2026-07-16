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

  static String shortMonth(DateTime date) {
    return DateFormat.MMM('es_MX').format(date);
  }

  static String nameMonth(String mesYYYYMM) {
    final parts = mesYYYYMM.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final date = DateTime(year, month);
    return HumanFormats.month(date);
  }

  static String shortNameMonth(String mesYYYYMM) {
    final parts = mesYYYYMM.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final date = DateTime(year, month);
    return HumanFormats.shortMonth(date);
  }

  static String dayOfWeek(String numeroDia) {
    final index = int.parse(numeroDia); // 0-6
    final fecha = DateTime(2026, 1, 4 + index); // domingo es 4 de enero 2026
    return DateFormat.E('es_MX').format(fecha); // "lun", "mar", "mié", etc.
  }

  static String date(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'es_MX').format(date);
  }

  static String dateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm', 'es_MX').format(date);
  }
}
