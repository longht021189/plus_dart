part of '../Operators.dart';

class _Debounce<T> extends Stream<T> {
  @override
  StreamSubscription<T> listen(void Function(T event) onData, {Function onError, void Function() onDone, bool cancelOnError}) {
    return _DebounceSubscription();
  }
}

class _DebounceSubscription<T> implements StreamSubscription<T> {
  @override
  Future<E> asFuture<E>([E futureValue]) {
    throw UnimplementedError();
  }

  @override
  Future cancel() {
    throw UnimplementedError();
  }

  @override
  bool get isPaused => throw UnimplementedError();

  @override
  void onData(void Function(T data) handleData) {
    throw UnimplementedError();
  }

  @override
  void onDone(void Function() handleDone) {
    throw UnimplementedError();
  }

  @override
  void onError(Function handleError) {
    throw UnimplementedError();
  }

  @override
  void pause([Future resumeSignal]) {
    throw UnimplementedError();
  }

  @override
  void resume() {
    throw UnimplementedError();
  }
}