// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_option_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PollOptionDto extends PollOptionDto {
  @override
  final num position;
  @override
  final String label;
  @override
  final num votes;

  factory _$PollOptionDto([void Function(PollOptionDtoBuilder)? updates]) =>
      (PollOptionDtoBuilder()..update(updates))._build();

  _$PollOptionDto._(
      {required this.position, required this.label, required this.votes})
      : super._();
  @override
  PollOptionDto rebuild(void Function(PollOptionDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PollOptionDtoBuilder toBuilder() => PollOptionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PollOptionDto &&
        position == other.position &&
        label == other.label &&
        votes == other.votes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, votes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PollOptionDto')
          ..add('position', position)
          ..add('label', label)
          ..add('votes', votes))
        .toString();
  }
}

class PollOptionDtoBuilder
    implements Builder<PollOptionDto, PollOptionDtoBuilder> {
  _$PollOptionDto? _$v;

  num? _position;
  num? get position => _$this._position;
  set position(num? position) => _$this._position = position;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  num? _votes;
  num? get votes => _$this._votes;
  set votes(num? votes) => _$this._votes = votes;

  PollOptionDtoBuilder() {
    PollOptionDto._defaults(this);
  }

  PollOptionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _position = $v.position;
      _label = $v.label;
      _votes = $v.votes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PollOptionDto other) {
    _$v = other as _$PollOptionDto;
  }

  @override
  void update(void Function(PollOptionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PollOptionDto build() => _build();

  _$PollOptionDto _build() {
    final _$result = _$v ??
        _$PollOptionDto._(
          position: BuiltValueNullFieldError.checkNotNull(
              position, r'PollOptionDto', 'position'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'PollOptionDto', 'label'),
          votes: BuiltValueNullFieldError.checkNotNull(
              votes, r'PollOptionDto', 'votes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
