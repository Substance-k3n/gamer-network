// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NoteBody extends NoteBody {
  @override
  final String? note;

  factory _$NoteBody([void Function(NoteBodyBuilder)? updates]) =>
      (NoteBodyBuilder()..update(updates))._build();

  _$NoteBody._({this.note}) : super._();
  @override
  NoteBody rebuild(void Function(NoteBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NoteBodyBuilder toBuilder() => NoteBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NoteBody && note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NoteBody')..add('note', note))
        .toString();
  }
}

class NoteBodyBuilder implements Builder<NoteBody, NoteBodyBuilder> {
  _$NoteBody? _$v;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  NoteBodyBuilder() {
    NoteBody._defaults(this);
  }

  NoteBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NoteBody other) {
    _$v = other as _$NoteBody;
  }

  @override
  void update(void Function(NoteBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NoteBody build() => _build();

  _$NoteBody _build() {
    final _$result = _$v ??
        _$NoteBody._(
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
