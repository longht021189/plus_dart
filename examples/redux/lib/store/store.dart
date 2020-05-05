import 'package:plus_redux/redux.dart';
import 'store.redux.dart';

@store
class StoreImpl extends Store {
  StoreImpl(): super.unused();

  @override
  String provideForTestArgs() {
    return "Test";
  }
}
