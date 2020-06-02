import 'package:analyzer/dart/element/type.dart';

class StoreMethod {
  final String name;
  final DartType returnType;
  final bool isStatic;
  final bool isGetter;
  final bool isIStore;

  StoreMethod(this.name, this.returnType, { 
    this.isStatic = false, 
    this.isGetter = false,
    this.isIStore = false,
  });

  String getCall() {
    if (isIStore) {
      return 'this';
    }
    
    return '_data?.$name${isGetter ? '' : '()'}';
  }
}