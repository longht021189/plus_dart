import 'package:build/build.dart';
import 'package:plus_redux_generator/builders_2/redux_builder.dart';

Builder reduxBuilder(BuilderOptions options) => ReduxBuilder(options);

// import 'package:plus_redux_generator/builders/redux/ReduxPrepare.dart';
// import 'package:plus_redux_generator/builders/redux/ReduxGenerator.dart';
// Builder reduxGenerator(BuilderOptions options) => ReduxGenerator();
// Builder reduxPrepare(BuilderOptions options) => ReduxPrepare();
// PostProcessBuilder allCleanup(BuilderOptions options) => 
//     PostProcessBuilderWrapper('all_cleanup', const FileDeletingBuilder([FileExtensions.Provider]));
