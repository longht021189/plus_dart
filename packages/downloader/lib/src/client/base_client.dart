import 'package:plus_downloader/src/request/download_request.dart';
import 'package:plus_downloader/src/response/response_stream.dart';

abstract class BaseClient {
  Future<String> getString(String url);
  Future<ResponseStream> get(DownloadRequest request);
  Future<ResponseStream> head(DownloadRequest request);
}