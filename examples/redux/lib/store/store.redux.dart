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
  AppReducerWithGenericProvider _varAppReducerWithGenericProvider;
  TestArgsProvider _varTestArgsProvider;
  TestLocalProvider _varTestLocalProvider;
  AppReducerProvider _varAppReducerProvider;
  AppReducerLazyProvider _varAppReducerLazyProvider;

  Stream<AppStateGeneric<AppState>> get streamAppStateGeneric {
    if (_varAppReducerWithGenericProvider == null ||
        _varAppReducerWithGenericProvider.isClosed) {
      _varAppReducerWithGenericProvider = AppReducerWithGenericProvider();
    }
    return _varAppReducerWithGenericProvider.stream;
  }

  Stream<TestArgsState<String>> get streamTestArgsState {
    if (_varTestArgsProvider == null || _varTestArgsProvider.isClosed) {
      _varTestArgsProvider = TestArgsProvider(provideForTestArgs());
    }
    return _varTestArgsProvider.stream;
  }

  Stream<TestState<String>> get streamTestState {
    if (_varTestLocalProvider == null || _varTestLocalProvider.isClosed) {
      _varTestLocalProvider = TestLocalProvider();
    }
    return _varTestLocalProvider.stream;
  }

  Stream<AppState> get streamAppState {
    if (_varAppReducerProvider == null || _varAppReducerProvider.isClosed) {
      _varAppReducerProvider = AppReducerProvider();
    }
    return _varAppReducerProvider.stream;
  }

  Stream<HomeState> get streamHomeState {
    if (_varAppReducerLazyProvider == null ||
        _varAppReducerLazyProvider.isClosed) {
      _varAppReducerLazyProvider = AppReducerLazyProvider();
    }
    return _varAppReducerLazyProvider.stream;
  }

  Future sendAction(dynamic value) async {
    if (value is AppStateAction) {
      if (_varAppReducerWithGenericProvider == null ||
          _varAppReducerWithGenericProvider.isClosed) {
        _varAppReducerWithGenericProvider = AppReducerWithGenericProvider();
      }
      await _varAppReducerWithGenericProvider.sendAction(value);

      if (_varAppReducerProvider == null || _varAppReducerProvider.isClosed) {
        _varAppReducerProvider = AppReducerProvider();
      }
      await _varAppReducerProvider.sendAction(value);

      if (_varAppReducerLazyProvider == null ||
          _varAppReducerLazyProvider.isClosed) {
        _varAppReducerLazyProvider = AppReducerLazyProvider();
      }
      await _varAppReducerLazyProvider.sendAction(value);
    } else if (value is TestAction) {
      if (_varTestLocalProvider != null && !_varTestLocalProvider.isClosed) {
        await _varTestLocalProvider.sendAction(value);
      }
    } else if (value is TestArgsAction) {
      if (_varTestArgsProvider == null || _varTestArgsProvider.isClosed) {
        _varTestArgsProvider = TestArgsProvider(provideForTestArgs());
      }
      await _varTestArgsProvider.sendAction(value);
    }
  }

  factory Store() => StoreImpl();

  Store.unused();

  String provideForTestArgs();
}
