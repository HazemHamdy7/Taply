import 'dart:io' as io show File, HttpClient;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart' show rootBundle;

import '../runtime_cache.dart';
import '../runtime_exception.dart';

enum AvatarSource { asset, file, memory, network }

class AvatarRuntime {
  final RuntimeCache? cache;

  AvatarRuntime({this.cache});

  Future<ui.Image> loadAvatar(
    String source, {
    AvatarSource type = AvatarSource.network,
    double size = 200,
    bool useCache = true,
  }) async {
    final cacheKey = 'avatar_${source.hashCode}_${size}';

    if (useCache && cache != null) {
      final cached = cache!.getImage(cacheKey);
      if (cached != null) return cached;
    }

    ui.Image image;
    switch (type) {
      case AvatarSource.asset:
        image = await _loadFromAsset(source, size);
      case AvatarSource.file:
        image = await _loadFromFile(source, size);
      case AvatarSource.memory:
        image = await _loadFromMemory(source, size);
      case AvatarSource.network:
        image = await _loadFromNetwork(source, size);
    }

    if (useCache && cache != null) {
      cache!.cacheImage(cacheKey, image);
    }

    return image;
  }

  Future<ui.Image> loadAvatarFromBytes(
    Uint8List bytes, {
    double size = 200,
    bool useCache = true,
  }) async {
    final cacheKey = 'avatar_bytes_${bytes.hashCode}_${size}';

    if (useCache && cache != null) {
      final cached = cache!.getImage(cacheKey);
      if (cached != null) return cached;
    }

    final codec = await ui.instantiateImageCodec(bytes, targetWidth: size.toInt());
    final frame = await codec.getNextFrame();
    final image = frame.image;

    if (useCache && cache != null) {
      cache!.cacheImage(cacheKey, image);
    }

    return image;
  }

  Future<ui.Image> _loadFromAsset(String path, double size) async {
    try {
      final data = await rootBundle.load(path);
      final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: size.toInt(),
      );
      final frame = await codec.getNextFrame();
      return frame.image;
    } catch (e) {
      throw AvatarLoadException('asset($path)', e.toString());
    }
  }

  Future<ui.Image> _loadFromFile(String path, double size) async {
    try {
      final file = io.File(path);
      final data = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(data, targetWidth: size.toInt());
      final frame = await codec.getNextFrame();
      return frame.image;
    } catch (e) {
      throw AvatarLoadException('file($path)', e.toString());
    }
  }

  Future<ui.Image> _loadFromMemory(String path, double size) async {
    try {
      final base64Data = path;
      final data = _decodeBase64(base64Data);
      final codec = await ui.instantiateImageCodec(data, targetWidth: size.toInt());
      final frame = await codec.getNextFrame();
      return frame.image;
    } catch (e) {
      throw AvatarLoadException('memory', e.toString());
    }
  }

  Future<ui.Image> _loadFromNetwork(String url, double size) async {
    try {
      final httpClient = _HttpClient();
      final data = await httpClient.get(url);
      final codec = await ui.instantiateImageCodec(data, targetWidth: size.toInt());
      final frame = await codec.getNextFrame();
      return frame.image;
    } catch (e) {
      throw AvatarLoadException('network($url)', e.toString());
    }
  }

  Uint8List _decodeBase64(String data) {
    return Uint8List.fromList(
      _base64Chars.decode(data),
    );
  }

  static const _base64Chars = _Base64Decoder();
}

class _Base64Decoder {
  const _Base64Decoder();

  List<int> decode(String input) {
    final clean = input.replaceAll(RegExp(r'\s+'), '');
    final decoded = <int>[];
    var buffer = 0;
    var bitsCollected = 0;

    for (var i = 0; i < clean.length; i++) {
      final c = clean.codeUnitAt(i);
      if (c == 0x3D) break;
      int value;
      if (c >= 0x41 && c <= 0x5A) {
        value = c - 0x41;
      } else if (c >= 0x61 && c <= 0x7A) {
        value = c - 0x61 + 26;
      } else if (c >= 0x30 && c <= 0x39) {
        value = c - 0x30 + 52;
      } else if (c == 0x2B) {
        value = 62;
      } else if (c == 0x2F) {
        value = 63;
      } else {
        continue;
      }

      buffer = (buffer << 6) | value;
      bitsCollected += 6;

      if (bitsCollected >= 8) {
        bitsCollected -= 8;
        decoded.add((buffer >> bitsCollected) & 0xFF);
        buffer &= (1 << bitsCollected) - 1;
      }
    }

    return decoded;
  }
}

class _HttpClient {
  Future<Uint8List> get(String url) async {
    final uri = Uri.parse(url);
    if (uri.scheme == 'data') {
      final parts = uri.path.split(',');
      if (parts.length >= 2) {
        final encoded = parts.sublist(1).join(',');
        return Uint8List.fromList(
          _Base64Decoder().decode(encoded),
        );
      }
    }

    final client = io.HttpClient();
    final request = await client.getUrl(uri);
    final response = await request.close();
    final bytes = <int>[];
    await for (final chunk in response) {
      bytes.addAll(chunk);
    }
    client.close();
    return Uint8List.fromList(bytes);
  }
}
