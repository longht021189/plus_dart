import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:file/file.dart';
import 'package:meta/meta.dart';
import 'package:plus_downloader/src/client/base_client.dart';
import 'package:plus_downloader/src/code/status_code.dart';
import 'package:plus_downloader/src/error/error.dart';
import 'package:plus_downloader/src/request/download_request.dart';

typedef void _ProcessCallback(int bytesCount);
typedef void _VoidCallback();
typedef void _ErrorCallback(dynamic error);

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
}

class PartManager {
  final String path;
  final int contentLength;
  final int minPartSize;
  final partList = List<Part>();
  final FileSystem fileSystem;

  PartManager({
    @required this.path,
    @required this.contentLength,
    @required this.minPartSize,
    @required this.fileSystem,
  }): assert(path != null)
    , assert(fileSystem != null)
    , assert(contentLength != null && contentLength > 0)
    , assert(minPartSize != null && minPartSize > 0);

  Part createPart() {
    final createdCount = partList.length + 1;
    final startBytes = findBestBytesToStart();

    if (startBytes >= 0) {
      final part = Part(
        path: '${path}.part$createdCount',
        startBytes: startBytes,
        fileSystem: fileSystem
      );

      partList.add(part);
      partList.sort((a, b) => a.startBytes - b.startBytes);

      for (int i = 0; i < partList.length - 1; ++i) {
        partList[i].updateContentMax(
            partList[i + 1].startBytes - partList[i].startBytes);
      }

      return part;
    } else {
      return null;
    }
  }

  int findBestBytesToStart() {
    if (partList.length == 0) {
      return 0;
    } else {
      int maxContent = -1;
      int startBytes = -1;

      for (int i = 0; i < partList.length; ++i) {
        final start = partList[i].startBytes + partList[i].contentBytes;
        final end = (i + 1 == partList.length) ? contentLength : partList[i + 1].startBytes;
        final content = (end - start) ~/ 2;

        if (maxContent < content && content >= minPartSize) {
          maxContent = content;
          startBytes = start + content;
        }
      }

      if (maxContent > 0) {
        return startBytes;
      } else {
        return -1;
      }
    }
  }
}

// ignore: must_be_immutable
class Part extends Equatable {
  final String path;
  final int startBytes;
  final FileSystem fileSystem;

  File _file;

  int _contentMax = -1;
  int get contentMax => _contentMax;

  int _contentBytes = 0;
  int get contentBytes => _contentBytes;

  Part({
    @required this.path,
    @required this.startBytes,
    @required this.fileSystem,
  }): assert(path != null)
    , assert(startBytes != null && startBytes >= 0)
    , super();

  String getRange() {
    if (_contentMax == null || _contentMax < 0) {
      return "bytes=${startBytes}-";
    } else {
      return "bytes=${startBytes}-${startBytes + _contentMax - 1}";
    }
  }

  void updateContentMax(int value) {
    _contentMax = value;
  }

  bool writeContent(List<int> value) {
    if (_file == null) {
      _file = fileSystem.file(path);
    }

    final total = _contentBytes + value.length;

    List<int> list;
    bool result = true;

    if (_contentMax != null && _contentMax < total) {
      final end = value.length - (total - _contentMax);

      _contentBytes = _contentMax;

      list = value.sublist(0, end);
      result = false;
    } else {
      _contentBytes = total;

      list = value;
      result = true;
    }
    if (list != null && list.isNotEmpty) {
      _file.writeAsBytesSync(
          list, mode: FileMode.append);
    }

    return result;
  }

  @override
  List<Object> get props => [path, startBytes, _contentBytes, _contentMax];

  @override
  bool get stringify => true;
}
