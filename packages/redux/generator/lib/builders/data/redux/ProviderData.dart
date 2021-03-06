import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:plus_redux_generator/builders/config/Name.dart';
import 'package:plus_redux_generator/builders/util/TypeUtil.dart';

class ProviderData {
  final ClassElement classType;
  final DartType stateType;
  final DartType actionType;
  final String name;
  final String className;
  final String key;
  final bool isLazy;
  final bool isLocal;
  final List<ParameterElement> args;

  ProviderData(this.classType, this.stateType, this.actionType)
      : name = Name.getProviderName(classType)
      , className = classType.name
      , key = TypeUtil.getKey(classType)
      , isLocal = TypeUtil.isLocal(classType)
      , isLazy = true
      , args = TypeUtil.getArgs(classType);

  Future getImportList(Set<Uri> set, Resolver resolver) async {
    await TypeUtil.getImportList(stateType, set, resolver);
    await TypeUtil.getImportList(actionType, set, resolver);

    for (final item in args) {
      await TypeUtil.getImportList(item.type, set, resolver);
    }
  }

  String _getArgs1() {
    if (args.isEmpty) return '';

    final code = StringBuffer();

    for (int i = 0; i < args.length; ++i) {
      if (i > 0) {
        code.write(', ');
      }

      final item = args[i];
      final name = Name.getParamName(i);
      final type = item.type;

      code.write('$type $name');
    }

    return code.toString();
  }

  String _getArgs2() {
    if (args.isEmpty) return '';

    final code = StringBuffer();

    for (int i = 0; i < args.length; ++i) {
      if (i > 0) {
        code.write(', ');
      }

      final item = args[i];

      if (item.isRequiredNamed) {
        code.write('${item.name}: ${Name.getParamName(i)}');
      } else {
        code.write(Name.getParamName(i));
      }
    }

    return code.toString();
  }

  Future<String> getCode() async {
    final local = isLocal ? ', isLocal: true' : '';

    final code = StringBuffer()
      ..writeln('class $name extends ReducerProvider<$stateType, $actionType, $className> {')
      ..writeln('$name.createWith($className reducer): super(reducer $local);')
      ..writeln('$name(${_getArgs1()}): super($className(${_getArgs2()}) $local);')
      ..writeln('static const key = \'$key\';')
      ..writeln('}');

    return code.toString();
  }
}