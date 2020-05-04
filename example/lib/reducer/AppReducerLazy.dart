import 'package:example/state/AppStateAction.dart';
import 'package:example/state/HomeState.dart';
import 'package:plus_dart/base.dart';

class AppReducerLazy extends Reducer<HomeState, AppStateAction> {

  @override
  HomeState get initialState => null;

  @override
  Future<HomeState> onUpdate(HomeState state, AppStateAction action) {
    return null;
  }
}