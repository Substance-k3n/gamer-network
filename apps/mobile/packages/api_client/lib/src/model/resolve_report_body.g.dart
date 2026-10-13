// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolve_report_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResolveReportBody extends ResolveReportBody {
  @override
  final ResolveAction action;
  @override
  final String note;

  factory _$ResolveReportBody(
          [void Function(ResolveReportBodyBuilder)? updates]) =>
      (ResolveReportBodyBuilder()..update(updates))._build();

  _$ResolveReportBody._({required this.action, required this.note}) : super._();
  @override
  ResolveReportBody rebuild(void Function(ResolveReportBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResolveReportBodyBuilder toBuilder() =>
      ResolveReportBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResolveReportBody &&
        action == other.action &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ResolveReportBody')
          ..add('action', action)
          ..add('note', note))
        .toString();
  }
}

class ResolveReportBodyBuilder
    implements Builder<ResolveReportBody, ResolveReportBodyBuilder> {
  _$ResolveReportBody? _$v;

  ResolveAction? _action;
  ResolveAction? get action => _$this._action;
  set action(ResolveAction? action) => _$this._action = action;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ResolveReportBodyBuilder() {
    ResolveReportBody._defaults(this);
  }

  ResolveReportBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _action = $v.action;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResolveReportBody other) {
    _$v = other as _$ResolveReportBody;
  }

  @override
  void update(void Function(ResolveReportBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResolveReportBody build() => _build();

  _$ResolveReportBody _build() {
    final _$result = _$v ??
        _$ResolveReportBody._(
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'ResolveReportBody', 'action'),
          note: BuiltValueNullFieldError.checkNotNull(
              note, r'ResolveReportBody', 'note'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
