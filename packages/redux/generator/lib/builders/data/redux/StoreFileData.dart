import 'dart:async';
import 'dart:collection';

import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:plus_redux_generator/builders/config/Name.dart';
import 'package:plus_redux_generator/builders/config/UriList.dart';
import 'package:plus_redux_generator/builders/data/redux/ProviderFileData.dart';
import 'package:plus_redux_generator/builders/data/redux/StoreMethod.dart';
import 'package:plus_redux_generator/builders/data/redux/StoreVariableData.dart';
import 'package:plus_redux_generator/builders/util/CodeUtil.dart';
import 'package:plus_redux_generator/builders/util/TypeUtil.dart';

class StoreFileData {
  bool get isValid => _isValid;
  bool _isValid = false;

  List<ProviderFileData> _providerDataList = List();
  List<StoreVariableData> _variableList = List();
  Set<Uri> _importList = HashSet.of([UriList.async]);
  String _implementName;
  Map<DartType, StoreMethod> _methodMap = HashMap();

  List<ProviderFileData> get providerFileList => _providerDataList;

  void addProvider(ProviderFileData data, AssetId source) {
    _isValid = true;
    _importList.add(source.uri);
    _providerDataList.add(data);

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

  Future<String> _getSendMethodCode(Resolver resolver, Set<Uri> importList, Map<DartType, StringBuffer> variableSendActionMap) async {
    final sendActionContents = StringBuffer();

    bool sendActionFirst = true;

    for (final item in variableSendActionMap.entries) {
      sendActionContents
        ..writeln('${sendActionFirst ? '' : ' else '}if (${Name.methodSendActionParam} is ${item.key}) {')
        ..writeln(item.value.toString())
        ..writeln('}');

      sendActionFirst = false;

      await TypeUtil.getImportList(item.key, importList, resolver);
    }

    sendActionContents
      .writeln(' else { throw UnimplementedError(); }');

    return sendActionContents.toString();
  }

  Future<String> _getStreamMethodCode() async {
    final streamContents = StringBuffer();

    streamContents.writeln('if (key != null) { switch(key) {');
    for (final item in _variableList) {
      streamContents.writeln('case ${item.provider.name}.key:{');
      streamContents.writeln(await item.getStream());
      streamContents.writeln('}');
    }
    streamContents.writeln('default:');
    streamContents.writeln('throw UnimplementedError();');
    streamContents.writeln('}}');

    streamContents.writeln('switch(T) {');
    for (final item in _variableList) {
      streamContents.writeln('case ${item.provider.stateType.element.name}:{');
      streamContents.writeln(await item.getStream());
      streamContents.writeln('}');
    }
    streamContents.writeln('default:');
    streamContents.writeln('throw UnimplementedError();');
    streamContents.writeln('}');

    return streamContents.toString();
  }

  Future<String> _getCode(Resolver resolver) async {
    final importList = HashSet<Uri>();
    final initialVariables = StringBuffer();
    final variableSendActionMap = HashMap<DartType, StringBuffer>();

    importList.addAll(_importList);

    for (final item in _variableList) {
      initialVariables.writeln(await item.getInitial());

      if (!variableSendActionMap.containsKey(item.provider.actionType)) {
        variableSendActionMap[item.provider.actionType] = StringBuffer();
      }

      variableSendActionMap[item.provider.actionType]
          .writeln(await item.getSendAction(Name.methodSendActionParam));

      await TypeUtil.getImportList(
          item.provider.stateType, importList, resolver);
    }

    final sendMethod = await _getSendMethodCode(
      resolver, importList, variableSendActionMap);

    final streamMethod = await _getStreamMethodCode();

    final code = StringBuffer()
      ..writeln(CodeUtil.importFiles(importList))
      ..writeln('abstract class ${Name.classStore} {')
      ..writeln(initialVariables.toString())
      ..writeln('Stream<T> getStream<T>([String key]) {')
      ..writeln(streamMethod)
      ..writeln('}')
      ..writeln('Future sendAction(dynamic ${Name.methodSendActionParam}) async {')
      ..writeln(sendMethod)
      ..writeln('}')
      ..writeln(CodeUtil.storeConstructor(Name.classStore, _implementName));
    
    for (final entry in _methodMap.entries) {
      code.write(entry.value.getCode());
    }
    
    code.writeln('}');

    return code.toString();
  }
}