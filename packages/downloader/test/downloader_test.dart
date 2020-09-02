// import 'package:test/test.dart';
// import 'package:plus_downloader/downloader.dart';

import 'package:plus_downloader/downloader.dart';
import 'package:plus_downloader/src/internal/part_manager.dart';
import 'package:test/test.dart';

void _testPartManagerNotRange() {
  final contentLength = 50;
  final minPartSize = 10;
  final manager = PartManager(
    path: "/ABC/EED.zip",
    contentLength: contentLength,
    minPartSize: minPartSize,
    fileSystem: LocalFileSystem(),
    rangeEnabled: false,
  );

  Part part;

  do {
    part = manager.createPart();

    expect(
      manager.partList.length,
      equals(1),
      reason: "Part Manager cannot split",
    );

    if (part != null) {
      expect(
        part.path,
        equals(manager.path),
        reason: "Part Manager has same path with Part",
      );
    }
  } while (part != null);
}

void _testPartManagerRangeEnabled() async {
  final contentLength = 50;
  final minPartSize = 10;
  final manager = PartManager(
    path: "/ABC/EED.zip",
    contentLength: contentLength,
    minPartSize: minPartSize,
    fileSystem: LocalFileSystem(),
    rangeEnabled: true,
  );

  Part part;

  do {
    part = manager.createPart();
    if (part != null) {
      expect(
        manager.partList.length != 1 || (part.startBytes == 0),
        equals(true),
        reason: "First Part starts with 0 byte index",
      );

      expect(
        manager.partList.length != 2 || (part.startBytes == contentLength ~/ 2),
        equals(true),
        reason: "Second Part starts with half of contentLength",
      );

      if (manager.partList.length == 2) {
        manager.partList[0].writeContent(
            List.generate(contentLength ~/ 3, (_) => 0));
      }

      expect(
        manager.partList.length != 3 || (part.startBytes > contentLength ~/ 2),
        equals(true),
        reason: "Third Part starts alter second part",
      );
    }
  } while (part != null);
}

void main() async {
  setUp(() {
    PartManager.isTest = true;
  });

  test('Part Manager: Not Range', _testPartManagerNotRange);
  test('Part Manager: Range Enabled', _testPartManagerRangeEnabled);

  /*final downloader = YoutubeDownloader(
    fileSystem: LocalFileSystem(),
    client: HttpClient(),
    maxPartCount: 5,
    minSizePerPart: 5,
  );
  await downloader.downloadPlaylist(
    'https://www.youtube.com/playlist?list=PLlpAWCqcstzqe7Qp5CUIAxGfCfBxuqJCl', 
    '/Users/thanhlong/Downloads'
  );*/
}