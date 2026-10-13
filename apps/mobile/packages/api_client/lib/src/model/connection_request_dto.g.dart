// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConnectionRequestDto extends ConnectionRequestDto {
  @override
  final RequestStatus status;
  @override
  final String id;
  @override
  final UserCardDto from;
  @override
  final UserCardDto to;
  @override
  final ListingDto? listing;
  @override
  final String? message;
  @override
  final DateTime createdAt;

  factory _$ConnectionRequestDto(
          [void Function(ConnectionRequestDtoBuilder)? updates]) =>
      (ConnectionRequestDtoBuilder()..update(updates))._build();

  _$ConnectionRequestDto._(
      {required this.status,
      required this.id,
      required this.from,
      required this.to,
      this.listing,
      this.message,
      required this.createdAt})
      : super._();
  @override
  ConnectionRequestDto rebuild(
          void Function(ConnectionRequestDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConnectionRequestDtoBuilder toBuilder() =>
      ConnectionRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConnectionRequestDto &&
        status == other.status &&
        id == other.id &&
        from == other.from &&
        to == other.to &&
        listing == other.listing &&
        message == other.message &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, listing.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConnectionRequestDto')
          ..add('status', status)
          ..add('id', id)
          ..add('from', from)
          ..add('to', to)
          ..add('listing', listing)
          ..add('message', message)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ConnectionRequestDtoBuilder
    implements Builder<ConnectionRequestDto, ConnectionRequestDtoBuilder> {
  _$ConnectionRequestDto? _$v;

  RequestStatus? _status;
  RequestStatus? get status => _$this._status;
  set status(RequestStatus? status) => _$this._status = status;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  UserCardDtoBuilder? _from;
  UserCardDtoBuilder get from => _$this._from ??= UserCardDtoBuilder();
  set from(UserCardDtoBuilder? from) => _$this._from = from;

  UserCardDtoBuilder? _to;
  UserCardDtoBuilder get to => _$this._to ??= UserCardDtoBuilder();
  set to(UserCardDtoBuilder? to) => _$this._to = to;

  ListingDtoBuilder? _listing;
  ListingDtoBuilder get listing => _$this._listing ??= ListingDtoBuilder();
  set listing(ListingDtoBuilder? listing) => _$this._listing = listing;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ConnectionRequestDtoBuilder() {
    ConnectionRequestDto._defaults(this);
  }

  ConnectionRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _id = $v.id;
      _from = $v.from.toBuilder();
      _to = $v.to.toBuilder();
      _listing = $v.listing?.toBuilder();
      _message = $v.message;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConnectionRequestDto other) {
    _$v = other as _$ConnectionRequestDto;
  }

  @override
  void update(void Function(ConnectionRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConnectionRequestDto build() => _build();

  _$ConnectionRequestDto _build() {
    _$ConnectionRequestDto _$result;
    try {
      _$result = _$v ??
          _$ConnectionRequestDto._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ConnectionRequestDto', 'status'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ConnectionRequestDto', 'id'),
            from: from.build(),
            to: to.build(),
            listing: _listing?.build(),
            message: message,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ConnectionRequestDto', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'from';
        from.build();
        _$failedField = 'to';
        to.build();
        _$failedField = 'listing';
        _listing?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ConnectionRequestDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
