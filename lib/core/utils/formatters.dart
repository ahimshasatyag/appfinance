import 'package:intl/intl.dart';

class Formatters {
  /// Format angka menjadi format mata uang dengan pemisah ribuan titik (.000)
  /// Contoh: $10.000 atau Rp10.000
  static String formatCurrency(double amount, {String symbol = 'Rp '}) {
    // locale 'id_ID' secara bawaan menggunakan titik sebagai pemisah ribuan
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: symbol,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format angka dengan pemisah ribuan titik tanpa simbol mata uang
  /// Contoh: 10.000
  static String formatNumber(double amount) {
    final formatter = NumberFormat.decimalPattern('id_ID');
    return formatter.format(amount);
  }

  /// Format tanggal
  /// Contoh: 07 Oct 2023
  static String formatDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  /// Format tanggal dan jam
  /// Contoh: 07 Oct 2023, 14:30
  static String formatDateTime(DateTime date, {String format = 'dd MMM yyyy, HH:mm'}) {
    return DateFormat(format).format(date);
  }
}
