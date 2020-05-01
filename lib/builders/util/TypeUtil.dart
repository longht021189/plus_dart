import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:plus_dart/builders/config/Name.dart';
import 'package:plus_dart/builders/config/UriList.dart';

class TypeUtil {
  TypeUtil._internal();

  static bool isLazy(ClassElement value) {
    for (final data in value.metadata) {
      if (data.element.name == Name.annotationLazy
          && data.element.librarySource.uri == UriList.annotations) {
        return true;
      }
    }
    return isLocal(value);
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
}