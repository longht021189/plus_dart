// **************************************************************************
// GENERATED CODE - DO NOT MODIFY BY HAND
// **************************************************************************

import 'package:example/reducer/AppReducerLazy.provider.dart';
import 'package:example/state/AppStateAction.dart';
import 'package:example/reducer/TestLocal.dart';
import 'package:example/state/HomeState.dart';
import 'package:example/state/AppStateGeneric.dart';
import 'package:example/reducer/TestLocal.provider.dart';
import 'dart:async';
import 'package:example/reducer/AppReducer.provider.dart';
import 'package:example/state/AppState.dart';
import 'package:example/reducer/AppReducerWithGeneric.provider.dart';

class Store {
  TestLocalProvider _varTestLocalProvider;
  final _varAppReducerWithGenericProvider = AppReducerWithGenericProvider();
  AppReducerLazyProvider _varAppReducerLazyProvider;
  final _varAppReducerProvider = AppReducerProvider();

  Stream<TestState<String>> get streamTestState {
    if (_varTestLocalProvider == null || _varTestLocalProvider.isClosed) {
      _varTestLocalProvider = TestLocalProvider();
    }
    return _varTestLocalProvider.stream;
  }

  Stream<AppStateGeneric<AppState>> get streamAppStateGeneric =>
      _varAppReducerWithGenericProvider.stream;

  Stream<HomeState> get streamHomeState {
    if (_varAppReducerLazyProvider == null ||
        _varAppReducerLazyProvider.isClosed) {
      _varAppReducerLazyProvider = AppReducerLazyProvider();
    }
    return _varAppReducerLazyProvider.stream;
  }

  Stream<AppState> get streamAppState => _varAppReducerProvider.stream;

  Future sendAction(dynamic value) async {
    if (value is AppStateAction) {
      await _varAppReducerWithGenericProvider.sendAction(value);

      if (_varAppReducerLazyProvider == null ||
          _varAppReducerLazyProvider.isClosed) {
        _varAppReducerLazyProvider = AppReducerLazyProvider();
      }
      await _varAppReducerLazyProvider.sendAction(value);

      await _varAppReducerProvider.sendAction(value);
    } else if (value is TestAction) {
      if (_varTestLocalProvider != null && !_varTestLocalProvider.isClosed) {
        await _varTestLocalProvider.sendAction(value);
      }
    }
  }

  static Store _instance;

  factory Store() {
    if (_instance == null) {
      _instance = Store._internal();
    }
    return _instance;
  }

  Store._internal();
}
