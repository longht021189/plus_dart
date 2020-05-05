import 'dart:collection';

import 'package:build/build.dart';
import 'package:plus_redux_generator/builders/config/UriList.dart';
import 'package:plus_redux_generator/builders/data/redux/ProviderData.dart';
import 'package:plus_redux_generator/builders/util/CodeUtil.dart';

class ProviderFileData {
  final List<ProviderData> classDataList;
  final AssetId source;

  ProviderFileData(this.classDataList, this.source);

  Future<String> getCode(Resolver resolver) async {
    final imports = HashSet<Uri>();

    for (final data in classDataList) {
      await data.getImportList(imports, resolver);
    }

    imports.add(source.uri);
    imports.add(UriList.base);

    final code = StringBuffer();
    code.writeln(CodeUtil.importFiles(imports));

    for (final data in classDataList) {
      code.writeln(await data.getCode());
    }

    return code.toString();
  }
}