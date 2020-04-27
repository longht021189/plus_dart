import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

abstract class BaseBuilder extends Builder {

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final resolver = buildStep.resolver;
    if (!await resolver.isLibrary(buildStep.inputId)) return;
    final library = await buildStep.inputLibrary;
    await buildSource(library, buildStep);
  }

  Future buildSource(LibraryElement library, BuildStep buildStep);
}