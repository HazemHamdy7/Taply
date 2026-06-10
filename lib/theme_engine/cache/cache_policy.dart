/// Defines cache eviction and TTL policies.
class CachePolicy {
  /// The entry TTL in seconds.
  final int ttlSeconds;

  /// The maximum number of entries.
  final int maxEntries;

  /// Whether to evict the least-recently-used entry when full.
  final bool lruEviction;

  /// Creates a [CachePolicy].
  const CachePolicy({
    this.ttlSeconds = 300,
    this.maxEntries = 20,
    this.lruEviction = true,
  });
}
