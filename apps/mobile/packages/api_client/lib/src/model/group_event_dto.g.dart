// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_event_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GroupEventDto extends GroupEventDto {
  @override
  final String id;
  @override
  final String groupId;
  @override
  final String title;
  @override
  final DateTime startsAt;
  @override
  final GameRefDto? game;
  @override
  final num goingCount;
  @override
  final BuiltList<UserCardDto> goingPreview;
  @override
  final bool imGoing;
  @override
  final UserCardDto createdBy;

  factory _$GroupEventDto([void Function(GroupEventDtoBuilder)? updates]) =>
      (GroupEventDtoBuilder()..update(updates))._build();

  _$GroupEventDto._(
      {required this.id,
      required this.groupId,
      required this.title,
      required this.startsAt,
      this.game,
      required this.goingCount,
      required this.goingPreview,
      required this.imGoing,
      required this.createdBy})
      : super._();
  @override
  GroupEventDto rebuild(void Function(GroupEventDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupEventDtoBuilder toBuilder() => GroupEventDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupEventDto &&
        id == other.id &&
        groupId == other.groupId &&
        title == other.title &&
        startsAt == other.startsAt &&
        game == other.game &&
        goingCount == other.goingCount &&
        goingPreview == other.goingPreview &&
        imGoing == other.imGoing &&
        createdBy == other.createdBy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, groupId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, game.hashCode);
    _$hash = $jc(_$hash, goingCount.hashCode);
    _$hash = $jc(_$hash, goingPreview.hashCode);
    _$hash = $jc(_$hash, imGoing.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GroupEventDto')
          ..add('id', id)
          ..add('groupId', groupId)
          ..add('title', title)
          ..add('startsAt', startsAt)
          ..add('game', game)
          ..add('goingCount', goingCount)
          ..add('goingPreview', goingPreview)
          ..add('imGoing', imGoing)
          ..add('createdBy', createdBy))
        .toString();
  }
}

class GroupEventDtoBuilder
    implements Builder<GroupEventDto, GroupEventDtoBuilder> {
  _$GroupEventDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _groupId;
  String? get groupId => _$this._groupId;
  set groupId(String? groupId) => _$this._groupId = groupId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  GameRefDtoBuilder? _game;
  GameRefDtoBuilder get game => _$this._game ??= GameRefDtoBuilder();
  set game(GameRefDtoBuilder? game) => _$this._game = game;

  num? _goingCount;
  num? get goingCount => _$this._goingCount;
  set goingCount(num? goingCount) => _$this._goingCount = goingCount;

  ListBuilder<UserCardDto>? _goingPreview;
  ListBuilder<UserCardDto> get goingPreview =>
      _$this._goingPreview ??= ListBuilder<UserCardDto>();
  set goingPreview(ListBuilder<UserCardDto>? goingPreview) =>
      _$this._goingPreview = goingPreview;

  bool? _imGoing;
  bool? get imGoing => _$this._imGoing;
  set imGoing(bool? imGoing) => _$this._imGoing = imGoing;

  UserCardDtoBuilder? _createdBy;
  UserCardDtoBuilder get createdBy =>
      _$this._createdBy ??= UserCardDtoBuilder();
  set createdBy(UserCardDtoBuilder? createdBy) => _$this._createdBy = createdBy;

  GroupEventDtoBuilder() {
    GroupEventDto._defaults(this);
  }

  GroupEventDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _groupId = $v.groupId;
      _title = $v.title;
      _startsAt = $v.startsAt;
      _game = $v.game?.toBuilder();
      _goingCount = $v.goingCount;
      _goingPreview = $v.goingPreview.toBuilder();
      _imGoing = $v.imGoing;
      _createdBy = $v.createdBy.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupEventDto other) {
    _$v = other as _$GroupEventDto;
  }

  @override
  void update(void Function(GroupEventDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupEventDto build() => _build();

  _$GroupEventDto _build() {
    _$GroupEventDto _$result;
    try {
      _$result = _$v ??
          _$GroupEventDto._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'GroupEventDto', 'id'),
            groupId: BuiltValueNullFieldError.checkNotNull(
                groupId, r'GroupEventDto', 'groupId'),
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'GroupEventDto', 'title'),
            startsAt: BuiltValueNullFieldError.checkNotNull(
                startsAt, r'GroupEventDto', 'startsAt'),
            game: _game?.build(),
            goingCount: BuiltValueNullFieldError.checkNotNull(
                goingCount, r'GroupEventDto', 'goingCount'),
            goingPreview: goingPreview.build(),
            imGoing: BuiltValueNullFieldError.checkNotNull(
                imGoing, r'GroupEventDto', 'imGoing'),
            createdBy: createdBy.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'game';
        _game?.build();

        _$failedField = 'goingPreview';
        goingPreview.build();

        _$failedField = 'createdBy';
        createdBy.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GroupEventDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
