// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MyRequestDto extends MyRequestDto {
  @override
  final RequestStatus status;
  @override
  final String id;

  factory _$MyRequestDto([void Function(MyRequestDtoBuilder)? updates]) =>
      (MyRequestDtoBuilder()..update(updates))._build();

  _$MyRequestDto._({required this.status, required this.id}) : super._();
  @override
  MyRequestDto rebuild(void Function(MyRequestDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MyRequestDtoBuilder toBuilder() => MyRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MyRequestDto && status == other.status && id == other.id;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MyRequestDto')
          ..add('status', status)
          ..add('id', id))
        .toString();
  }
}

class MyRequestDtoBuilder
    implements Builder<MyRequestDto, MyRequestDtoBuilder> {
  _$MyRequestDto? _$v;

  RequestStatus? _status;
  RequestStatus? get status => _$this._status;
  set status(RequestStatus? status) => _$this._status = status;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  MyRequestDtoBuilder() {
    MyRequestDto._defaults(this);
  }

  MyRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MyRequestDto other) {
    _$v = other as _$MyRequestDto;
  }

  @override
  void update(void Function(MyRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MyRequestDto build() => _build();

  _$MyRequestDto _build() {
    final _$result = _$v ??
        _$MyRequestDto._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'MyRequestDto', 'status'),
          id: BuiltValueNullFieldError.checkNotNull(id, r'MyRequestDto', 'id'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
