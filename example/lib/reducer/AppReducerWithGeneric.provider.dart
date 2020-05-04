// **************************************************************************
// GENERATED CODE - DO NOT MODIFY BY HAND
// **************************************************************************

import 'package:plus_dart/base.dart';
import 'package:example/state/AppStateAction.dart';
import 'package:example/state/AppStateGeneric.dart';
import 'package:example/reducer/AppReducerWithGeneric.dart';
import 'package:example/state/AppState.dart';

class AppReducerWithGenericProvider extends Provider<AppStateGeneric<AppState>,
    AppStateAction, AppReducerWithGeneric> {
  AppReducerWithGenericProvider.createWith(AppReducerWithGeneric reducer)
      : super(reducer);
  AppReducerWithGenericProvider() : super(AppReducerWithGeneric());
  static const key = '076794de-bbf5-4af6-a601-ba93f0dc35d9';
}
