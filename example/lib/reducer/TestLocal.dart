import 'package:plus_generator/base.dart';

@local
class TestLocal extends Reducer<TestState<String>, TestAction> {
  @override
  TestState<String> get initialState => null;

  @override
  Future<TestState<String>> onUpdate(TestState<String> state, TestAction action) {
    return null;
  }
}

class TestState<T> {
  T value;
}

class TestAction {

}
