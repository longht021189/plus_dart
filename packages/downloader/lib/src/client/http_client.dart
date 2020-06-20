import 'package:http/http.dart' as http;
import 'package:plus_downloader/src/client/base_client.dart';
import 'package:plus_downloader/src/request/download_request.dart';
import 'package:plus_downloader/src/response/response_stream.dart';

class HttpClient extends BaseClient {
  final http.Client _client;

  HttpClient({
    http.Client client
  }): _client = client ?? http.Client();

  @override
  Future<ResponseStream> get(DownloadRequest request) async {
    final req = http.Request('GET', Uri.parse(request.url));
    
    if (request.headers != null && request.headers.length > 0) {
      req.headers.addAll(request.headers);
    }

    final response = await _client.send(req);

    return ResponseStream(
      stream: response.stream,
      statusCode: response.statusCode,
      contentLength: response.contentLength,
      headers: response.headers
    );
  }

  @override
  Future<ResponseStream> head(DownloadRequest request) async {
    final value = await _client.head(request.url);

    return ResponseStream(
      headers: value.headers,
      contentLength: value.contentLength,
      statusCode: value.statusCode,
    );
  }

  @override
  Future<String> getString(String url) async {
    return (await _client.get(url)).body;
  }
}