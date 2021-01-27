import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

class ReduxBuilder extends Builder {
  ReduxBuilder(BuilderOptions options): super();

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final resolver = buildStep.resolver;
    if (!await resolver.isLibrary(buildStep.inputId)) return;
    final library = await buildStep.inputLibrary;
    await _buildSource(library, buildStep);
  }

  Future<void> _buildSource(LibraryElement library, BuildStep buildStep) async {

  }
}