import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class DownloadRequest extends Equatable {

  final String url;
  final Map<String, String> headers;

  DownloadRequest({
    @required this.url,
    this.headers,
  }): assert(url != null)
    , super();

  @override
  List<Object> get props => [url];

  @override
  bool get stringify => true;
}