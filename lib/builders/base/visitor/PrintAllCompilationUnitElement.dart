import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';

class PrintAllCompilationUnitElement extends SimpleElementVisitor<dynamic> {
  @override
  dynamic visitCompilationUnitElement(CompilationUnitElement element) {
    log.info(' topLevelVariables: ${element.accessors.join(', ')}');
  }
}