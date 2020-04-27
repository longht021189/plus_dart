import 'package:plus_dart/builders/config/Name.dart';
import 'package:plus_dart/builders/data/redux/ProviderData.dart';

class StoreVariableData {
  final ProviderData provider;
  final String name;

  StoreVariableData(this.provider)
      : name = Name.getStoreVariableName(provider.name);

  Future<String> getInitial() async {
    if (provider.isLazy) {
      return '${provider.name} $name;';
    }

    return 'final $name = ${provider.name}();';
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
      code.writeln("if ($name == null || $name.isClosed) { $name = ${provider.name}();}");
    }
    code.writeln("await $name.sendAction($paramName);");
    return code.toString();
  }

  Future<String> getStream() async {
    if (provider.isLazy) {
      final code = StringBuffer();
      code.writeln("Stream<${provider.stateType}> get stream${provider.stateType.element.name} {");
      code.writeln("if ($name == null || $name.isClosed) { $name = ${provider.name}();}");
      code.writeln("return $name.stream;");
      code.writeln("}");
      return code.toString();
    }
    return "Stream<${provider.stateType}> get stream${provider.stateType.element.name} => $name.stream;";
  }
}