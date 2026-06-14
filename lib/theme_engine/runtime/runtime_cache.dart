import 'dart:ui' as ui;

class RuntimeCache {
  final Map<String, dynamic> _data = {};
  final Map<String, ui.Image> _images = {};
  final int maxEntries;

  RuntimeCache({this.maxEntries = 100});

  void set(String key, dynamic value) {
    if (_data.length >= maxEntries) _evict();
    _data[key] = value;
  }

  dynamic get(String key) => _data[key];

  bool contains(String key) => _data.containsKey(key);

  void remove(String key) {
    _data.remove(key);
    _images.remove(key);
  }

  void cacheImage(String key, ui.Image image) {
    if (_images.length >= maxEntries) _evictImage();
    _images[key] = image;
  }

  ui.Image? getImage(String key) => _images[key];

  bool hasImage(String key) => _images.containsKey(key);

  void invalidateAll() {
    _data.clear();
    for (final img in _images.values) {
      img.dispose();
    }
    _images.clear();
  }

  void _evict() {
    final key = _data.keys.first;
    _data.remove(key);
  }

  void _evictImage() {
    final key = _images.keys.first;
    final img = _images.remove(key);
    img?.dispose();
  }

  Map<String, dynamic> snapshot() => Map.from(_data);
}
