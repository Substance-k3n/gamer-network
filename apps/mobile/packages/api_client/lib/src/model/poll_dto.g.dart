// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PollDto extends PollDto {
  @override
  final BuiltList<PollOptionDto> options;
  @override
  final num totalVotes;
  @override
  final num? myVote;
  @override
  final DateTime endsAt;
  @override
  final bool closed;

  factory _$PollDto([void Function(PollDtoBuilder)? updates]) =>
      (PollDtoBuilder()..update(updates))._build();

  _$PollDto._(
      {required this.options,
      required this.totalVotes,
      this.myVote,
      required this.endsAt,
      required this.closed})
      : super._();
  @override
  PollDto rebuild(void Function(PollDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PollDtoBuilder toBuilder() => PollDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PollDto &&
        options == other.options &&
        totalVotes == other.totalVotes &&
        myVote == other.myVote &&
        endsAt == other.endsAt &&
        closed == other.closed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jc(_$hash, totalVotes.hashCode);
    _$hash = $jc(_$hash, myVote.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jc(_$hash, closed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PollDto')
          ..add('options', options)
          ..add('totalVotes', totalVotes)
          ..add('myVote', myVote)
          ..add('endsAt', endsAt)
          ..add('closed', closed))
        .toString();
  }
}

class PollDtoBuilder implements Builder<PollDto, PollDtoBuilder> {
  _$PollDto? _$v;

  ListBuilder<PollOptionDto>? _options;
  ListBuilder<PollOptionDto> get options =>
      _$this._options ??= ListBuilder<PollOptionDto>();
  set options(ListBuilder<PollOptionDto>? options) => _$this._options = options;

  num? _totalVotes;
  num? get totalVotes => _$this._totalVotes;
  set totalVotes(num? totalVotes) => _$this._totalVotes = totalVotes;

  num? _myVote;
  num? get myVote => _$this._myVote;
  set myVote(num? myVote) => _$this._myVote = myVote;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  bool? _closed;
  bool? get closed => _$this._closed;
  set closed(bool? closed) => _$this._closed = closed;

  PollDtoBuilder() {
    PollDto._defaults(this);
  }

  PollDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _options = $v.options.toBuilder();
      _totalVotes = $v.totalVotes;
      _myVote = $v.myVote;
      _endsAt = $v.endsAt;
      _closed = $v.closed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PollDto other) {
    _$v = other as _$PollDto;
  }

  @override
  void update(void Function(PollDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PollDto build() => _build();

  _$PollDto _build() {
    _$PollDto _$result;
    try {
      _$result = _$v ??
          _$PollDto._(
            options: options.build(),
            totalVotes: BuiltValueNullFieldError.checkNotNull(
                totalVotes, r'PollDto', 'totalVotes'),
            myVote: myVote,
            endsAt: BuiltValueNullFieldError.checkNotNull(
                endsAt, r'PollDto', 'endsAt'),
            closed: BuiltValueNullFieldError.checkNotNull(
                closed, r'PollDto', 'closed'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        options.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PollDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
