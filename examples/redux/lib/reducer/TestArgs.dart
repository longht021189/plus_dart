import 'package:plus_redux/redux.dart';

@ReduxKey('Test')
class TestArgs extends Reducer<TestArgsState<String>, TestArgsAction<int>> {

  @override
  TestArgsState<String> get initialState => null;

  final String name;

  TestArgs(this.name);

  @override
  Future<TestArgsState<String>> onUpdate(TestArgsState<String> state, TestArgsAction<int> action) {
    return null;
  }
}

class TestArgsState<T> {
  T value;
}

class TestArgsAction<G> {

}
