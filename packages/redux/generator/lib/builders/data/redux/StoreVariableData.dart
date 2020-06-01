import 'package:plus_redux_generator/builders/config/Name.dart';
import 'package:plus_redux_generator/builders/data/redux/ProviderData.dart';
import 'package:plus_redux_generator/builders/data/redux/StoreMethod.dart';

class StoreVariableData {
  final ProviderData provider;
  final String name;
  final List<StoreMethod> params2 = List();

  StoreVariableData(this.provider)
      : name = Name.getStoreVariableName(provider.name);

  String _getParams() {
    if (params2.isEmpty) {
      return '';
    }

    final code = StringBuffer();

    bool isFirst = true;
    for (final item in params2) {
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
      code.writeln("if ($name == null || $name.isClosed) { $name = ${_createInstance()}; }");
      code.writeln("return $name.stream as Stream<T>;");

      return code.toString();
    }

    throw UnimplementedError();
  }

  Future<String> getCloseMethod() async {
    return "if ($name != null) { if (!$name.isClosed) { await $name.close(); } $name = null; }";
  }
}