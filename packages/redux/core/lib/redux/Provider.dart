import 'dart:async';
import 'dart:collection';

import 'package:plus_redux/redux.dart';

abstract class ReducerProvider<State, Action, T extends Reducer<State, Action>> {
  final T _reducer;
  final StreamController<Action> _streamAction;
  final StreamController<State> _streamState;
  final bool _autoCancelWhenNoSubscription;
  final Set<StreamSubscription> _subscriptionList;

  Stream<State> _stream;
  StreamSubscription _subscription;
  bool _isClosed = false;
  State _currentState;

  State get state => _currentState;
  Stream<State> get stream => _stream;
  bool get isClosed => _isClosed;

  ReducerProvider(T reducer, { bool isLocal = false })
      : _streamAction = StreamController()
      , _streamState = StreamController()
      , _reducer = reducer
      , _autoCancelWhenNoSubscription = isLocal
      , _subscriptionList = isLocal ? HashSet() : null
  {
    _currentState = reducer.initialState;
    _streamState.add(_currentState);
    _stream = _streamState.stream
        .asBroadcastStream(onListen: _onListen, onCancel: _onCancel);

    _subscription = _streamAction
        .stream
        .asyncMap(_onUpdate)
        .listen((state) {
          _currentState = state;
          _streamState.add(state);
        });
  }

  Future _onUpdate(Action value) async {
    return await _reducer.onUpdate(_currentState, value);
  }

  _onListen(StreamSubscription<State> subscription) {
    if (_isClosed) {
      subscription.cancel();
    }
    if (_subscriptionList != null) {
      _subscriptionList.add(subscription);
    }
  }

  _onCancel(StreamSubscription<State> subscription) {
    if (_subscriptionList != null) {
      _subscriptionList.remove(subscription);
    }
    if (_autoCancelWhenNoSubscription && _subscriptionList.length <= 0) {
      close();
    }
  }

  Future sendAction(Action value) async {
    if (_isClosed) return;

    _streamAction.add(value);
  }

  Future close() async {
    if (_isClosed) return;

    _isClosed = true;

    for (final item in _subscriptionList) {
      await item.cancel();
    }

    _subscriptionList.clear();

    await _streamAction.close();
    await _streamState.close();
    await _subscription.cancel();
    await _reducer.close();
  }
}
