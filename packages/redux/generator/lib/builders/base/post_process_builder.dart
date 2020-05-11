import 'dart:async';

import 'package:build/build.dart';

class PostProcessBuilderWrapper extends PostProcessBuilder {

  final PostProcessBuilder builder;
  final String buildName;

  bool _isShowBegin = false;

  PostProcessBuilderWrapper(this.buildName, this.builder);

  @override
  FutureOr<void> build(PostProcessBuildStep buildStep) {
    if (!_isShowBegin) {
      _isShowBegin = true;
      log.warning('Starting $buildName...');
    }
    
    return builder.build(buildStep);
  }

  @override
  Iterable<String> get inputExtensions => builder.inputExtensions;
}