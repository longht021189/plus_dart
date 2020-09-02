import 'dart:async';
import 'dart:convert';

import 'package:file/file.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:plus_downloader/src/client/base_client.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import './downloader.dart';

class YoutubeDownloader {

  final Downloader downloader;
  final YoutubeExplode explode;
  // final dio = Dio();

  YoutubeDownloader({
    @required BaseClient client,
    @required int minSizePerPart,
    @required int maxPartCount,
    @required FileSystem fileSystem,
  }): explode = YoutubeExplode()
    , downloader = Downloader(
      client: client, 
      minSizePerPart: minSizePerPart, 
      maxPartCount: maxPartCount, 
      fileSystem: fileSystem
    );

  /*Future<void> downloadVideoFromY2Mate(
    String videoId,
    String dirPath, {
      String fileName
  }) async {
    final num = 10;

    final urlAnalyze = 'https://mate${num}.y2mate.com/en2/analyze/ajax';
    final formDataAnalyze = FormData.fromMap({
      'url': 'https://www.youtube.com/watch?v=${videoId}',
      'q_auto': '0',
      'ajax': '1',
    });
    final respAnalyze = await dio.post(urlAnalyze, data: formDataAnalyze);
  }*/

  Future<void> downloadVideo(
    String videoId, 
    String dirPath, { 
      String fileName 
  }) async {
    final url = 'https://www.youtube.com/get_video_info?video_id=$videoId&asv=3&el=detailpage&hl=en_US';
    final response = await downloader.client.getString(url);
    final lines = response.split('&').map((e) => e.trim());
    final playerResponse = 'player_response=';
    final playerResponseData = lines.firstWhere((element) => element.startsWith(playerResponse));

    assert(playerResponseData != null);

    final encodedData = playerResponseData.substring(playerResponse.length);
    final data = Uri.decodeFull(encodedData);
    final map = jsonDecode(data);

    assert(map != null);

    final title = map['videoDetails']['title'].toString().replaceAll('+', ' ');
    final formats = map['streamingData']['formats'];

    String videoUrl;
    double resolution = 0.0;

    for (final item in formats) {
      final url = item['url'];
      final width = item['width'];
      final height = item['height'];
      final itemResolution = width * height * 1.0;

      if (itemResolution > resolution) {
        resolution = itemResolution;
        videoUrl = url;
      }
    }

    if (videoUrl != null) {
      final name = fileName ?? '$title.$videoId.mp4';
      final path = p.join(dirPath, name);

      await downloader.download(videoUrl, path);
    }
  }

  Future<void> downloadPlaylist(
    String idOrUrl, 
    String dirPath, { 
      String folderName 
  }) async {
    final playlist = await explode
      .playlists.get(PlaylistId.fromString(idOrUrl));

    final name = folderName ?? '${playlist.title}.${playlist.id.value}';
    final path = p.join(dirPath, name);
    final dir = downloader.fileSystem.directory(path);

    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    } 

    StreamSubscription subscription;

    final completer = Completer<void>();

    subscription = explode.playlists
      .getVideos(playlist.id)
      .asyncMap((video) => downloadVideo(
        video.id.value,
        path,
        fileName: '${video.title}.${video.id.value}.mp4'
      ))
      .listen((_) {}, onError: (error) {
        completer.completeError(error);
        subscription.cancel();
      });

    subscription.onDone(() {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });
    
    return completer.future;
  }

  Future<void> close() async {
    explode.close();
  }
}

// TODO Test
/*final dio = Dio();




    print(resp.data);*/

// Step 2
// final dio = Dio();
/*final url = 'https://mate03.y2mate.com/en2/convert';
    final data = FormData.fromMap({
      'type': 'youtube',
      '_id': '5ec9e5077527f8950c8b457a',
      'v_id': 'SRsSUH2ogsc',
      'ajax': '1',
      'ftype': 'mp4',
      'fquality': '1080',
    });
    final resp = await dio.post(url, data: data);

    print(resp.data);*/

// Step 3
/*final dio = Dio();
    final url = 'https://mate03.y2mate.com/checkdone2.php';
    final data = FormData.fromMap({
      'type': 'youtube',
      'id': '5eeae12fd684ebf3628b456a',
      'v_id': 'SRsSUH2ogsc',
      'ajax': '1',
    });
    final resp = await dio.post(url, data: data);

    print(resp.data);*/

/*final videoId = 'gOlYZuz5H5U';
    final num = 10;

    final urlAnalyze = 'https://mate${num}.y2mate.com/en2/analyze/ajax';
    final formDataAnalyze = FormData.fromMap({
      'url': 'https://www.youtube.com/watch?v=${videoId}',
      'q_auto': '0',
      'ajax': '1',
    });
    final respAnalyze = await dio.post<String>(urlAnalyze, data: formDataAnalyze);
    final jsonAnalyze = jsonDecode(respAnalyze.data);
    final docAnalyze = parse(jsonAnalyze['result'], encoding: 'utf-8');

    final scriptsAnalyze = docAnalyze
        .getElementsByTagName("script")
        .map((e) => e.innerHtml.trim());

    final regExp = RegExp(r'[^\w_]');

    for (final script in scriptsAnalyze) {
      final parts = script.split(',').map((e) => e.trim());
      for (final part in parts) {
        final items = part.split(regExp)
            .map((e) => e.trim())
            .where((element) => element.length > 0);

        if (items.length >= 2 && items.first == '_id') {
          print(items.join(' - '));
        }
      }
    }*/


/*print(docAnalyze
        .getElementsByTagName("script")
        .map((e) => e.innerHtml)
        .where((element) => element.contains('y2mate.com/en2/convert'))
        .join("\n\n\n"));*/

// return;