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
  static const key = 'f074bade-0bbe-466c-8f8f-5206f24f0e8f';
}
