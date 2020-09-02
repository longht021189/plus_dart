abstract class IStore {
  bool get isClosed;
  Stream<T> getStream<T>([String key]);
  Future sendAction(dynamic value);
  Future close();
}