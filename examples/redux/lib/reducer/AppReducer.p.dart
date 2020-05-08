// **************************************************************************
// GENERATED CODE - DO NOT MODIFY BY HAND
// **************************************************************************

import 'package:example/state/AppStateAction.dart';
import 'package:plus_redux/redux.dart';
import 'package:example/reducer/AppReducer.dart';
import 'package:example/state/AppState.dart';

class AppReducerProvider
    extends Provider<AppState, AppStateAction, AppReducer> {
  AppReducerProvider.createWith(AppReducer reducer) : super(reducer);
  AppReducerProvider() : super(AppReducer());
  static const key = '99658246-ab8b-465f-9a87-2f708e0eb021';
}
