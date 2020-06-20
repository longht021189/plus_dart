// import 'package:test/test.dart';
// import 'package:plus_downloader/downloader.dart';

import 'package:plus_downloader/downloader.dart';

void main() async {
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

  final manager = PartManager(
    path: "/ABC/EED.zip",
    contentLength: 50,
    minPartSize: 5,
  );

  Part part;
  int i = 0;

  do {
    part = manager.createPart();
    print(manager.partList.join());
  } while (part != null);
}