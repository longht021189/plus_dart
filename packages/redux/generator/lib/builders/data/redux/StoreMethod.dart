import 'package:analyzer/dart/element/type.dart';

class StoreMethod {
  final String name;
  final DartType returnType;
  final bool isStatic;
  final bool isGetter;

  StoreMethod(this.name, this.returnType, { 
    this.isStatic = false, 
    this.isGetter = false 
  });

  String getCall() {
    return '_data?.$name${isGetter ? '' : '()'}';
  }
}