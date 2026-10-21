// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_group_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateGroupBody extends UpdateGroupBody {
  @override
  final GroupTone? tone;
  @override
  final String? name;
  @override
  final String? short;
  @override
  final String? gameId;
  @override
  final String? place;
  @override
  final String? about;
  @override
  final BuiltList<String>? rules;
  @override
  final bool? approval;

  factory _$UpdateGroupBody([void Function(UpdateGroupBodyBuilder)? updates]) =>
      (UpdateGroupBodyBuilder()..update(updates))._build();

  _$UpdateGroupBody._(
      {this.tone,
      this.name,
      this.short,
      this.gameId,
      this.place,
      this.about,
      this.rules,
      this.approval})
      : super._();
  @override
  UpdateGroupBody rebuild(void Function(UpdateGroupBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateGroupBodyBuilder toBuilder() => UpdateGroupBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateGroupBody &&
        tone == other.tone &&
        name == other.name &&
        short == other.short &&
        gameId == other.gameId &&
        place == other.place &&
        about == other.about &&
        rules == other.rules &&
        approval == other.approval;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tone.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, short.hashCode);
    _$hash = $jc(_$hash, gameId.hashCode);
    _$hash = $jc(_$hash, place.hashCode);
    _$hash = $jc(_$hash, about.hashCode);
    _$hash = $jc(_$hash, rules.hashCode);
    _$hash = $jc(_$hash, approval.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateGroupBody')
          ..add('tone', tone)
          ..add('name', name)
          ..add('short', short)
          ..add('gameId', gameId)
          ..add('place', place)
          ..add('about', about)
          ..add('rules', rules)
          ..add('approval', approval))
        .toString();
  }
}

class UpdateGroupBodyBuilder
    implements Builder<UpdateGroupBody, UpdateGroupBodyBuilder> {
  _$UpdateGroupBody? _$v;

  GroupTone? _tone;
  GroupTone? get tone => _$this._tone;
  set tone(GroupTone? tone) => _$this._tone = tone;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _short;
  String? get short => _$this._short;
  set short(String? short) => _$this._short = short;

  String? _gameId;
  String? get gameId => _$this._gameId;
  set gameId(String? gameId) => _$this._gameId = gameId;

  String? _place;
  String? get place => _$this._place;
  set place(String? place) => _$this._place = place;

  String? _about;
  String? get about => _$this._about;
  set about(String? about) => _$this._about = about;

  ListBuilder<String>? _rules;
  ListBuilder<String> get rules => _$this._rules ??= ListBuilder<String>();
  set rules(ListBuilder<String>? rules) => _$this._rules = rules;

  bool? _approval;
  bool? get approval => _$this._approval;
  set approval(bool? approval) => _$this._approval = approval;

  UpdateGroupBodyBuilder() {
    UpdateGroupBody._defaults(this);
  }

  UpdateGroupBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tone = $v.tone;
      _name = $v.name;
      _short = $v.short;
      _gameId = $v.gameId;
      _place = $v.place;
      _about = $v.about;
      _rules = $v.rules?.toBuilder();
      _approval = $v.approval;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateGroupBody other) {
    _$v = other as _$UpdateGroupBody;
  }

  @override
  void update(void Function(UpdateGroupBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateGroupBody build() => _build();

  _$UpdateGroupBody _build() {
    _$UpdateGroupBody _$result;
    try {
      _$result = _$v ??
          _$UpdateGroupBody._(
            tone: tone,
            name: name,
            short: short,
            gameId: gameId,
            place: place,
            about: about,
            rules: _rules?.build(),
            approval: approval,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rules';
        _rules?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UpdateGroupBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
