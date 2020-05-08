// **************************************************************************
// GENERATED CODE - DO NOT MODIFY BY HAND
// **************************************************************************

import 'package:example/state/AppStateAction.dart';
import 'package:plus_redux/redux.dart';
import 'package:example/state/AppStateGeneric.dart';
import 'package:example/reducer/AppReducerWithGeneric.dart';
import 'package:example/state/AppState.dart';

class AppReducerWithGenericProvider extends Provider<AppStateGeneric<AppState>,
    AppStateAction, AppReducerWithGeneric> {
  AppReducerWithGenericProvider.createWith(AppReducerWithGeneric reducer)
      : super(reducer);
  AppReducerWithGenericProvider() : super(AppReducerWithGeneric());
  static const key = '175f5e9f-957c-4727-a9a7-0da05a8e1784';
}
