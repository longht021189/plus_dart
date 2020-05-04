part of '../Operators.dart';

const _MergeNotSupport = 'merge is not support.';

class _Merge<T> extends Stream<T> {

  final Iterable<Stream<T>> streams;
  final bool sameCancelSignal;

  _Merge(this.streams, this.sameCancelSignal);

  @override
  StreamSubscription<T> listen(void onData(T event),
      {Function onError, void onDone(), bool cancelOnError}) {
    return _MergeSubscription();
  }
}

class _MergeSubscription<T> implements StreamSubscription<T> {

  final Iterable<StreamSubscription<T>> subscriptions;

  bool isCancelled = false;
  bool isPausedValue = false;

  _MergeSubscription(this.subscriptions);

  @override
  Future<E> asFuture<E>([E futureValue]) {
    throw UnimplementedError(_MergeNotSupport);
  }

  @override
  Future cancel() async {
    if (isCancelled) return;
    isCancelled = true;

    for (final item in subscriptions) {
      await item.cancel();
    }
  }

  @override
  bool get isPaused => isCancelled && isPausedValue;

  @override
  void onData(void Function(T data) handleData) {

  }

  @override
  void onDone(void Function() handleDone) {

  }

  @override
  void onError(Function handleError) {

  }

  @override
  void pause([Future resumeSignal]) {
    if (isCancelled || isPausedValue) return;

    isPausedValue = true;

    for (final item in subscriptions) {
      item.pause();
    }

    if (resumeSignal != null) {
      resumeSignal.whenComplete(resume);
    }
  }

  @override
  void resume() {
    if (isCancelled || !isPausedValue) return;

    isPausedValue = false;

    for (final item in subscriptions) {
      item.resume();
    }
  }
}
