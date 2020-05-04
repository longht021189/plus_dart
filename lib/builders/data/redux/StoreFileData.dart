import 'dart:async';
import 'dart:collection';

import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:plus_dart/builders/config/Name.dart';
import 'package:plus_dart/builders/config/UriList.dart';
import 'package:plus_dart/builders/data/redux/ProviderFileData.dart';
import 'package:plus_dart/builders/data/redux/StoreMethod.dart';
import 'package:plus_dart/builders/data/redux/StoreVariableData.dart';
import 'package:plus_dart/builders/util/CodeUtil.dart';
import 'package:plus_dart/builders/util/TypeUtil.dart';

class StoreFileData {
  bool get isValid => _isValid;
  bool _isValid = false;

  List<StoreVariableData> _variableList = List();
  Set<Uri> _importList = HashSet.of([UriList.async]);
  String _implementName;
  Map<DartType, StoreMethod> _methodMap = HashMap();

  void addProvider(ProviderFileData data, AssetId source) {
    _isValid = true;
    _importList.add(source.uri);

    for (final item in data.classDataList) {
      _variableList.add(StoreVariableData(item));
    }
  }

  Future<String> getCode(Resolver resolver, ClassElement element, AssetId aId) async {
    _importList.add(aId.uri);
    _implementName = element.name;

    for (final method in element.methods) {
      if (method.isPublic && !method.isAbstract 
          && !method.isStatic && method.parameters.isEmpty
          && TypeUtil.isOverride(method)) {
        if (_methodMap.containsKey(method.returnType)) {
          throw UnimplementedError('Not support multi ${method.returnType}.');
        }

        await TypeUtil.getImportList(
            method.returnType, _importList, resolver);

        _methodMap[method.returnType] = StoreMethod(
            method.name, method.returnType, isAbstract: true);
      }
    }

    for (final item in _variableList) {
      for (final param in item.provider.args) {
        if (!_methodMap.containsKey(param.type)) {
          throw UnimplementedError('${param.type} is not found.');
        }

        item.params.add(_methodMap[param.type]);
      }
    }

    return await _getCode(resolver);
  }

  Future<String> _getCode(Resolver resolver) async {
    final importList = HashSet<Uri>();
    final initialVariables = StringBuffer();
    final variableSendActionMap = HashMap<DartType, StringBuffer>();
    final sendActionContents = StringBuffer();
    final streamContents = StringBuffer();

    bool sendActionFirst = true;
    importList.addAll(_importList);

    for (final item in _variableList) {
      initialVariables.writeln(await item.getInitial());

      if (!variableSendActionMap.containsKey(item.provider.actionType)) {
        variableSendActionMap[item.provider.actionType] = StringBuffer();
      }

      variableSendActionMap[item.provider.actionType]
          .writeln(await item.getSendAction(Name.methodSendActionParam));

      streamContents
          ..writeln(await item.getStream())
          ..writeln();

      await TypeUtil.getImportList(
          item.provider.stateType, importList, resolver);
    }

    for (final item in variableSendActionMap.entries) {
      sendActionContents
        ..writeln('${sendActionFirst ? '' : ' else '}if (${Name.methodSendActionParam} is ${item.key}) {')
        ..writeln(item.value.toString())
        ..writeln('}');

      sendActionFirst = false;

      await TypeUtil.getImportList(item.key, importList, resolver);
    }

    final code = StringBuffer()
      ..writeln(CodeUtil.importFiles(importList))
      ..writeln('abstract class ${Name.classStore} {')
      ..writeln(initialVariables.toString())
      ..writeln(streamContents.toString())
      ..writeln('Future sendAction(dynamic ${Name.methodSendActionParam}) async {')
      ..writeln(sendActionContents.toString())
      ..writeln('}')
      ..writeln(CodeUtil.storeConstructor(Name.classStore, _implementName));
    
    for (final entry in _methodMap.entries) {
      code.write(entry.value.getCode());
    }
    
    code.writeln('}');

    return code.toString();
  }
}