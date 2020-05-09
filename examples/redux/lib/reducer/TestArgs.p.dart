// **************************************************************************
// GENERATED CODE - DO NOT MODIFY BY HAND
// **************************************************************************

import 'package:example/reducer/TestArgs.dart';
import 'package:plus_redux/redux.dart';

class TestArgsProvider
    extends Provider<TestArgsState<String>, TestArgsAction<int>, TestArgs> {
  TestArgsProvider.createWith(TestArgs reducer) : super(reducer);
  TestArgsProvider(String param_0) : super(TestArgs(param_0));
  static const key = 'Test';
}
