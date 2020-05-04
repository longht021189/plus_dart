import 'package:analyzer/dart/element/element.dart';

class Name {
  Name._internal();

  static String annotationOverride = "override";
  static String annotationLazy = "lazy";
  static String annotationStore = "store";
  static String annotationReduxKey = "ReduxKey";
  static String annotationLocal = "local";
  static String methodSendAction = "sendAction";
  static String methodSendActionParam = "value";
  static String classStore = "Store";
  static String classNameReducer = 'Reducer';

  static String getStoreVariableName(String typeName) {
    return "_var$typeName";
  }

  static String getProviderName(ClassElement targetType) {
    return "${targetType.name}Provider";
  }

  static String getParamName(int index) {
    return 'param_$index';
  }
}