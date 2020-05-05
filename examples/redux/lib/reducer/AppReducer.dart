import 'package:example/state/AppState.dart';
import 'package:example/state/AppStateAction.dart';
import 'package:plus_redux/redux.dart';

class AppReducer extends Reducer<AppState, AppStateAction> {
  @override
  AppState get initialState => null;

  @override
  Future<AppState> onUpdate(AppState state, AppStateAction action) {
    return null;
  }
}