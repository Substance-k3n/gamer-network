// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accepted_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AcceptedRequestDto extends AcceptedRequestDto {
  @override
  final ConnectionRequestDto request;
  @override
  final ConnectionDto connection;

  factory _$AcceptedRequestDto(
          [void Function(AcceptedRequestDtoBuilder)? updates]) =>
      (AcceptedRequestDtoBuilder()..update(updates))._build();

  _$AcceptedRequestDto._({required this.request, required this.connection})
      : super._();
  @override
  AcceptedRequestDto rebuild(
          void Function(AcceptedRequestDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AcceptedRequestDtoBuilder toBuilder() =>
      AcceptedRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AcceptedRequestDto &&
        request == other.request &&
        connection == other.connection;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, request.hashCode);
    _$hash = $jc(_$hash, connection.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AcceptedRequestDto')
          ..add('request', request)
          ..add('connection', connection))
        .toString();
  }
}

class AcceptedRequestDtoBuilder
    implements Builder<AcceptedRequestDto, AcceptedRequestDtoBuilder> {
  _$AcceptedRequestDto? _$v;

  ConnectionRequestDtoBuilder? _request;
  ConnectionRequestDtoBuilder get request =>
      _$this._request ??= ConnectionRequestDtoBuilder();
  set request(ConnectionRequestDtoBuilder? request) =>
      _$this._request = request;

  ConnectionDtoBuilder? _connection;
  ConnectionDtoBuilder get connection =>
      _$this._connection ??= ConnectionDtoBuilder();
  set connection(ConnectionDtoBuilder? connection) =>
      _$this._connection = connection;

  AcceptedRequestDtoBuilder() {
    AcceptedRequestDto._defaults(this);
  }

  AcceptedRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _request = $v.request.toBuilder();
      _connection = $v.connection.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AcceptedRequestDto other) {
    _$v = other as _$AcceptedRequestDto;
  }

  @override
  void update(void Function(AcceptedRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AcceptedRequestDto build() => _build();

  _$AcceptedRequestDto _build() {
    _$AcceptedRequestDto _$result;
    try {
      _$result = _$v ??
          _$AcceptedRequestDto._(
            request: request.build(),
            connection: connection.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'request';
        request.build();
        _$failedField = 'connection';
        connection.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AcceptedRequestDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
