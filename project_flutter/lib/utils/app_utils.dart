import 'package:intl/intl.dart';

class AppUtils {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatNumber(int number) {
    final format = NumberFormat.compact(locale: 'id_ID');
    return format.format(number);
  }
}
