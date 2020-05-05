import 'package:plus_redux_generator/builders/config/Name.dart';
import 'package:plus_redux_generator/builders/data/redux/ProviderData.dart';
import 'package:plus_redux_generator/builders/data/redux/StoreMethod.dart';

class StoreVariableData {
  final ProviderData provider;
  final String name;
  final List<StoreMethod> params = List();

  StoreVariableData(this.provider)
      : name = Name.getStoreVariableName(provider.name);

  String _getParams() {
    if (params.isEmpty) {
      return '';
    }

    final code = StringBuffer();

    bool isFirst = true;
    for (final item in params) {
      if (!isFirst) {
        code.write(', ');
      }
      isFirst = false;
      code.write(item.getCall());
    }

    return code.toString();
  }

  String _createInstance() {
    return '${provider.name}(${_getParams()})';
  }

  Future<String> getInitial() async {
    if (provider.isLazy) {
      return '${provider.name} $name;';
    }

    return 'final $name = ${_createInstance()};';
  }

  Future<String> getSendAction(String paramName) async {
    final code = StringBuffer();
    if (provider.isLocal) {
      code
        ..writeln("if ($name != null && !$name.isClosed) {")
        ..writeln("await $name.sendAction($paramName);")
        ..writeln("}");

      return code.toString();
    } else if (provider.isLazy) {
      code.writeln("if ($name == null || $name.isClosed) { $name = ${_createInstance()};}");
    }
    code.writeln("await $name.sendAction($paramName);");
    return code.toString();
  }

  Future<String> getStream() async {
    if (provider.isLazy) {
      final code = StringBuffer();
      code.writeln("Stream<${provider.stateType}> get stream${provider.stateType.element.name} {");
      code.writeln("if ($name == null || $name.isClosed) { $name = ${_createInstance()};}");
      code.writeln("return $name.stream;");
      code.writeln("}");
      return code.toString();
    }
    return "Stream<${provider.stateType}> get stream${provider.stateType.element.name} => $name.stream;";
  }
}