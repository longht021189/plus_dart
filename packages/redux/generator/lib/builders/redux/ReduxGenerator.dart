import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:plus_redux_generator/builders/base/BaseBuilder.dart';
import 'package:plus_redux_generator/builders/base/visitor/GetClasses.dart';
import 'package:plus_redux_generator/builders/config/FileExtensions.dart';
import 'package:plus_redux_generator/builders/data/redux/ProviderFileData.dart';
import 'package:plus_redux_generator/builders/data/redux/StoreFileData.dart';
import 'package:plus_redux_generator/builders/util/CodeUtil.dart';

class ReduxGenerator extends BaseBuilder {

  @override
  String get buildName => 'redux_generator';

  static StoreFileData _data = StoreFileData();

  static void addProvider(ProviderFileData data, AssetId source) {
    _data.addProvider(data, source);
  }

  static void addMainFunction(FunctionElement data, AssetId source) {
    _data.addMainFunction(data, source);
  }

  static void addStoreData(ClassElement data, AssetId source) {
    _data.addStoreData(data, source);
  }

  @override
  Map<String, List<String>> buildExtensions = {
    '.dart': [FileExtensions.Store]
  };

  @override
  Future buildSource(LibraryElement library, BuildStep buildStep) async {
    this.print('buildSource: ${buildStep.inputId.uri}');
    if (!(await _data.isValid(buildStep.resolver))) return;

    final visitor = GetClasses();
    library.visitChildren(visitor);

    final it = _data.providerFileList
      .where((element) => buildStep.inputId.uri == element.source.uri);
    
    if (it.isNotEmpty) {
      final fileData = it.first;
      final code = await fileData.getCode(buildStep.resolver);
      final output = fileData.source.changeExtension(FileExtensions.Store);

      await CodeUtil.writeToFile(buildStep, output, code);
    }

    if (!_data.isStoreSource(buildStep.inputId)) return;

    final code = await _data.getStoreCode(buildStep.resolver, buildStep.inputId);
    final output = buildStep.inputId.changeExtension(FileExtensions.Store);

    await CodeUtil.writeToFile(buildStep, output, code);
  }
}