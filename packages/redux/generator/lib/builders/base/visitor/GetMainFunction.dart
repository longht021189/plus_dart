import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

class GetMainFunction extends SimpleElementVisitor<dynamic> {
  FunctionElement _value;
  FunctionElement get value => _value;

  @override
  dynamic visitCompilationUnitElement(CompilationUnitElement element) {
    for (final func in element.functions) {
      if (func.name == 'main'
          && func.returnType.isVoid
          && func.parameters.isEmpty) {
        _value = func;
        return;
      }
    }
  }
}