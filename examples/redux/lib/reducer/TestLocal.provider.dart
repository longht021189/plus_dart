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
  static const key = 'f9204cb2-4152-4895-a0d6-4e900315ec27';
}
