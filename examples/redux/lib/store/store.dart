//import 'package:built_value/built_value.dart';
import 'package:plus_redux/redux.dart';

//part 'store.g.dart';

/*@store
class StoreImpl extends Store {
  StoreImpl(): super.unused();

  @override
  String provideForTestArgs() {
    return "Test";
  }
}*/

@store
abstract class StoreData { //implements Built<StoreData, StoreDataBuilder> {

  String appKey;

  double abc;

  int getInt() {
    return 0;
  }

  //StoreData._();

  //factory StoreData([void Function(StoreDataBuilder) updates]) = _$StoreData;
}
