import '../runtime_exception.dart';
import 'data_provider.dart';

class ExpressionResolver {
  dynamic evaluate(String expression, BusinessCardData data) {
    final trimmed = expression.trim();
    final parenIndex = trimmed.indexOf('(');
    if (parenIndex == -1) {
      return data.resolve(trimmed);
    }
    final funcName = trimmed.substring(0, parenIndex);
    final argsStr = trimmed.substring(parenIndex + 1, trimmed.length - 1);
    final args = _parseArgs(argsStr, data);
    return _applyFunction(funcName, args, data);
  }

  List<String> extractReferences(String expression) {
    final refs = <String>{};
    var buffer = StringBuffer();
    var depth = 0;
    for (var i = 0; i < expression.length; i++) {
      final ch = expression[i];
      if (ch == '(') {
        depth++;
        if (depth == 1) {
          buffer = StringBuffer();
          continue;
        }
      } else if (ch == ')') {
        depth--;
        if (depth == 0) {
          refs.add(buffer.toString().trim());
          buffer = StringBuffer();
          continue;
        }
      } else if (ch == ',' && depth == 1) {
        final arg = buffer.toString().trim();
        if (arg.isNotEmpty && !arg.contains('(')) {
          refs.add(arg);
        }
        buffer = StringBuffer();
        continue;
      }
      if (depth > 0) buffer.write(ch);
    }
    return refs.toList();
  }

  List<dynamic> _parseArgs(String argsStr, BusinessCardData data) {
    final args = <dynamic>[];
    var buffer = StringBuffer();
    var depth = 0;
    for (var i = 0; i < argsStr.length; i++) {
      final ch = argsStr[i];
      if (ch == '(') {
        depth++;
        buffer.write(ch);
      } else if (ch == ')') {
        depth--;
        buffer.write(ch);
      } else if (ch == ',' && depth == 0) {
        args.add(_resolveArg(buffer.toString().trim(), data));
        buffer = StringBuffer();
      } else {
        buffer.write(ch);
      }
    }
    final last = buffer.toString().trim();
    if (last.isNotEmpty) args.add(_resolveArg(last, data));
    return args;
  }

  dynamic _resolveArg(String arg, BusinessCardData data) {
    if (arg.contains('(')) return evaluate(arg, data);
    return data.resolve(arg);
  }

  dynamic _applyFunction(String name, List<dynamic> args, BusinessCardData data) {
    switch (name) {
      case 'uppercase':
        _requireArgCount(name, args, 1);
        return _toString(args[0]).toUpperCase();
      case 'lowercase':
        _requireArgCount(name, args, 1);
        return _toString(args[0]).toLowerCase();
      case 'concat':
        _requireMinArgs(name, args, 1);
        return args.map((a) => _toString(a)).join();
      case 'if':
        _requireArgCount(name, args, 2);
        return _isTruthy(args[0]) ? _toString(args[1]) : '';
      case 'default':
        _requireArgCount(name, args, 2);
        return _isTruthy(args[0]) ? _toString(args[0]) : _toString(args[1]);
      case 'trim':
        _requireArgCount(name, args, 1);
        return _toString(args[0]).trim();
      case 'length':
        _requireArgCount(name, args, 1);
        return _toString(args[0]).length;
      case 'substring':
        _requireMinArgs(name, args, 2);
        final str = _toString(args[0]);
        final start = _toInt(args[1], 0);
        final end = args.length > 2 ? _toInt(args[2], str.length) : str.length;
        return str.substring(start, end.clamp(0, str.length));
      case 'replace':
        _requireArgCount(name, args, 3);
        return _toString(args[0]).replaceAll(_toString(args[1]), _toString(args[2]));
      case 'contains':
        _requireArgCount(name, args, 2);
        return _toString(args[0]).contains(_toString(args[1]));
      case 'startsWith':
        _requireArgCount(name, args, 2);
        return _toString(args[0]).startsWith(_toString(args[1]));
      case 'endsWith':
        _requireArgCount(name, args, 2);
        return _toString(args[0]).endsWith(_toString(args[1]));
      case 'formatPhone':
        _requireArgCount(name, args, 1);
        return _formatPhone(_toString(args[0]));
      case 'formatEmail':
        _requireArgCount(name, args, 1);
        return _toString(args[0]).toLowerCase().trim();
      case 'formatUrl':
        _requireArgCount(name, args, 1);
        return _formatUrl(_toString(args[0]));
      case 'truncate':
        _requireArgCount(name, args, 2);
        final str = _toString(args[0]);
        final max = _toInt(args[1], str.length);
        return str.length > max ? '${str.substring(0, max)}...' : str;
      default:
        throw ExpressionEvaluationException(name, 'Unknown function: $name');
    }
  }

  void _requireArgCount(String name, List args, int count) {
    if (args.length != count) {
      throw ExpressionEvaluationException(
        name,
        'Expected $count argument(s), got ${args.length}',
      );
    }
  }

  void _requireMinArgs(String name, List args, int min) {
    if (args.length < min) {
      throw ExpressionEvaluationException(
        name,
        'Expected at least $min argument(s), got ${args.length}',
      );
    }
  }

  String _toString(dynamic value) => value?.toString() ?? '';

  int _toInt(dynamic value, int fallback) {
    if (value is num) return value.toInt();
    return int.tryParse(_toString(value)) ?? fallback;
  }

  bool _isTruthy(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final s = value.toString().trim().toLowerCase();
    return s != '' && s != 'false' && s != 'null';
  }

  String _formatPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    }
    if (digits.length == 11 && digits.startsWith('1')) {
      return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
    }
    if (digits.length > 11) {
      return '+${digits.substring(0, digits.length - 10)} (${digits.substring(digits.length - 10, digits.length - 7)}) ${digits.substring(digits.length - 7, digits.length - 4)}-${digits.substring(digits.length - 4)}';
    }
    return phone;
  }

  String _formatUrl(String url) {
    var result = url.trim();
    if (!result.startsWith('http://') && !result.startsWith('https://')) {
      result = 'https://$result';
    }
    return result;
  }
}
