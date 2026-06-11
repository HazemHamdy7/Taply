import 'dart:ui' show Rect;

/// Configurable paint result cache.
///
/// Caches paint results keyed by node id. Supports configurable
/// maximum capacity and optional TTL-based expiry.
class PaintCache {
  final int maxEntries;
  final Duration? ttl;
  final Map<String, _CacheEntry> _cache = {};
  final List<String> _accessOrder = [];

  PaintCache({this.maxEntries = 100, this.ttl});

  bool contains(String nodeId) {
    final entry = _cache[nodeId];
    if (entry == null) return false;
    if (ttl != null && DateTime.now().difference(entry.timestamp) > ttl!) {
      _cache.remove(nodeId);
      _accessOrder.remove(nodeId);
      return false;
    }
    return true;
  }

  Rect? get(String nodeId) {
    final entry = _cache[nodeId];
    if (entry == null) return null;
    if (ttl != null && DateTime.now().difference(entry.timestamp) > ttl!) {
      _cache.remove(nodeId);
      _accessOrder.remove(nodeId);
      return null;
    }
    _touch(nodeId);
    return entry.bounds;
  }

  void set(String nodeId, Rect? bounds) {
    if (_cache.length >= maxEntries && !_cache.containsKey(nodeId)) {
      _evict();
    }
    _cache[nodeId] = _CacheEntry(
      bounds: bounds,
      timestamp: DateTime.now(),
    );
    _touch(nodeId);
  }

  void invalidate(String nodeId) {
    _cache.remove(nodeId);
    _accessOrder.remove(nodeId);
  }

  void invalidateAll() {
    _cache.clear();
    _accessOrder.clear();
  }

  int get count => _cache.length;

  void _touch(String nodeId) {
    _accessOrder.remove(nodeId);
    _accessOrder.add(nodeId);
  }

  void _evict() {
    if (_accessOrder.isNotEmpty) {
      final oldest = _accessOrder.removeAt(0);
      _cache.remove(oldest);
    }
  }
}

class _CacheEntry {
  final Rect? bounds;
  final DateTime timestamp;

  const _CacheEntry({this.bounds, required this.timestamp});
}
