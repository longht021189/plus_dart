import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

class GetClasses extends SimpleElementVisitor<dynamic> {
  List<ClassElement> _value = List();
  List<ClassElement> get value => List.unmodifiable(_value);

  @override
  dynamic visitCompilationUnitElement(CompilationUnitElement element) {
    _value.addAll(element.types);
  }
}