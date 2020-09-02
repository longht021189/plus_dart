import 'package:plus_downloader/src/response/response_stream.dart';
import 'package:plus_downloader/src/util/unit_util.dart';

class HeadersUtil {
  HeadersUtil._();

  static Map<String, String> getHeaders(ResponseStream response) {
    return response.headers.map((key, value) => MapEntry(
      key.toLowerCase(), value.toLowerCase(),
    ));
  }

  static int getContentLength(Map<String, String> headers) {
    return int.parse(headers['content-length']);
  }

  static bool isRangeEnabled(Map<String, String> headers, int megaBytes) {
    final acceptRanges = headers['accept-ranges'];
    final contentLength = getContentLength(headers);
    final minLengthForSplit = UnitUtil.megaBytesToBytes(megaBytes);

    if (acceptRanges == 'bytes' && contentLength > minLengthForSplit) {
      return true;
    } else {
      return false;
    }
  }
}