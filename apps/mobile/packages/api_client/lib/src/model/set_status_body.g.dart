// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_status_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SetStatusBody extends SetStatusBody {
  @override
  final PlayerStatus status;
  @override
  final BuiltSet<Day>? availableDays;
  @override
  final String? gameId;

  factory _$SetStatusBody([void Function(SetStatusBodyBuilder)? updates]) =>
      (SetStatusBodyBuilder()..update(updates))._build();

  _$SetStatusBody._({required this.status, this.availableDays, this.gameId})
      : super._();
  @override
  SetStatusBody rebuild(void Function(SetStatusBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SetStatusBodyBuilder toBuilder() => SetStatusBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetStatusBody &&
        status == other.status &&
        availableDays == other.availableDays &&
        gameId == other.gameId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, availableDays.hashCode);
    _$hash = $jc(_$hash, gameId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SetStatusBody')
          ..add('status', status)
          ..add('availableDays', availableDays)
          ..add('gameId', gameId))
        .toString();
  }
}

class SetStatusBodyBuilder
    implements Builder<SetStatusBody, SetStatusBodyBuilder> {
  _$SetStatusBody? _$v;

  PlayerStatus? _status;
  PlayerStatus? get status => _$this._status;
  set status(PlayerStatus? status) => _$this._status = status;

  SetBuilder<Day>? _availableDays;
  SetBuilder<Day> get availableDays =>
      _$this._availableDays ??= SetBuilder<Day>();
  set availableDays(SetBuilder<Day>? availableDays) =>
      _$this._availableDays = availableDays;

  String? _gameId;
  String? get gameId => _$this._gameId;
  set gameId(String? gameId) => _$this._gameId = gameId;

  SetStatusBodyBuilder() {
    SetStatusBody._defaults(this);
  }

  SetStatusBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _availableDays = $v.availableDays?.toBuilder();
      _gameId = $v.gameId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetStatusBody other) {
    _$v = other as _$SetStatusBody;
  }

  @override
  void update(void Function(SetStatusBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetStatusBody build() => _build();

  _$SetStatusBody _build() {
    _$SetStatusBody _$result;
    try {
      _$result = _$v ??
          _$SetStatusBody._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'SetStatusBody', 'status'),
            availableDays: _availableDays?.build(),
            gameId: gameId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'availableDays';
        _availableDays?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SetStatusBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
