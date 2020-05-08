import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:plus_redux_generator/builders/base/BaseBuilder.dart';
import 'package:plus_redux_generator/builders/base/visitor/GetClasses.dart';
import 'package:plus_redux_generator/builders/config/FileExtensions.dart';
import 'package:plus_redux_generator/builders/data/redux/ProviderFileData.dart';
import 'package:plus_redux_generator/builders/data/redux/StoreFileData.dart';
import 'package:plus_redux_generator/builders/util/CodeUtil.dart';
import 'package:plus_redux_generator/builders/util/TypeUtil.dart';

class StoreBuilder extends BaseBuilder {

  static StoreFileData _data = StoreFileData();

  static void addProvider(ProviderFileData data, AssetId source) {
    _data.addProvider(data, source);
  }

  @override
  Map<String, List<String>> buildExtensions = {
    '.dart': [FileExtensions.Store]
  };

  ClassElement _getStoreClass(List<ClassElement> list) {
    if (list == null || list.length <= 0) return null;
    for (final item in list) {
      if (TypeUtil.isStore(item)) {
        return item;
      }
    }

    return null;
  }

  @override
  Future buildSource(LibraryElement library, BuildStep buildStep) async {
    if (!_data.isValid) return;

    final visitor = GetClasses();
    library.visitChildren(visitor);

    final storeClass = _getStoreClass(visitor.value);
    final it = _data.providerFileList
      .where((element) => buildStep.inputId.uri == element.source.uri);
    
    if (it.isNotEmpty) {
      final fileData = it.first;
      final code = await fileData.getCode(buildStep.resolver);
      final output = fileData.source.changeExtension(FileExtensions.Store);

      await CodeUtil.writeToFile(buildStep, output, code);
    }

    if (storeClass == null) return;

    final code = await _data.getCode(buildStep.resolver, storeClass, buildStep.inputId);
    final output = buildStep.inputId.changeExtension(FileExtensions.Store);

    await CodeUtil.writeToFile(buildStep, output, code);
  }
}