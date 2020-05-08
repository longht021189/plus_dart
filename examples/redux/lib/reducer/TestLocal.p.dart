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
  static const key = 'd01207ea-a687-4c85-a5da-5b118138db3d';
}
