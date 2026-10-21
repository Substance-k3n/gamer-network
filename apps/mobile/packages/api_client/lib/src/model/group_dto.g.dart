// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GroupDto extends GroupDto {
  @override
  final GroupKind kind;
  @override
  final GroupTone tone;
  @override
  final GroupRole? myRole;
  @override
  final MembershipStatus? myStatus;
  @override
  final String id;
  @override
  final String name;
  @override
  final String short;
  @override
  final GameRefDto? game;
  @override
  final String place;
  @override
  final String about;
  @override
  final BuiltList<String> rules;
  @override
  final bool approval;
  @override
  final num memberCount;
  @override
  final BuiltList<UserCardDto> membersPreview;
  @override
  final GroupEventDto? nextEvent;
  @override
  final UserCardDto createdBy;
  @override
  final String shareUrl;
  @override
  final DateTime createdAt;

  factory _$GroupDto([void Function(GroupDtoBuilder)? updates]) =>
      (GroupDtoBuilder()..update(updates))._build();

  _$GroupDto._(
      {required this.kind,
      required this.tone,
      this.myRole,
      this.myStatus,
      required this.id,
      required this.name,
      required this.short,
      this.game,
      required this.place,
      required this.about,
      required this.rules,
      required this.approval,
      required this.memberCount,
      required this.membersPreview,
      this.nextEvent,
      required this.createdBy,
      required this.shareUrl,
      required this.createdAt})
      : super._();
  @override
  GroupDto rebuild(void Function(GroupDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupDtoBuilder toBuilder() => GroupDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupDto &&
        kind == other.kind &&
        tone == other.tone &&
        myRole == other.myRole &&
        myStatus == other.myStatus &&
        id == other.id &&
        name == other.name &&
        short == other.short &&
        game == other.game &&
        place == other.place &&
        about == other.about &&
        rules == other.rules &&
        approval == other.approval &&
        memberCount == other.memberCount &&
        membersPreview == other.membersPreview &&
        nextEvent == other.nextEvent &&
        createdBy == other.createdBy &&
        shareUrl == other.shareUrl &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, tone.hashCode);
    _$hash = $jc(_$hash, myRole.hashCode);
    _$hash = $jc(_$hash, myStatus.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, short.hashCode);
    _$hash = $jc(_$hash, game.hashCode);
    _$hash = $jc(_$hash, place.hashCode);
    _$hash = $jc(_$hash, about.hashCode);
    _$hash = $jc(_$hash, rules.hashCode);
    _$hash = $jc(_$hash, approval.hashCode);
    _$hash = $jc(_$hash, memberCount.hashCode);
    _$hash = $jc(_$hash, membersPreview.hashCode);
    _$hash = $jc(_$hash, nextEvent.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, shareUrl.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GroupDto')
          ..add('kind', kind)
          ..add('tone', tone)
          ..add('myRole', myRole)
          ..add('myStatus', myStatus)
          ..add('id', id)
          ..add('name', name)
          ..add('short', short)
          ..add('game', game)
          ..add('place', place)
          ..add('about', about)
          ..add('rules', rules)
          ..add('approval', approval)
          ..add('memberCount', memberCount)
          ..add('membersPreview', membersPreview)
          ..add('nextEvent', nextEvent)
          ..add('createdBy', createdBy)
          ..add('shareUrl', shareUrl)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class GroupDtoBuilder implements Builder<GroupDto, GroupDtoBuilder> {
  _$GroupDto? _$v;

  GroupKind? _kind;
  GroupKind? get kind => _$this._kind;
  set kind(GroupKind? kind) => _$this._kind = kind;

  GroupTone? _tone;
  GroupTone? get tone => _$this._tone;
  set tone(GroupTone? tone) => _$this._tone = tone;

  GroupRole? _myRole;
  GroupRole? get myRole => _$this._myRole;
  set myRole(GroupRole? myRole) => _$this._myRole = myRole;

  MembershipStatus? _myStatus;
  MembershipStatus? get myStatus => _$this._myStatus;
  set myStatus(MembershipStatus? myStatus) => _$this._myStatus = myStatus;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _short;
  String? get short => _$this._short;
  set short(String? short) => _$this._short = short;

  GameRefDtoBuilder? _game;
  GameRefDtoBuilder get game => _$this._game ??= GameRefDtoBuilder();
  set game(GameRefDtoBuilder? game) => _$this._game = game;

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

  num? _memberCount;
  num? get memberCount => _$this._memberCount;
  set memberCount(num? memberCount) => _$this._memberCount = memberCount;

  ListBuilder<UserCardDto>? _membersPreview;
  ListBuilder<UserCardDto> get membersPreview =>
      _$this._membersPreview ??= ListBuilder<UserCardDto>();
  set membersPreview(ListBuilder<UserCardDto>? membersPreview) =>
      _$this._membersPreview = membersPreview;

  GroupEventDtoBuilder? _nextEvent;
  GroupEventDtoBuilder get nextEvent =>
      _$this._nextEvent ??= GroupEventDtoBuilder();
  set nextEvent(GroupEventDtoBuilder? nextEvent) =>
      _$this._nextEvent = nextEvent;

  UserCardDtoBuilder? _createdBy;
  UserCardDtoBuilder get createdBy =>
      _$this._createdBy ??= UserCardDtoBuilder();
  set createdBy(UserCardDtoBuilder? createdBy) => _$this._createdBy = createdBy;

  String? _shareUrl;
  String? get shareUrl => _$this._shareUrl;
  set shareUrl(String? shareUrl) => _$this._shareUrl = shareUrl;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  GroupDtoBuilder() {
    GroupDto._defaults(this);
  }

  GroupDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _tone = $v.tone;
      _myRole = $v.myRole;
      _myStatus = $v.myStatus;
      _id = $v.id;
      _name = $v.name;
      _short = $v.short;
      _game = $v.game?.toBuilder();
      _place = $v.place;
      _about = $v.about;
      _rules = $v.rules.toBuilder();
      _approval = $v.approval;
      _memberCount = $v.memberCount;
      _membersPreview = $v.membersPreview.toBuilder();
      _nextEvent = $v.nextEvent?.toBuilder();
      _createdBy = $v.createdBy.toBuilder();
      _shareUrl = $v.shareUrl;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupDto other) {
    _$v = other as _$GroupDto;
  }

  @override
  void update(void Function(GroupDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupDto build() => _build();

  _$GroupDto _build() {
    _$GroupDto _$result;
    try {
      _$result = _$v ??
          _$GroupDto._(
            kind: BuiltValueNullFieldError.checkNotNull(
                kind, r'GroupDto', 'kind'),
            tone: BuiltValueNullFieldError.checkNotNull(
                tone, r'GroupDto', 'tone'),
            myRole: myRole,
            myStatus: myStatus,
            id: BuiltValueNullFieldError.checkNotNull(id, r'GroupDto', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'GroupDto', 'name'),
            short: BuiltValueNullFieldError.checkNotNull(
                short, r'GroupDto', 'short'),
            game: _game?.build(),
            place: BuiltValueNullFieldError.checkNotNull(
                place, r'GroupDto', 'place'),
            about: BuiltValueNullFieldError.checkNotNull(
                about, r'GroupDto', 'about'),
            rules: rules.build(),
            approval: BuiltValueNullFieldError.checkNotNull(
                approval, r'GroupDto', 'approval'),
            memberCount: BuiltValueNullFieldError.checkNotNull(
                memberCount, r'GroupDto', 'memberCount'),
            membersPreview: membersPreview.build(),
            nextEvent: _nextEvent?.build(),
            createdBy: createdBy.build(),
            shareUrl: BuiltValueNullFieldError.checkNotNull(
                shareUrl, r'GroupDto', 'shareUrl'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'GroupDto', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'game';
        _game?.build();

        _$failedField = 'rules';
        rules.build();

        _$failedField = 'membersPreview';
        membersPreview.build();
        _$failedField = 'nextEvent';
        _nextEvent?.build();
        _$failedField = 'createdBy';
        createdBy.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GroupDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
