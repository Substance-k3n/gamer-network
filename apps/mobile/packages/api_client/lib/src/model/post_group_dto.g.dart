// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_group_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PostGroupDto extends PostGroupDto {
  @override
  final GroupTone tone;
  @override
  final String id;
  @override
  final String name;
  @override
  final String short;

  factory _$PostGroupDto([void Function(PostGroupDtoBuilder)? updates]) =>
      (PostGroupDtoBuilder()..update(updates))._build();

  _$PostGroupDto._(
      {required this.tone,
      required this.id,
      required this.name,
      required this.short})
      : super._();
  @override
  PostGroupDto rebuild(void Function(PostGroupDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PostGroupDtoBuilder toBuilder() => PostGroupDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PostGroupDto &&
        tone == other.tone &&
        id == other.id &&
        name == other.name &&
        short == other.short;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tone.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, short.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PostGroupDto')
          ..add('tone', tone)
          ..add('id', id)
          ..add('name', name)
          ..add('short', short))
        .toString();
  }
}

class PostGroupDtoBuilder
    implements Builder<PostGroupDto, PostGroupDtoBuilder> {
  _$PostGroupDto? _$v;

  GroupTone? _tone;
  GroupTone? get tone => _$this._tone;
  set tone(GroupTone? tone) => _$this._tone = tone;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _short;
  String? get short => _$this._short;
  set short(String? short) => _$this._short = short;

  PostGroupDtoBuilder() {
    PostGroupDto._defaults(this);
  }

  PostGroupDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tone = $v.tone;
      _id = $v.id;
      _name = $v.name;
      _short = $v.short;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PostGroupDto other) {
    _$v = other as _$PostGroupDto;
  }

  @override
  void update(void Function(PostGroupDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PostGroupDto build() => _build();

  _$PostGroupDto _build() {
    final _$result = _$v ??
        _$PostGroupDto._(
          tone: BuiltValueNullFieldError.checkNotNull(
              tone, r'PostGroupDto', 'tone'),
          id: BuiltValueNullFieldError.checkNotNull(id, r'PostGroupDto', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'PostGroupDto', 'name'),
          short: BuiltValueNullFieldError.checkNotNull(
              short, r'PostGroupDto', 'short'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
