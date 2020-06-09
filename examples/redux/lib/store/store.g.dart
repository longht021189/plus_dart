// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StoreData extends StoreData {
  @override
  final String appKey;
  @override
  final double abc;
  @override
  final int fff;

  factory _$StoreData([void Function(StoreDataBuilder) updates]) =>
      (new StoreDataBuilder()..update(updates)).build();

  _$StoreData._({this.appKey, this.abc, this.fff}) : super._() {
    if (appKey == null) {
      throw new BuiltValueNullFieldError('StoreData', 'appKey');
    }
    if (abc == null) {
      throw new BuiltValueNullFieldError('StoreData', 'abc');
    }
    if (fff == null) {
      throw new BuiltValueNullFieldError('StoreData', 'fff');
    }
  }

  @override
  StoreData rebuild(void Function(StoreDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StoreDataBuilder toBuilder() => new StoreDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StoreData &&
        appKey == other.appKey &&
        abc == other.abc &&
        fff == other.fff;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, appKey.hashCode), abc.hashCode), fff.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('StoreData')
          ..add('appKey', appKey)
          ..add('abc', abc)
          ..add('fff', fff))
        .toString();
  }
}

class StoreDataBuilder implements Builder<StoreData, StoreDataBuilder> {
  _$StoreData _$v;

  String _appKey;
  String get appKey => _$this._appKey;
  set appKey(String appKey) => _$this._appKey = appKey;

  double _abc;
  double get abc => _$this._abc;
  set abc(double abc) => _$this._abc = abc;

  int _fff;
  int get fff => _$this._fff;
  set fff(int fff) => _$this._fff = fff;

  StoreDataBuilder();

  StoreDataBuilder get _$this {
    if (_$v != null) {
      _appKey = _$v.appKey;
      _abc = _$v.abc;
      _fff = _$v.fff;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StoreData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$StoreData;
  }

  @override
  void update(void Function(StoreDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$StoreData build() {
    final _$result =
        _$v ?? new _$StoreData._(appKey: appKey, abc: abc, fff: fff);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
