import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:plus_redux_generator/builders/base/BaseBuilder.dart';
import 'package:plus_redux_generator/builders/base/visitor/GetClasses.dart';
import 'package:plus_redux_generator/builders/base/visitor/GetMainFunction.dart';
import 'package:plus_redux_generator/builders/config/FileExtensions.dart';
import 'package:plus_redux_generator/builders/data/redux/ProviderData.dart';
import 'package:plus_redux_generator/builders/data/redux/ProviderFileData.dart';
import 'package:plus_redux_generator/builders/redux/ReduxGenerator.dart';
import 'package:plus_redux_generator/builders/util/TypeUtil.dart';

class ReduxPrepare extends BaseBuilder {

  @override
  Map<String, List<String>> buildExtensions = {
    '.dart': [FileExtensions.Provider]
  };

  @override
  Future buildSource(LibraryElement library, BuildStep buildStep) async {
    final classList = _getAllClasses(library);
    final mainFunc = _getMainFunction(library);

    if (mainFunc != null) {
      ReduxGenerator.addMainFunction(mainFunc, buildStep.inputId);
    }
    if (classList.isEmpty) return;

    final storeData = _getStoreClass(classList);
    final fileData = ProviderFileData(List(), buildStep.inputId);

    if (storeData != null) {
      ReduxGenerator.addStoreData(storeData, buildStep.inputId);
    }

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

    final output = buildStep.inputId.changeExtension(FileExtensions.Store);

    ReduxGenerator.addProvider(fileData, output);
  }

  FunctionElement _getMainFunction(LibraryElement library) {
    final classesGetter = GetMainFunction();
    library.visitChildren(classesGetter);
    return classesGetter.value;
  }

  List<ClassElement> _getAllClasses(LibraryElement library) {
    final classesGetter = GetClasses();
    library.visitChildren(classesGetter);
    return classesGetter.value;
  }

  ClassElement _getStoreClass(List<ClassElement> list) {
    if (list == null || list.length <= 0) return null;
    for (final item in list) {
      if (TypeUtil.isStore(item)) {
        return item;
      }
    }

    return null;
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