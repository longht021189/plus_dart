import 'package:plus_redux/redux.dart';
import 'store.p.dart';

@store
class StoreImpl extends Store {
  StoreImpl(): super.unused();

  @override
  String provideForTestArgs() {
    return "Test";
  }
}
