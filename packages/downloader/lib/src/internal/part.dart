import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:file/file.dart';
import 'package:meta/meta.dart';
import 'package:plus_downloader/src/internal/part_manager.dart';

// ignore: must_be_immutable
class Part extends Equatable {
  final String      _path;
  final int         _startBytes;
  final FileSystem  _fileSystem;
  final bool        _rangeEnabled;
  final String      _url;

  final Completer<void> _completer = Completer();

  File _file;
  int _contentMax = -1;
  int _contentBytes = 0;

  Part({
    @required String path,
    @required int startBytes,
    @required FileSystem fileSystem,
    @required bool rangeEnabled,
    @required String url,
  }): assert(path != null)
    , assert(startBytes != null && startBytes >= 0)
    , _path = path
    , _startBytes = startBytes
    , _fileSystem = fileSystem
    , _rangeEnabled = rangeEnabled
    , _url = url
    , super();

  String getRange() {
    if (!_rangeEnabled) {
      return null;
    }
    if (_contentMax == null || _contentMax < 0) {
      return "bytes=${_startBytes}-";
    } else {
      return "bytes=${_startBytes}-${_startBytes + _contentMax - 1}";
    }
  }

  bool writeContent(List<int> value) {
    if (!PartManager.isTest && _file == null) {
      _file = _fileSystem.file(_path);
    }

    final total = _contentBytes + value.length;

    List<int> list;
    bool isNotDone;

    if (_contentMax != null && _contentMax < total) {
      final end = value.length - (total - _contentMax);

      _contentBytes = _contentMax;

      list = value.sublist(0, end);
      isNotDone = false;
    } else {
      _contentBytes = total;

      list = value;
      isNotDone = true;
    }
    if (list != null && list.isNotEmpty && _file != null) {
      _file.writeAsBytesSync(
          list, mode: FileMode.append);
    }

    if (!isNotDone) {
      if (!_completer.isCompleted) {
        _completer.complete();
      }
      return false;
    } else {
      return true;
    }
  }

  // Getter
  int           get startBytes    => _startBytes;
  int           get contentBytes  => _contentBytes;
  String        get path          => _path;
  int           get okCode        => _rangeEnabled ? 206 : 200;
  String        get url           => _url;
  Future<void>  get done          => _completer.future;
  bool          get isDone        => _completer.isCompleted;

  // Setter
  void set contentMax(int value) {
    _contentMax = value;
  }

  void onDone() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }

  @override
  List<Object> get props => [_path, _startBytes, _contentBytes, _contentMax];

  @override
  bool get stringify => true;
}