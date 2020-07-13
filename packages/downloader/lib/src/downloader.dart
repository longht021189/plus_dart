import 'dart:async';
import 'dart:math';

import 'package:file/file.dart';
import 'package:meta/meta.dart';
import 'package:plus_downloader/src/client/base_client.dart';
import 'package:plus_downloader/src/code/status_code.dart';
import 'package:plus_downloader/src/error/error.dart';
import 'package:plus_downloader/src/internal/part.dart';
import 'package:plus_downloader/src/internal/part_manager.dart';
import 'package:plus_downloader/src/request/download_request.dart';
import 'package:plus_downloader/src/response/response_stream.dart';
import 'package:plus_downloader/src/util/headers_util.dart';
import 'package:plus_downloader/src/util/unit_util.dart';

typedef void _ProcessCallback(int bytesCount);
typedef void _VoidCallback();
typedef void _ErrorCallback(dynamic error);

const _delayedWhenRetry = 5; // seconds

class Downloader {
  final BaseClient client;
  final int minSizePerPart; // Megabytes
  final int maxPartCount;
  final FileSystem fileSystem;

  Downloader({
    @required this.client,
    @required this.minSizePerPart,
    @required this.maxPartCount,
    @required this.fileSystem,
  }): assert(client != null)
    , assert(fileSystem != null)
    , assert(minSizePerPart != null && minSizePerPart > 0)
    , assert(maxPartCount != null && maxPartCount > 0);

  // region remove

  Future<void> download(String url, String path) {
    final completer = Completer();
    _download(url, path, completer);
    return completer.future;
  }

  Future<StreamSubscription> _downloadPart(
    String url,
    String path,
    String range,

    _VoidCallback onSuccess,
    _ErrorCallback onError,
    _ProcessCallback onUpdate
  ) async {
    DownloadRequest request;

    if (range != null) {
      request = DownloadRequest(url: url, headers: { 'Range': range },);
    } else {
      request = DownloadRequest(url: url);
    }

    final response = await client.get(request);

    if (range != null && response.statusCode != 206) {
      throw RequestError(
        response.statusCode, url, 
        message: 'Require 206 for each part'
      );
    } else if (range == null && response.statusCode != 200) {
      throw RequestError(
        response.statusCode, url,
        message: 'Require 200 for full part'
      );
    } else {
      final file = fileSystem.file(path);
      final subscription = response
        .stream
        .asyncMap((bytes) => file
          .writeAsBytes(bytes, mode: FileMode.append)
          .then((_) => bytes.length)
        )
        .listen((receivedByteCount) {
          onUpdate(receivedByteCount);
        });

      subscription
        ..onDone(onSuccess)
        ..onError(onError);

      return subscription;
    }
  }

  Future<void> _mergePart(String path, int count, Completer completer) async {
    try {
      if (count > 1) {
        final file = fileSystem.file('$path.part1');

        for (int i = 1; i < count; ++i) {
          final file2 = fileSystem.file('$path.part${i + 1}');
          file.writeAsBytesSync(file2.readAsBytesSync(), mode: FileMode.append);
          file2.deleteSync();
        }

        file.renameSync(path);
      }

      completer.complete();
    } catch (error) {
      completer.completeError(error);
    }
  }

  Future<void> _download(String url, String path, Completer completer) async {
    try {
      final request = DownloadRequest(url: url);
      final head = await client.head(request);

      if (head.statusCode != StatusCode.OK) {
        completer.completeError(
          RequestError(head.statusCode, url));
        return;
      }

      final headers = head.headers.map(
        (key, value) => MapEntry(
          key.toLowerCase(), 
          value.toLowerCase()
        )
      );
      final acceptRanges = headers['accept-ranges'];
      final contentLength = int.parse(headers['content-length']);
      final minLengthForSplit = minSizePerPart * 1024 * 1024;

      int partCount = 1;
      int partLength = 0;
      int successPartCount = 0;
      int receivedBytesCount = 0;

      if (acceptRanges == 'bytes' && contentLength > minLengthForSplit) {
        partCount = min((contentLength ~/ minLengthForSplit) + 1, maxPartCount);
        partLength = contentLength ~/ partCount;
      }

      final subList = List<StreamSubscription>();

      for (int i = 0; i < partCount; ++i) {
        final rangeFrom = (partCount <= 1) ? null : i * partLength;
        final rangeTo = (partCount <= 1) 
            ? null : (i + 1 == partCount) ? '' : (i + 1) * partLength - 1;

        final range = (partCount <= 1) ? null : 'bytes=$rangeFrom-$rangeTo';
        final ext = (partCount <= 1) ? '' : '.part${i + 1}';
        final sub = await _downloadPart(
          url, '$path$ext', range,

          // success
          () {
            successPartCount++;

            if (successPartCount == partCount && !completer.isCompleted) {
              _mergePart(path, partCount, completer);
            }
          },
          
          // error
          (error) {
            completer.completeError(error);

            for (final item in subList) {
              item.cancel();
            }
          },

          // update
          (bytesCount) {
            receivedBytesCount += bytesCount;
          }
        );
      
        subList.add(sub);
      }
    } catch (error) {
      completer.completeError(error);
    }
  }

  // endregion

  Future<void> download2(String url, String path) {
    final completer = Completer();
    _download2(url, path, completer);
    return completer.future;
  }

  void _reportError(dynamic error) {

  }

  Future<PartManager> _createPartManager(String url, String path) async {
    final request = DownloadRequest(url: url);
    final head = await client.head(request);

    if (head.statusCode != StatusCode.OK) {
      throw RequestError(head.statusCode, url);
    }

    final headers = HeadersUtil.getHeaders(head);
    final contentLength = HeadersUtil.getContentLength(headers);

    if (HeadersUtil.isRangeEnabled(headers, minSizePerPart)) {
      final minSize = UnitUtil.megaBytesToBytes(minSizePerPart);
      final size = min(minSize, contentLength ~/ maxPartCount);

      return PartManager(
        fileSystem: fileSystem,
        minPartSize: size ~/ 2,
        contentLength: contentLength,
        path: path,
        rangeEnabled: true,
        maxPartCount: maxPartCount,
        url: url,
      );
    } else {
      return PartManager(
        fileSystem: fileSystem,
        minPartSize: contentLength,
        contentLength: contentLength,
        path: path,
        rangeEnabled: false,
        maxPartCount: maxPartCount,
        url: url,
      );
    }
  }

  Future<void> _downloadPart2(Part part) async {
    bool isEnd = false;

    do {
      ResponseStream response;

      try {
        final headers = { 'Range': part.getRange() };
        final request = DownloadRequest(url: part.url, headers: headers);

        response = await client.get(request);

        if (response.statusCode == part.okCode) {
          final completer = Completer<void>();
          final sub = response.stream
              .listen(
                  (bytes) {
                    if (!completer.isCompleted
                        && !part.writeContent(bytes)) {
                      completer.complete();
                    }
                  },
                  onError: (error) {
                    if (!completer.isCompleted) {
                      completer.completeError(error);
                    }
                  },
                  onDone: () {
                    if (!completer.isCompleted) {
                      completer.complete();
                    }

                    part.onDone();
                  }
              );

          try {
            await completer.future;
            isEnd = true;
          } catch(error) {
            _reportError(error);
          }

          await sub?.cancel();
        }
      } catch (error) {
        _reportError(error);
      }

      response?.close();

      if (!isEnd) {
        await Future.delayed(
            Duration(seconds: _delayedWhenRetry)
        );
      }
    } while (!isEnd);
  }

  Future<void> _download2(String url, String path, Completer completer) async {
    PartManager manager;
    Part part;

    try {
      manager = await _createPartManager(url, path);

      do {
        part = manager.createPart();
        _downloadPart2(part);
      } while(part == null);

      await manager.done;
    } catch (error) {
      completer.completeError(error);
      manager?.close();
    }
  }
}
