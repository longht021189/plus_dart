import 'dart:core';
import 'dart:async';

part 'operators/SwitchMap.dart';
part 'operators/Debounce.dart';
part 'operators/Merge.dart';

extension Operators<T> on Stream<T> {

  Stream<T> debounce(Duration duration) {
    return _Debounce();
  }

  Stream<E> switchStream<E>(Stream<E> mapper(T)) {
    return _SwitchMap();
  }

  Stream<E> switchFuture<E>(Future<E> mapper(T)) {
    throw UnimplementedError();
  }

  static Stream<T> merge(Iterable<Stream<T>> streams, { bool sameCancelSignal = true }) {
    return _Merge(streams, sameCancelSignal);
  }
}