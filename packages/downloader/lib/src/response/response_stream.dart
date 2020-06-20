import 'package:equatable/equatable.dart';

class ResponseStream extends Equatable {

  final Map<String, String> headers;
  final Stream<List<int>> stream;
  final int statusCode;
  final int contentLength;

  ResponseStream({
    this.headers,
    this.stream,
    this.statusCode,
    this.contentLength,
  }): super();

  @override
  List<Object> get props => [statusCode, contentLength, headers, stream];
  
  @override
  bool get stringify => true;
}