// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_listing_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateListingBody extends UpdateListingBody {
  @override
  final Voice? voice;
  @override
  final PlayStyle? style;
  @override
  final PlayWhen? playWhen;
  @override
  final String? note;

  factory _$UpdateListingBody(
          [void Function(UpdateListingBodyBuilder)? updates]) =>
      (UpdateListingBodyBuilder()..update(updates))._build();

  _$UpdateListingBody._({this.voice, this.style, this.playWhen, this.note})
      : super._();
  @override
  UpdateListingBody rebuild(void Function(UpdateListingBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateListingBodyBuilder toBuilder() =>
      UpdateListingBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateListingBody &&
        voice == other.voice &&
        style == other.style &&
        playWhen == other.playWhen &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, voice.hashCode);
    _$hash = $jc(_$hash, style.hashCode);
    _$hash = $jc(_$hash, playWhen.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateListingBody')
          ..add('voice', voice)
          ..add('style', style)
          ..add('playWhen', playWhen)
          ..add('note', note))
        .toString();
  }
}

class UpdateListingBodyBuilder
    implements Builder<UpdateListingBody, UpdateListingBodyBuilder> {
  _$UpdateListingBody? _$v;

  Voice? _voice;
  Voice? get voice => _$this._voice;
  set voice(Voice? voice) => _$this._voice = voice;

  PlayStyle? _style;
  PlayStyle? get style => _$this._style;
  set style(PlayStyle? style) => _$this._style = style;

  PlayWhen? _playWhen;
  PlayWhen? get playWhen => _$this._playWhen;
  set playWhen(PlayWhen? playWhen) => _$this._playWhen = playWhen;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  UpdateListingBodyBuilder() {
    UpdateListingBody._defaults(this);
  }

  UpdateListingBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _voice = $v.voice;
      _style = $v.style;
      _playWhen = $v.playWhen;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateListingBody other) {
    _$v = other as _$UpdateListingBody;
  }

  @override
  void update(void Function(UpdateListingBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateListingBody build() => _build();

  _$UpdateListingBody _build() {
    final _$result = _$v ??
        _$UpdateListingBody._(
          voice: voice,
          style: style,
          playWhen: playWhen,
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
