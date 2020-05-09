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
  static const key = '7e8664d4-d954-4628-aca1-5633727960e4';
}
