import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:plus_generator/builders/config/Name.dart';
import 'package:plus_generator/builders/util/TypeUtil.dart';

class ProviderData {
  final ClassElement classType;
  final DartType stateType;
  final DartType actionType;
  final String name;
  final String className;
  final bool isLazy;
  final bool isLocal;

  ProviderData(this.classType, this.stateType, this.actionType)
      : name = Name.getProviderName(classType)
      , className = classType.name
      , isLocal = TypeUtil.isLocal(classType)
      , isLazy = TypeUtil.isLazy(classType);

  Future getImportList(Set<Uri> set, Resolver resolver) async {
    await TypeUtil.getImportList(stateType, set, resolver);
    await TypeUtil.getImportList(actionType, set, resolver);
  }

  Future<String> getCode() async {
    return "class $name extends "
        "Provider<$stateType, $actionType, $className> {\n"
        "$name(): super($className()${isLocal ? ', isLocal: true' : ''});\n"
        "}";
  }
}