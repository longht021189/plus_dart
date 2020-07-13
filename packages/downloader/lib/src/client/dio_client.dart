import 'dart:async';
import 'package:plus_downloader/downloader.dart';
import 'package:plus_downloader/src/request/download_request.dart';
import 'package:plus_downloader/src/response/response_stream.dart';
import 'package:dio/dio.dart' as dio;

const _connectTimeout = 20000;
const _receiveTimeout = 20000;
const _sendTimeout = 20000;

class DioClient extends BaseClient {

  final _dio = dio.Dio(dio.BaseOptions(
    connectTimeout: _connectTimeout,
    receiveTimeout: _receiveTimeout,
    sendTimeout: _sendTimeout,
  ));

  @override
  Future<ResponseStream> get(DownloadRequest request) async {
    final response = _ResponseStream();
    final options = dio.Options(
      headers: request.headers,
      followRedirects: true,
      responseType: dio.ResponseType.stream,
    );

    _dio.get(
      request.url,
      options: options,
      cancelToken: response._cancelToken,
    ).then((value) => response._onResponse(value))
        .catchError((error) => response._onError(error))
        .whenComplete(() => response._onComplete());

    return response;
  }

  @override
  Future<String> getString(String url) {
    // TODO: implement getString
    throw UnimplementedError();
  }

  @override
  Future<ResponseStream> head(DownloadRequest request) async {
    final options = dio.Options(
      headers: request.headers,
      followRedirects: true,
      responseType: dio.ResponseType.stream,
    );
    final cancelToken = dio.CancelToken();
    final dio.Response<dio.ResponseBody> response = await _dio.head(
      request.url,
      options: options,
      cancelToken: cancelToken,
    );

    response.data;

    // TODO: implement head
    throw UnimplementedError();
  }
}

class _ResponseStream extends ResponseStream {

  final _completer = Completer<void>();
  final _cancelToken = dio.CancelToken();

  int _statusCode = -1;
  int _contentLength = -1;
  Stream<List<int>> _stream;
  Map<String, String> _headers;
  bool _isDone = false;

  @override
  int get contentLength => _contentLength;

  @override
  Map<String, String> get headers => _headers;

  @override
  Future<void> get ready => _completer.future;

  @override
  int get statusCode => _statusCode;

  @override
  Stream<List<int>> get stream => _stream;

  @override
  void close() {
    if (_isDone) return;

    _isDone = true;
    _cancelToken.cancel();
    _completer.complete();
  }

  void _onComplete() {
    close();
  }

  void _onError(dynamic error) {
    if (_isDone) return;

    _isDone = true;
    _cancelToken.cancel();
    _completer.completeError(error);
  }

  void _onResponse(dio.Response<dio.ResponseBody> value) {
    _statusCode = value.statusCode;
    _contentLength = ;
  }
}
