class SemverUtils {
  SemverUtils._();

  static List<int> parse(String version) {
    final cleaned = version.split('-')[0];
    return cleaned.split('.').map((s) => int.tryParse(s) ?? 0).toList();
  }

  static int compare(String a, String b) {
    final partsA = parse(a);
    final partsB = parse(b);
    final maxLen = partsA.length > partsB.length ? partsA.length : partsB.length;
    for (var i = 0; i < maxLen; i++) {
      final va = i < partsA.length ? partsA[i] : 0;
      final vb = i < partsB.length ? partsB[i] : 0;
      if (va != vb) return va.compareTo(vb);
    }
    return 0;
  }

  static bool satisfies(String version, String constraint) {
    if (constraint == '*' || constraint == 'any') return true;
    final parts = parse(version);
    final constParts = parse(constraint);
    if (constParts.length != parts.length) return false;
    for (var i = 0; i < parts.length; i++) {
      if (parts[i] < constParts[i]) return false;
    }
    return true;
  }

  static bool isCompatible(String actual, String minimum) {
    final a = parse(actual);
    final m = parse(minimum);
    if (a.isEmpty || m.isEmpty) return false;
    return a[0] == m[0] && (a[1] >= m[1]);
  }
}
