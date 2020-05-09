import 'package:build/build.dart';
import 'package:plus_redux_generator/builders/redux/ReduxPrepare.dart';
import 'package:plus_redux_generator/builders/redux/ReduxGenerator.dart';

Builder reduxGenerator(BuilderOptions options) => ReduxGenerator();

Builder reduxPrepare(BuilderOptions options) => ReduxPrepare();
