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
  static const key = 'e7385f2b-ce6c-43de-a16b-bf9b176085c4';
}
