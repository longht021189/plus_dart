import 'package:equatable/equatable.dart';

typedef void VoidCallback();

abstract class ResponseStream {
  void close();

  Future<void> get ready;
  Map<String, String> get headers;
  Stream<List<int>> get stream;
  int get statusCode;
  int get contentLength;
}
