// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_group_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateGroupBody extends CreateGroupBody {
  @override
  final GroupKind kind;
  @override
  final GroupTone? tone;
  @override
  final String name;
  @override
  final String? short;
  @override
  final String? gameId;
  @override
  final String place;
  @override
  final String? about;
  @override
  final BuiltList<String>? rules;
  @override
  final bool? approval;

  factory _$CreateGroupBody([void Function(CreateGroupBodyBuilder)? updates]) =>
      (CreateGroupBodyBuilder()..update(updates))._build();

  _$CreateGroupBody._(
      {required this.kind,
      this.tone,
      required this.name,
      this.short,
      this.gameId,
      required this.place,
      this.about,
      this.rules,
      this.approval})
      : super._();
  @override
  CreateGroupBody rebuild(void Function(CreateGroupBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateGroupBodyBuilder toBuilder() => CreateGroupBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateGroupBody &&
        kind == other.kind &&
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
    _$hash = $jc(_$hash, kind.hashCode);
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
    return (newBuiltValueToStringHelper(r'CreateGroupBody')
          ..add('kind', kind)
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

class CreateGroupBodyBuilder
    implements Builder<CreateGroupBody, CreateGroupBodyBuilder> {
  _$CreateGroupBody? _$v;

  GroupKind? _kind;
  GroupKind? get kind => _$this._kind;
  set kind(GroupKind? kind) => _$this._kind = kind;

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

  CreateGroupBodyBuilder() {
    CreateGroupBody._defaults(this);
  }

  CreateGroupBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
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
  void replace(CreateGroupBody other) {
    _$v = other as _$CreateGroupBody;
  }

  @override
  void update(void Function(CreateGroupBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateGroupBody build() => _build();

  _$CreateGroupBody _build() {
    _$CreateGroupBody _$result;
    try {
      _$result = _$v ??
          _$CreateGroupBody._(
            kind: BuiltValueNullFieldError.checkNotNull(
                kind, r'CreateGroupBody', 'kind'),
            tone: tone,
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'CreateGroupBody', 'name'),
            short: short,
            gameId: gameId,
            place: BuiltValueNullFieldError.checkNotNull(
                place, r'CreateGroupBody', 'place'),
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
            r'CreateGroupBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
