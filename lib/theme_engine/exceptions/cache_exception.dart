/// Exception thrown when a cache read/write operation fails.
class CacheException implements Exception {
  /// Creates a [CacheException] with an optional [message] and [cacheKey].
  const CacheException([
    this.message,
    this.cacheKey,
  ]);

  /// A human-readable description of the cache error.
  final String? message;

  /// The cache key involved in the failure.
  final String? cacheKey;

  @override
  String toString() {
    final buf = StringBuffer('CacheException');
    if (cacheKey != null) buf.write(' for key "$cacheKey"');
    if (message != null) buf.write(': $message');
    return buf.toString();
  }
}
