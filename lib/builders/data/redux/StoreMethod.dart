import 'package:analyzer/dart/element/type.dart';

class StoreMethod {
  final String name;
  final DartType returnType;
  final bool isAbstract;

  StoreMethod(this.name, this.returnType, { this.isAbstract = true });

  String getCode() {
    return '$returnType $name();';
  }
}