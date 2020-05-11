import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

abstract class BaseBuilder extends Builder {

  bool _isShowBegin = false;

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    if (!_isShowBegin) {
      _isShowBegin = true;
      log.warning('Starting $buildName...');
    }

    /*final resolver = buildStep.resolver;
    if (!await resolver.isLibrary(buildStep.inputId)) return;
    final library = await buildStep.inputLibrary;
    await buildSource(library, buildStep);*/
  }

  Future buildSource(LibraryElement library, BuildStep buildStep);

  String get buildName;
}