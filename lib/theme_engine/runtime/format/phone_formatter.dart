class PhoneFormatter {
  String format(String phone, {String locale = 'en'}) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return phone;

    switch (locale) {
      case 'en':
        return _formatUS(digits);
      case 'fr':
        return _formatFR(digits);
      case 'de':
        return _formatDE(digits);
      case 'ar':
        return _formatInternational(digits);
      default:
        return _formatInternational(digits);
    }
  }

  String _formatUS(String digits) {
    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    }
    if (digits.length == 11 && digits.startsWith('1')) {
      return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
    }
    return _formatInternational(digits);
  }

  String _formatFR(String digits) {
    final clean = digits.length > 10 ? digits.substring(digits.length - 9) : digits;
    final parts = <String>[];
    for (var i = 0; i < clean.length; i += 2) {
      parts.add(clean.substring(i, (i + 2).clamp(0, clean.length)));
    }
    return '+33 ${parts.join(' ')}';
  }

  String _formatDE(String digits) {
    final clean = digits.length > 11 ? digits.substring(digits.length - 10) : digits;
    return '+49 ${clean.substring(0, 2)} ${clean.substring(2, 5)} ${clean.substring(5)}';
  }

  String _formatInternational(String digits) {
    if (digits.length <= 4) return digits;
    final parts = <String>[];
    for (var i = 0; i < digits.length; i += 3) {
      parts.add(digits.substring(i, (i + 3).clamp(0, digits.length)));
    }
    return '+${parts.join(' ')}';
  }
}
