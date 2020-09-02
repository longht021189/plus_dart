import 'package:equatable/equatable.dart';

class RequestError extends Equatable {

  final int statusCode;
  final String url;
  final String message;

  RequestError(this.statusCode, this.url, { this.message });

  @override
  List<Object> get props => [statusCode, url, message];
  
  @override
  bool get stringify => true;
}