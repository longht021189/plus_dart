import 'package:example/state/AppState.dart';
import 'package:example/state/AppStateAction.dart';
import 'package:example/state/AppStateGeneric.dart';
import 'package:plus_redux/redux.dart';

class AppReducerWithGeneric extends Reducer<AppStateGeneric<AppState>, AppStateAction> {

  @override
  AppStateGeneric<AppState> get initialState => null;

  @override
  Future<AppStateGeneric<AppState>> onUpdate(AppStateGeneric<AppState> state, AppStateAction action) {
    return null;
  }
}