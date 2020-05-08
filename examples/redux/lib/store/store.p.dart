// **************************************************************************
// GENERATED CODE - DO NOT MODIFY BY HAND
// **************************************************************************

import 'package:example/reducer/AppReducerWithGeneric.p.dart';
import 'package:example/reducer/TestArgs.dart';
import 'package:example/reducer/TestLocal.dart';
import 'package:example/state/AppStateAction.dart';
import 'package:example/state/AppStateGeneric.dart';
import 'package:example/reducer/AppReducerLazy.p.dart';
import 'package:example/reducer/TestLocal.p.dart';
import 'dart:async';
import 'package:example/reducer/TestArgs.p.dart';
import 'package:example/state/HomeState.dart';
import 'package:example/reducer/AppReducer.p.dart';
import 'package:example/store/store.dart';
import 'package:example/state/AppState.dart';

abstract class Store {
  AppReducerProvider _varAppReducerProvider;
  AppReducerLazyProvider _varAppReducerLazyProvider;
  AppReducerWithGenericProvider _varAppReducerWithGenericProvider;
  TestArgsProvider _varTestArgsProvider;
  TestLocalProvider _varTestLocalProvider;

  Stream<T> getStream<T>([String key]) {
    if (key != null) {
      switch (key) {
        case AppReducerProvider.key:
          {
            if (_varAppReducerProvider == null ||
                _varAppReducerProvider.isClosed) {
              _varAppReducerProvider = AppReducerProvider();
            }
            return _varAppReducerProvider.stream as Stream<T>;
          }
        case AppReducerLazyProvider.key:
          {
            if (_varAppReducerLazyProvider == null ||
                _varAppReducerLazyProvider.isClosed) {
              _varAppReducerLazyProvider = AppReducerLazyProvider();
            }
            return _varAppReducerLazyProvider.stream as Stream<T>;
          }
        case AppReducerWithGenericProvider.key:
          {
            if (_varAppReducerWithGenericProvider == null ||
                _varAppReducerWithGenericProvider.isClosed) {
              _varAppReducerWithGenericProvider =
                  AppReducerWithGenericProvider();
            }
            return _varAppReducerWithGenericProvider.stream as Stream<T>;
          }
        case TestArgsProvider.key:
          {
            if (_varTestArgsProvider == null || _varTestArgsProvider.isClosed) {
              _varTestArgsProvider = TestArgsProvider(provideForTestArgs());
            }
            return _varTestArgsProvider.stream as Stream<T>;
          }
        case TestLocalProvider.key:
          {
            if (_varTestLocalProvider == null ||
                _varTestLocalProvider.isClosed) {
              _varTestLocalProvider = TestLocalProvider();
            }
            return _varTestLocalProvider.stream as Stream<T>;
          }
        default:
          throw UnimplementedError();
      }
    }
    switch (T) {
      case AppState:
        {
          if (_varAppReducerProvider == null ||
              _varAppReducerProvider.isClosed) {
            _varAppReducerProvider = AppReducerProvider();
          }
          return _varAppReducerProvider.stream as Stream<T>;
        }
      case HomeState:
        {
          if (_varAppReducerLazyProvider == null ||
              _varAppReducerLazyProvider.isClosed) {
            _varAppReducerLazyProvider = AppReducerLazyProvider();
          }
          return _varAppReducerLazyProvider.stream as Stream<T>;
        }
      case AppStateGeneric:
        {
          if (_varAppReducerWithGenericProvider == null ||
              _varAppReducerWithGenericProvider.isClosed) {
            _varAppReducerWithGenericProvider = AppReducerWithGenericProvider();
          }
          return _varAppReducerWithGenericProvider.stream as Stream<T>;
        }
      case TestArgsState:
        {
          if (_varTestArgsProvider == null || _varTestArgsProvider.isClosed) {
            _varTestArgsProvider = TestArgsProvider(provideForTestArgs());
          }
          return _varTestArgsProvider.stream as Stream<T>;
        }
      case TestState:
        {
          if (_varTestLocalProvider == null || _varTestLocalProvider.isClosed) {
            _varTestLocalProvider = TestLocalProvider();
          }
          return _varTestLocalProvider.stream as Stream<T>;
        }
      default:
        throw UnimplementedError();
    }
  }

  Future sendAction(dynamic value) async {
    if (value is AppStateAction) {
      if (_varAppReducerProvider == null || _varAppReducerProvider.isClosed) {
        _varAppReducerProvider = AppReducerProvider();
      }
      await _varAppReducerProvider.sendAction(value);

      if (_varAppReducerLazyProvider == null ||
          _varAppReducerLazyProvider.isClosed) {
        _varAppReducerLazyProvider = AppReducerLazyProvider();
      }
      await _varAppReducerLazyProvider.sendAction(value);

      if (_varAppReducerWithGenericProvider == null ||
          _varAppReducerWithGenericProvider.isClosed) {
        _varAppReducerWithGenericProvider = AppReducerWithGenericProvider();
      }
      await _varAppReducerWithGenericProvider.sendAction(value);
    } else if (value is TestAction) {
      if (_varTestLocalProvider != null && !_varTestLocalProvider.isClosed) {
        await _varTestLocalProvider.sendAction(value);
      }
    } else if (value is TestArgsAction) {
      if (_varTestArgsProvider == null || _varTestArgsProvider.isClosed) {
        _varTestArgsProvider = TestArgsProvider(provideForTestArgs());
      }
      await _varTestArgsProvider.sendAction(value);
    } else {
      throw UnimplementedError();
    }
  }

  factory Store() => StoreImpl();

  Store.unused();

  String provideForTestArgs();
}
