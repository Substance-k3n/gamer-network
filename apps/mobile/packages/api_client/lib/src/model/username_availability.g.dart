// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'username_availability.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UsernameAvailabilityReasonEnum _$usernameAvailabilityReasonEnum_taken =
    const UsernameAvailabilityReasonEnum._('taken');
const UsernameAvailabilityReasonEnum _$usernameAvailabilityReasonEnum_invalid =
    const UsernameAvailabilityReasonEnum._('invalid');

UsernameAvailabilityReasonEnum _$usernameAvailabilityReasonEnumValueOf(
    String name) {
  switch (name) {
    case 'taken':
      return _$usernameAvailabilityReasonEnum_taken;
    case 'invalid':
      return _$usernameAvailabilityReasonEnum_invalid;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UsernameAvailabilityReasonEnum>
    _$usernameAvailabilityReasonEnumValues = BuiltSet<
        UsernameAvailabilityReasonEnum>(const <UsernameAvailabilityReasonEnum>[
  _$usernameAvailabilityReasonEnum_taken,
  _$usernameAvailabilityReasonEnum_invalid,
]);

Serializer<UsernameAvailabilityReasonEnum>
    _$usernameAvailabilityReasonEnumSerializer =
    _$UsernameAvailabilityReasonEnumSerializer();

class _$UsernameAvailabilityReasonEnumSerializer
    implements PrimitiveSerializer<UsernameAvailabilityReasonEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'taken': 'taken',
    'invalid': 'invalid',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'taken': 'taken',
    'invalid': 'invalid',
  };

  @override
  final Iterable<Type> types = const <Type>[UsernameAvailabilityReasonEnum];
  @override
  final String wireName = 'UsernameAvailabilityReasonEnum';

  @override
  Object serialize(
          Serializers serializers, UsernameAvailabilityReasonEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UsernameAvailabilityReasonEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UsernameAvailabilityReasonEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UsernameAvailability extends UsernameAvailability {
  @override
  final bool available;
  @override
  final UsernameAvailabilityReasonEnum? reason;

  factory _$UsernameAvailability(
          [void Function(UsernameAvailabilityBuilder)? updates]) =>
      (UsernameAvailabilityBuilder()..update(updates))._build();

  _$UsernameAvailability._({required this.available, this.reason}) : super._();
  @override
  UsernameAvailability rebuild(
          void Function(UsernameAvailabilityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UsernameAvailabilityBuilder toBuilder() =>
      UsernameAvailabilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UsernameAvailability &&
        available == other.available &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UsernameAvailability')
          ..add('available', available)
          ..add('reason', reason))
        .toString();
  }
}

class UsernameAvailabilityBuilder
    implements Builder<UsernameAvailability, UsernameAvailabilityBuilder> {
  _$UsernameAvailability? _$v;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  UsernameAvailabilityReasonEnum? _reason;
  UsernameAvailabilityReasonEnum? get reason => _$this._reason;
  set reason(UsernameAvailabilityReasonEnum? reason) => _$this._reason = reason;

  UsernameAvailabilityBuilder() {
    UsernameAvailability._defaults(this);
  }

  UsernameAvailabilityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _available = $v.available;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UsernameAvailability other) {
    _$v = other as _$UsernameAvailability;
  }

  @override
  void update(void Function(UsernameAvailabilityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UsernameAvailability build() => _build();

  _$UsernameAvailability _build() {
    final _$result = _$v ??
        _$UsernameAvailability._(
          available: BuiltValueNullFieldError.checkNotNull(
              available, r'UsernameAvailability', 'available'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
