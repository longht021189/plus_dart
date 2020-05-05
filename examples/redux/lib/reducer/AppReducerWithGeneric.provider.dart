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
  static const key = '05549c75-04d0-40a6-a90d-5a60b1f398c0';
}
