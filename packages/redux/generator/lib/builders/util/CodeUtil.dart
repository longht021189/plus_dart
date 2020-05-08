import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';

class CodeUtil {
  CodeUtil._internal();

  static final _headerLine = '// '.padRight(77, '*');
  static final _header = '// GENERATED CODE - DO NOT MODIFY BY HAND';
  static final _formatter = DartFormatter(fixes: StyleFix.all);

  static Future writeToFile(BuildStep buildStep, AssetId output, String code) async {
    final contents = StringBuffer();

    contents
      ..writeln()
      ..writeln(_headerLine)
      ..writeln(_header)
      ..writeln(_headerLine)
      ..writeln()
      ..writeln(code);

    // TODO fix cannot add uri in formatter in windows
    await buildStep.writeAsString(output,
        _formatter.format(contents.toString()/*, uri: output.uri*/));
  }

  static String importFile(Uri uri) {
    return "import '$uri';";
  }

  static String importFiles(Set<Uri> uriList) {
    return uriList.map((uri) { return importFile(uri); }).join('\n');
  }

  static String singleton(String typeName) {
    final code = StringBuffer()
      ..writeln('static $typeName _instance;')
      ..writeln()
      ..writeln('factory $typeName() {')
      ..writeln('if (_instance == null) { _instance = $typeName._internal(); }')
      ..writeln('return _instance;')
      ..writeln('}')
      ..writeln()
      ..writeln('$typeName._internal();');

    return code.toString();
  }
}