import 'dart:async';
import 'dart:collection';

import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:plus_generator/builders/config/Name.dart';
import 'package:plus_generator/builders/config/UriList.dart';
import 'package:plus_generator/builders/data/redux/ProviderFileData.dart';
import 'package:plus_generator/builders/data/redux/StoreVariableData.dart';
import 'package:plus_generator/builders/util/CodeUtil.dart';
import 'package:plus_generator/builders/util/TypeUtil.dart';

class StoreFileData {
  bool get isValid => _isValid;
  bool _isValid = false;

  List<StoreVariableData> _variableList = List();
  Set<Uri> _importList = HashSet.of([UriList.async]);

  void addProvider(ProviderFileData data, AssetId source) {
    _isValid = true;
    _importList.add(source.uri);

    for (final item in data.classDataList) {
      _variableList.add(StoreVariableData(item));
    }
  }

  Future<String> getCode(Resolver resolver) async {
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
      ..writeln('class ${Name.classStore} {')
      ..writeln(initialVariables.toString())
      ..writeln(streamContents.toString())
      ..writeln('Future sendAction(dynamic ${Name.methodSendActionParam}) async {')
      ..writeln(sendActionContents.toString())
      ..writeln('}')
      ..writeln(CodeUtil.singleton(Name.classStore))
      ..writeln('}');

    return code.toString();
  }
}