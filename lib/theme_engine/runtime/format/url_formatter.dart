class UrlFormatter {
  String format(String url) {
    var result = url.trim().toLowerCase();
    if (!result.startsWith('http://') && !result.startsWith('https://')) {
      result = 'https://$result';
    }
    return result;
  }

  String displayUrl(String url) {
    var result = url.trim();
    result = result.replaceFirst(RegExp(r'^https?://'), '');
    if (result.startsWith('www.')) {
      result = result.substring(4);
    }
    if (result.endsWith('/')) {
      result = result.substring(0, result.length - 1);
    }
    return result;
  }

  String extractDomain(String url) {
    final formatted = format(url);
    final uri = Uri.tryParse(formatted);
    return uri?.host ?? url;
  }

  bool isValid(String url) {
    final formatted = format(url);
    return Uri.tryParse(formatted)?.hasScheme ?? false;
  }
}
