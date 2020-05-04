import 'dart:core';
import 'dart:async';

part 'operators/SwitchMap.dart';
part 'operators/Debounce.dart';

extension Operators<T> on Stream<T> {
  Stream<T> debounce(Duration duration) {
    return _Debounce();
  }

  Stream<E> switchMap<E>(Stream<E> mapper(T)) {
    return _SwitchMap();
  }
}