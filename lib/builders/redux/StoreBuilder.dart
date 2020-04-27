import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:plus_dart/builders/base/BaseBuilder.dart';
import 'package:plus_dart/builders/base/visitor/GetMainFunction.dart';
import 'package:plus_dart/builders/config/FileExtensions.dart';
import 'package:plus_dart/builders/data/redux/ProviderFileData.dart';
import 'package:plus_dart/builders/data/redux/StoreFileData.dart';
import 'package:plus_dart/builders/util/CodeUtil.dart';

class StoreBuilder extends BaseBuilder {

  static StoreFileData _data = StoreFileData();

  static void addProvider(ProviderFileData data, AssetId source) {
    _data.addProvider(data, source);
  }

  @override
  Map<String, List<String>> buildExtensions = {
    '.dart': [FileExtensions.Store]
  };

  @override
  Future buildSource(LibraryElement library, BuildStep buildStep) async {
    final visitor = GetMainFunction();
    final uriStr = buildStep.inputId.uri.toString();

    library.visitChildren(visitor);

    if (visitor.value == null || !uriStr
        .startsWith('package:') || !_data.isValid) return;

    final code = await _data.getCode(buildStep.resolver);
    final output = buildStep.inputId.changeExtension(FileExtensions.Store);

    await CodeUtil.writeToFile(buildStep, output, code);
  }
}