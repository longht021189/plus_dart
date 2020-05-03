// **************************************************************************
// GENERATED CODE - DO NOT MODIFY BY HAND
// **************************************************************************

import 'package:example/reducer/AppReducerLazy.provider.dart';
import 'package:example/reducer/TestArgs.dart';
import 'package:example/reducer/TestLocal.dart';
import 'package:example/state/AppStateAction.dart';
import 'package:example/reducer/TestArgs.provider.dart';
import 'package:example/state/AppStateGeneric.dart';
import 'dart:async';
import 'package:example/state/HomeState.dart';
import 'package:example/reducer/TestLocal.provider.dart';
import 'package:example/store/store.dart';
import 'package:example/reducer/AppReducer.provider.dart';
import 'package:example/reducer/AppReducerWithGeneric.provider.dart';
import 'package:example/state/AppState.dart';

abstract class Store {
  TestLocalProvider _varTestLocalProvider;
  final _varTestArgsProvider = TestArgsProvider();
  AppReducerLazyProvider _varAppReducerLazyProvider;
  final _varAppReducerWithGenericProvider = AppReducerWithGenericProvider();
  final _varAppReducerProvider = AppReducerProvider();

  Stream<TestState<String>> get streamTestState {
    if (_varTestLocalProvider == null || _varTestLocalProvider.isClosed) {
      _varTestLocalProvider = TestLocalProvider();
    }
    return _varTestLocalProvider.stream;
  }

  Stream<TestArgsState<String>> get streamTestArgsState =>
      _varTestArgsProvider.stream;

  Stream<HomeState> get streamHomeState {
    if (_varAppReducerLazyProvider == null ||
        _varAppReducerLazyProvider.isClosed) {
      _varAppReducerLazyProvider = AppReducerLazyProvider();
    }
    return _varAppReducerLazyProvider.stream;
  }

  Stream<AppStateGeneric<AppState>> get streamAppStateGeneric =>
      _varAppReducerWithGenericProvider.stream;

  Stream<AppState> get streamAppState => _varAppReducerProvider.stream;

  Future sendAction(dynamic value) async {
    if (value is AppStateAction) {
      if (_varAppReducerLazyProvider == null ||
          _varAppReducerLazyProvider.isClosed) {
        _varAppReducerLazyProvider = AppReducerLazyProvider();
      }
      await _varAppReducerLazyProvider.sendAction(value);

      await _varAppReducerWithGenericProvider.sendAction(value);

      await _varAppReducerProvider.sendAction(value);
    } else if (value is TestArgsAction) {
      await _varTestArgsProvider.sendAction(value);
    } else if (value is TestAction) {
      if (_varTestLocalProvider != null && !_varTestLocalProvider.isClosed) {
        await _varTestLocalProvider.sendAction(value);
      }
    }
  }

  factory Store() => StoreImpl();

  Store.unused();

  String provideForTestArgs();
}
