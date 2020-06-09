import 'package:built_value/built_value.dart';
import 'package:plus_redux/redux.dart';

part 'store.g.dart';

@store
abstract class StoreData implements Built<StoreData, StoreDataBuilder> {

  String get appKey;
  double get abc;
  int get fff;

  int getInt() {
    return 0;
  }

  StoreData._();

  factory StoreData([void Function(StoreDataBuilder) updates]) = _$StoreData;
}
