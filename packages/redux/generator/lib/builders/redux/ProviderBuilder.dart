import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:plus_redux_generator/builders/base/BaseBuilder.dart';
import 'package:plus_redux_generator/builders/base/visitor/GetClasses.dart';
import 'package:plus_redux_generator/builders/config/FileExtensions.dart';
import 'package:plus_redux_generator/builders/data/redux/ProviderData.dart';
import 'package:plus_redux_generator/builders/data/redux/ProviderFileData.dart';
import 'package:plus_redux_generator/builders/redux/StoreBuilder.dart';
import 'package:plus_redux_generator/builders/util/CodeUtil.dart';
import 'package:plus_redux_generator/builders/util/TypeUtil.dart';

class ProviderBuilder extends BaseBuilder {

  @override
  Map<String, List<String>> buildExtensions = {
    '.dart': [FileExtensions.Provider]
  };

  @override
  Future buildSource(LibraryElement library, BuildStep buildStep) async {
    final classList = _getAllClasses(library);
    if (classList.isEmpty) return;

    final fileData = ProviderFileData(List(), buildStep.inputId);

    for (final classItem in classList) {
      final result = await _hasReducerParent(classItem, buildStep);

      if (result != null) {
        final stateType = result.typeArguments[0];
        final actionType = result.typeArguments[1];

        fileData.classDataList.add(
            ProviderData(classItem, stateType, actionType));
      }
    }

    if (fileData.classDataList.isEmpty) return;

    final code = await fileData.getCode(buildStep.resolver);
    final output = buildStep.inputId.changeExtension(FileExtensions.Provider);

    StoreBuilder.addProvider(fileData, output);

    await CodeUtil.writeToFile(buildStep, output, code);
  }

  List<ClassElement> _getAllClasses(LibraryElement library) {
    final classesGetter = GetClasses();
    library.visitChildren(classesGetter);
    return classesGetter.value;
  }

  Future<InterfaceType> _hasReducerParent(ClassElement value, BuildStep buildStep) async {
    if (value.isAbstract ||
        value.isPrivate ||
        value.typeParameters.isNotEmpty) {
      return null;
    }

    return await TypeUtil.findReducer(value, buildStep);
  }
}