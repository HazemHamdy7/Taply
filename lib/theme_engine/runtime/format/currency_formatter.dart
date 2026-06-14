class CurrencyFormatter {
  String format(num amount, {String locale = 'en', String currency = 'USD'}) {
    final symbol = _currencySymbol(currency);
    final formatted = _formatNumber(amount, locale);
    return '$symbol$formatted';
  }

  String formatWithCode(num amount, {String locale = 'en', String currency = 'USD'}) {
    final symbol = _currencySymbol(currency);
    final formatted = _formatNumber(amount, locale);
    return '$symbol$formatted $currency';
  }

  String _currencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD': return '\$';
      case 'EUR': return '€';
      case 'GBP': return '£';
      case 'JPY': return '¥';
      case 'CNY': return '¥';
      case 'SAR': return '﷼';
      case 'AED': return 'د.إ';
      case 'EGP': return 'E£';
      default: return '\$';
    }
  }

  String _formatNumber(num amount, String locale) {
    final isNegative = amount < 0;
    final abs = isNegative ? -amount : amount;
    final parts = abs.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    final buffer = StringBuffer();
    if (isNegative) buffer.write('-');
    var count = 0;
    for (var i = intPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
      count++;
    }
    return '${buffer.toString().split('').reversed.join()}.$decPart';
  }
}
