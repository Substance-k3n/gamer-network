// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_check_in_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnswerCheckInBody extends AnswerCheckInBody {
  @override
  final CheckInAnswer answer;

  factory _$AnswerCheckInBody(
          [void Function(AnswerCheckInBodyBuilder)? updates]) =>
      (AnswerCheckInBodyBuilder()..update(updates))._build();

  _$AnswerCheckInBody._({required this.answer}) : super._();
  @override
  AnswerCheckInBody rebuild(void Function(AnswerCheckInBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnswerCheckInBodyBuilder toBuilder() =>
      AnswerCheckInBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnswerCheckInBody && answer == other.answer;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, answer.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnswerCheckInBody')
          ..add('answer', answer))
        .toString();
  }
}

class AnswerCheckInBodyBuilder
    implements Builder<AnswerCheckInBody, AnswerCheckInBodyBuilder> {
  _$AnswerCheckInBody? _$v;

  CheckInAnswer? _answer;
  CheckInAnswer? get answer => _$this._answer;
  set answer(CheckInAnswer? answer) => _$this._answer = answer;

  AnswerCheckInBodyBuilder() {
    AnswerCheckInBody._defaults(this);
  }

  AnswerCheckInBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _answer = $v.answer;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnswerCheckInBody other) {
    _$v = other as _$AnswerCheckInBody;
  }

  @override
  void update(void Function(AnswerCheckInBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnswerCheckInBody build() => _build();

  _$AnswerCheckInBody _build() {
    final _$result = _$v ??
        _$AnswerCheckInBody._(
          answer: BuiltValueNullFieldError.checkNotNull(
              answer, r'AnswerCheckInBody', 'answer'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
