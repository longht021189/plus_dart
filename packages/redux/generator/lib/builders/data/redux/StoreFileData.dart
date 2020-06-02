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
  bool _isValid = false;

  List<ProviderFileData> _providerDataList = List();
  List<StoreVariableData> _variableList = List();
  Set<Uri> _importList = HashSet.of([UriList.async]);
  String _dataName2;
  Map<DartType, StoreMethod> _methodMap2 = HashMap();

  FunctionElement _mainFunc;
  bool _mainFuncMulti = false;
  AssetId _mainFuncSource;

  ClassElement _storeDataClass;
  bool _storeDataClassMulti = false;
  AssetId _storeDataClassSource;

  bool _isRequiredStoreData = false;

  List<ProviderFileData> get providerFileList => _providerDataList;

  Future<bool> isValid(Resolver resolver) async {
    if (!_isValid) return false;

    if (_storeDataClass != null) {
      if (_storeDataClassMulti) {
        throw UnimplementedError('Multi Store Data is Detected.');
      }

      await _parseData(resolver);
    } else if (_mainFunc != null) {
      if (_mainFuncMulti) {
        throw UnimplementedError('Multi Main Function is Detected.');
      }
    } else {
      return false;
    }

    return true;
  }

  Future<void> _parseData(Resolver resolver) async {
    if (_dataName2 != null) return;

    _dataName2 = _storeDataClass.name;

    for (final method in _storeDataClass.methods) {
      if (method.isPublic && method.parameters.isEmpty 
          && !method.returnType.isVoid && !method.returnType.isDynamic) {
        if (_methodMap2.containsKey(method.returnType)) {
          throw UnimplementedError('Not support multi ${method.returnType}.');
        }

        await TypeUtil.getImportList(
            method.returnType, _importList, resolver);

        _methodMap2[method.returnType] = StoreMethod(
            method.name, method.returnType, isStatic: method.isStatic);
      }
    }
    for (final method in _storeDataClass.accessors) {
      if (method.isPublic && method.parameters.isEmpty 
          && !method.returnType.isVoid && !method.returnType.isDynamic) {
        if (_methodMap2.containsKey(method.returnType)) {
          throw UnimplementedError('Not support multi ${method.returnType}.');
        }

        await TypeUtil.getImportList(
            method.returnType, _importList, resolver);

        _methodMap2[method.returnType] = StoreMethod(
            method.name, method.returnType, 
            isStatic: method.isStatic, isGetter: true);
      }
    }
    for (final method in _storeDataClass.fields) {
      if (method.isPublic && !method.type.isVoid 
          && !method.type.isDynamic 
          && !_methodMap2.containsKey(method.type)) {
        await TypeUtil.getImportList(
            method.type, _importList, resolver);

        _methodMap2[method.type] = StoreMethod(
            method.name, method.type, 
            isStatic: method.isStatic, isGetter: true);
      }
    }

    for (final item in _variableList) {
      for (final param in item.provider.args) {
        final isIStore = await TypeUtil
          .isIStore(resolver, param.type);

        if (!_methodMap2.containsKey(param.type) && !isIStore) {
          throw UnimplementedError('${param.type} is not found.');
        }

        if (isIStore) {
          item.params2.add(StoreMethod(
            null, null, isIStore: true));
        } else {
          _isRequiredStoreData = true;
          item.params2.add(_methodMap2[param.type]);
        }
      }
    }
  }

  void addProvider(ProviderFileData data, AssetId source) {
    _isValid = true;
    _importList.add(source.uri);
    _providerDataList.add(data);

    for (final item in data.classDataList) {
      _variableList.add(StoreVariableData(item));
    }
  }

  void addMainFunction(FunctionElement data, AssetId source) {
    if (_storeDataClass != null) return;
    if (_mainFunc != null) {
      _mainFuncMulti = true;
    }

    _mainFunc = data;
    _mainFuncSource = source;
  }

  void addStoreData(ClassElement data, AssetId source) {
    if (_storeDataClass != null) {
      _storeDataClassMulti = true;
    }

    _storeDataClass = data;
    _storeDataClassSource = source;
  }

  bool isStoreSource(AssetId source) {
    if (_storeDataClass != null) {
      return source.uri == _storeDataClassSource.uri;
    } else if (_mainFunc != null) {
      return source.uri == _mainFuncSource.uri;
    }

    return false;
  }

  Future<String> getStoreCode(Resolver resolver, AssetId aId) async {
    _importList.add(aId.uri);
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
    final streamContents = StringBuffer()
      ..writeln('String temp;')
      ..writeln('if (key != null) { temp = key; }')
      ..writeln('else { temp = _typeMap[T]; }')
      ..writeln('if (temp == null) { throw UnimplementedError(); }');

    streamContents.writeln('switch(temp) {');
    for (final item in _variableList) {
      streamContents.writeln('case ${item.provider.name}.key:{');
      streamContents.writeln(await item.getStream());
      streamContents.writeln('}');
    }
    streamContents.writeln('default:');
    streamContents.writeln('throw UnimplementedError();');
    streamContents.writeln('}');

    return streamContents.toString();
  }

  Future<String> _getParseTypeMethod() async {
    final code = StringBuffer()
      ..writeln('void _parse<T>(String key) {')
      ..writeln('_typeMap[T] = key;')
      ..writeln('}');

    return code.toString();
  }

  Future<String> _getConstructorCode() async {
    final code = StringBuffer();

    for (final item in _variableList) {
      code.writeln('_parse<${item.provider.stateType}>(${item.provider.name}.key);');
    }

    return code.toString();
  }

  Future<String> _getCloseMethodCode() async {
    final code = StringBuffer();
    for (final item in _variableList) {
      code.writeln(await item.getCloseMethod());
    }
    return code.toString(); 
  }

  Future<String> _getVariablesCode(Resolver resolver, Set<Uri> importList, Map<DartType, StringBuffer> variableSendActionMap) async {
    final initialVariables = StringBuffer();
    initialVariables.writeln('final _typeMap = HashMap<dynamic, String>();');
    initialVariables.writeln('final $_dataName2 _data;');

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

    return initialVariables.toString();
  }

  Future<String> _getCode(Resolver resolver) async {
    final importList = HashSet<Uri>();
    final variableSendActionMap = HashMap<DartType, StringBuffer>();

    importList.add(UriList.collection);
    importList.add(UriList.base);
    importList.addAll(_importList);

    final variables = await _getVariablesCode(
      resolver, importList, variableSendActionMap);

    final sendMethod = await _getSendMethodCode(
      resolver, importList, variableSendActionMap);

    final streamMethod = await _getStreamMethodCode();

    final closeMethod = await _getCloseMethodCode();

    final code = StringBuffer()
      ..writeln(CodeUtil.importFiles(importList))
      ..writeln('class ${Name.classStore} extends IStore {')
      ..writeln(variables)
      ..writeln('bool _isClosed = false;')
      ..writeln('@override')
      ..writeln('bool get isClosed => _isClosed;')
      ..writeln(await _getParseTypeMethod())
      ..writeln('@override')
      ..writeln('Stream<T> getStream<T>([String key]) {')
      ..writeln('if (_isClosed) throw UnimplementedError();')
      ..writeln(streamMethod)
      ..writeln('}')
      ..writeln('@override')
      ..writeln('Future sendAction(dynamic ${Name.methodSendActionParam}) async {')
      ..writeln('if (_isClosed) return;')
      ..writeln(sendMethod)
      ..writeln('}')
      ..writeln('@override')
      ..writeln('Future close() async {')
      ..writeln('if (_isClosed) return;')
      ..writeln('_isClosed = true;')
      ..writeln(closeMethod)
      ..writeln('}')
      ..write('${Name.classStore}([$_dataName2 data])')
      ..write(': _data = data')
      ..write(_isRequiredStoreData ? ', assert(_data != null)' : '')
      ..writeln('{')
      ..writeln(await _getConstructorCode())
      ..writeln('} }');

    return code.toString();
  }
}