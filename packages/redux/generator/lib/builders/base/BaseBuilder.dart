import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

abstract class BaseBuilder extends Builder {

  bool _firstLog = true;

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    if (_firstLog) {
      _firstLog = false;
      this.print('$buildName running...');
    }

    final resolver = buildStep.resolver;
    if (!await resolver.isLibrary(buildStep.inputId)) return;
    final library = await buildStep.inputLibrary;
    await buildSource(library, buildStep);
  }

  void print(msg) {
    log.info('[$buildName] $msg');
  }

  Future buildSource(LibraryElement library, BuildStep buildStep);

  String get buildName;
}