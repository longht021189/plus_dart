import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:file/file.dart';
import 'package:meta/meta.dart';
import 'package:plus_downloader/src/internal/part.dart';

class PartManager {
  static bool isTest = false;

  final String _path;
  final int _contentLength;
  final int _minPartSize;
  final _partList = List<Part>();
  final FileSystem _fileSystem;
  final bool _rangeEnabled;
  final int _maxPartCount;
  final String _url;

  List<Part> get partList => List.unmodifiable(_partList);
  String get path => _path;
  Future<void> get done => throw UnimplementedError();

  PartManager({
    @required String path,
    @required int contentLength,
    @required int minPartSize,
    @required FileSystem fileSystem,
    @required bool rangeEnabled,
    @required int maxPartCount,
    @required String url,
  }): assert(path != null)
    , assert(fileSystem != null)
    , assert(url != null)
    , assert(contentLength != null && contentLength > 0)
    , assert(minPartSize != null && minPartSize > 0)
    , _url = url
    , _maxPartCount = maxPartCount
    , _fileSystem = fileSystem
    , _minPartSize = minPartSize
    , _contentLength = contentLength
    , _path = path
    , _rangeEnabled = rangeEnabled;

  Part _createPart() {
    if (!_rangeEnabled || _maxPartCount <= 1) {
      if (_partList.length == 0) {
        return Part(
          path: _path,
          startBytes: 0,
          fileSystem: _fileSystem,
          rangeEnabled: false,
          url: _url,
        );
      } else {
        return null;
      }
    }

    final createdCount = _partList.length + 1;
    final startBytes = _findBestBytesToStart();

    if (startBytes >= 0) {
      final part = Part(
        path: '${_path}.part$createdCount',
        startBytes: startBytes,
        fileSystem: _fileSystem,
        rangeEnabled: _rangeEnabled,
        url: _url,
      );

      _partList.add(part);
      _partList.sort((a, b) => a.startBytes - b.startBytes);

      for (int i = 0; i < _partList.length - 1; ++i) {
        _partList[i].contentMax = _partList[i + 1]
            .startBytes - _partList[i].startBytes;
      }

      return part;
    } else {
      return null;
    }
  }

  Part createPart() {
    final part = _createPart();

    if (part != null) {
      part.done.then((_) => _checkAllPart());
    }

    return part;
  }

  Future<void> close() => throw UnimplementedError();

  int _findBestBytesToStart() {
    if (_partList.length == 0) {
      return 0;
    } else {
      int maxContent = -1;
      int startBytes = -1;

      for (int i = 0; i < _partList.length; ++i) {
        final start = _partList[i].startBytes + _partList[i].contentBytes;
        final end = (i + 1 == _partList.length) ? _contentLength : _partList[i + 1].startBytes;
        final content = (end - start) ~/ 2;

        if (maxContent < content && content >= _minPartSize) {
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

  void _checkAllPart() {

  }
}
