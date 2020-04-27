import 'package:build/build.dart';
import 'package:plus_generator/builders/redux/ProviderBuilder.dart';
import 'package:plus_generator/builders/redux/StoreBuilder.dart';

Builder reduxReducerProviderGenerator(BuilderOptions options) => ProviderBuilder();

Builder reduxStoreGenerator(BuilderOptions options) => StoreBuilder();