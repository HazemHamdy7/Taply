class EmailFormatter {
  String format(String email) {
    final trimmed = email.trim();
    if (!trimmed.contains('@')) return trimmed;
    final parts = trimmed.split('@');
    if (parts.length != 2) return trimmed;
    final local = parts[0].toLowerCase();
    final domain = parts[1].toLowerCase();
    return '$local@$domain';
  }

  bool isValid(String email) {
    final pattern = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return pattern.hasMatch(email.trim());
  }

  String mask(String email) {
    final trimmed = email.trim();
    if (!trimmed.contains('@')) return trimmed;
    final parts = trimmed.split('@');
    final local = parts[0];
    final domain = parts[1];
    if (local.length <= 2) return '$local@$domain';
    return '${local[0]}${'*' * (local.length - 2)}${local[local.length - 1]}@$domain';
  }
}
