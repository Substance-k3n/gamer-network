// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_group_event_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateGroupEventBody extends CreateGroupEventBody {
  @override
  final String title;
  @override
  final DateTime startsAt;
  @override
  final String? gameId;

  factory _$CreateGroupEventBody(
          [void Function(CreateGroupEventBodyBuilder)? updates]) =>
      (CreateGroupEventBodyBuilder()..update(updates))._build();

  _$CreateGroupEventBody._(
      {required this.title, required this.startsAt, this.gameId})
      : super._();
  @override
  CreateGroupEventBody rebuild(
          void Function(CreateGroupEventBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateGroupEventBodyBuilder toBuilder() =>
      CreateGroupEventBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateGroupEventBody &&
        title == other.title &&
        startsAt == other.startsAt &&
        gameId == other.gameId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, gameId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateGroupEventBody')
          ..add('title', title)
          ..add('startsAt', startsAt)
          ..add('gameId', gameId))
        .toString();
  }
}

class CreateGroupEventBodyBuilder
    implements Builder<CreateGroupEventBody, CreateGroupEventBodyBuilder> {
  _$CreateGroupEventBody? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  String? _gameId;
  String? get gameId => _$this._gameId;
  set gameId(String? gameId) => _$this._gameId = gameId;

  CreateGroupEventBodyBuilder() {
    CreateGroupEventBody._defaults(this);
  }

  CreateGroupEventBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _startsAt = $v.startsAt;
      _gameId = $v.gameId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateGroupEventBody other) {
    _$v = other as _$CreateGroupEventBody;
  }

  @override
  void update(void Function(CreateGroupEventBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateGroupEventBody build() => _build();

  _$CreateGroupEventBody _build() {
    final _$result = _$v ??
        _$CreateGroupEventBody._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'CreateGroupEventBody', 'title'),
          startsAt: BuiltValueNullFieldError.checkNotNull(
              startsAt, r'CreateGroupEventBody', 'startsAt'),
          gameId: gameId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
