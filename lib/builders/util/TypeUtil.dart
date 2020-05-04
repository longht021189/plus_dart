import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:plus_dart/builders/config/Name.dart';
import 'package:plus_dart/builders/config/UriList.dart';
import 'package:uuid/uuid.dart';

class TypeUtil {
  TypeUtil._internal();

  static Uuid _uuid = Uuid();

  static String getKey(ClassElement value) {
    final key = _getKey(value);
    if (key != null) {
      return key;
    } else {
      return _uuid.v4();
    }
  }

  static String _getKey(ClassElement value) {
    for (final data in value.metadata) {
      final value = data.computeConstantValue();
      final name = value.type.element.name;

      if (name == Name.annotationReduxKey
          && data.element.librarySource.uri == UriList.annotations) {
        return value.getField('value').toStringValue();
      }
    }
    return null;
  }

  static bool isOverride(MethodElement value) {
    for (final data in value.metadata) {
      if (data.element.name == Name.annotationOverride
          && data.element.librarySource.uri == UriList.core) {
        return true;
      }
    }
    return false;
  }

  static bool isStore(ClassElement value) {
    for (final data in value.metadata) {
      if (data.element.name == Name.annotationStore
          && data.element.librarySource.uri == UriList.annotations) {
        return true;
      }
    }
    return false;
  }

  static bool isLocal(ClassElement value) {
    for (final data in value.metadata) {
      if (data.element.name == Name.annotationLocal
          && data.element.librarySource.uri == UriList.annotations) {
        return true;
      }
    }
    return false;
  }

  static Future getImportList(DartType type, Set<Uri> set, Resolver resolver) async {
    if (type.isVoid || type.isDynamic) return;

    try {
      final value = await resolver
          .assetIdForElement(type.element);

      set.add(value.uri);
    } catch (error) {}

    if (type is ParameterizedType) {
      for (final child in type.typeArguments) {
        getImportList(child, set, resolver);
      }
    }
  }

  static Future<bool> extendsReducer(ClassElement value, BuildStep buildStep) async {
    return await findReducer(value, buildStep) != null;
  }

  static Future<InterfaceType> findReducer(ClassElement value, BuildStep buildStep) async {
    for (final item in value.allSupertypes) {
      final element = item.element;
      if (element.name == Name.classNameReducer) {
        final assetId = await buildStep.resolver.assetIdForElement(element);
        if (assetId.uri == UriList.reducer) {
          return item;
        }
      }
    }
    for (final item in value.interfaces) {
      final element = item.element;
      if (element.name == Name.classNameReducer) {
        final assetId = await buildStep.resolver.assetIdForElement(element);
        if (assetId.uri == UriList.reducer) {
          return item;
        }
      }
    }
    return null;
  }

  static List<ParameterElement> getArgs(ClassElement value) {
    final method = value.constructors[0];
    final result = List<ParameterElement>();

    for (final item in method.parameters) {
      result.add(item);
    }

    return result;
  }
}