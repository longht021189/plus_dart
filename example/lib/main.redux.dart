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
import 'package:example/reducer/AppReducerWithGeneric.provider.dart';
import 'package:example/state/AppState.dart';

class Store {
  TestLocalProvider _varTestLocalProvider;
  final _varAppReducerProvider = AppReducerProvider();
  final _varAppReducerWithGenericProvider = AppReducerWithGenericProvider();
  AppReducerLazyProvider _varAppReducerLazyProvider;

  Stream<TestState> get streamTestState {
    if (_varTestLocalProvider == null || _varTestLocalProvider.isClosed) {
      _varTestLocalProvider = TestLocalProvider();
    }
    return _varTestLocalProvider.stream;
  }

  Stream<AppState> get streamAppState => _varAppReducerProvider.stream;

  Stream<AppStateGeneric<AppState>> get streamAppStateGeneric =>
      _varAppReducerWithGenericProvider.stream;

  Stream<HomeState> get streamHomeState {
    if (_varAppReducerLazyProvider == null ||
        _varAppReducerLazyProvider.isClosed) {
      _varAppReducerLazyProvider = AppReducerLazyProvider();
    }
    return _varAppReducerLazyProvider.stream;
  }

  Future sendAction(dynamic value) async {
    if (value is AppStateAction) {
      await _varAppReducerProvider.sendAction(value);

      await _varAppReducerWithGenericProvider.sendAction(value);

      if (_varAppReducerLazyProvider == null ||
          _varAppReducerLazyProvider.isClosed) {
        _varAppReducerLazyProvider = AppReducerLazyProvider();
      }
      await _varAppReducerLazyProvider.sendAction(value);
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
