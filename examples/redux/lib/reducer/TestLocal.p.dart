// **************************************************************************
// GENERATED CODE - DO NOT MODIFY BY HAND
// **************************************************************************

import 'package:example/reducer/TestLocal.dart';
import 'package:plus_redux/redux.dart';

class TestLocalProvider
    extends Provider<TestState<String>, TestAction, TestLocal> {
  TestLocalProvider.createWith(TestLocal reducer)
      : super(reducer, isLocal: true);
  TestLocalProvider() : super(TestLocal(), isLocal: true);
  static const key = '8d4633bc-059b-4182-85bb-6d7f9a32faaa';
}
