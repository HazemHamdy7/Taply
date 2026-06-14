/// Lifecycle state of a [CardRuntime].
enum CardState {
  /// Runtime is idle, not yet initialized.
  idle,

  /// Runtime is loading data.
  loading,

  /// Runtime is ready for rendering.
  ready,

  /// Runtime has been disposed.
  disposed,
}
