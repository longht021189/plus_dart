import 'package:plus_dart/base.dart';

class TestArgs extends Reducer<TestArgsState<String>, TestArgsAction> {

  @override
  TestArgsState<String> get initialState => null;

  final String name;

  TestArgs(this.name);

  @override
  Future<TestArgsState<String>> onUpdate(TestArgsState<String> state, TestArgsAction action) {
    return null;
  }
}

class TestArgsState<T> {
  T value;
}

class TestArgsAction {

}
