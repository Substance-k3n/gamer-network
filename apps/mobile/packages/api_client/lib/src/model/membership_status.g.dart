// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MembershipStatus _$member = const MembershipStatus._('member');
const MembershipStatus _$pending = const MembershipStatus._('pending');

MembershipStatus _$valueOf(String name) {
  switch (name) {
    case 'member':
      return _$member;
    case 'pending':
      return _$pending;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MembershipStatus> _$values =
    BuiltSet<MembershipStatus>(const <MembershipStatus>[
  _$member,
  _$pending,
]);

class _$MembershipStatusMeta {
  const _$MembershipStatusMeta();
  MembershipStatus get member => _$member;
  MembershipStatus get pending => _$pending;
  MembershipStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<MembershipStatus> get values => _$values;
}

abstract class _$MembershipStatusMixin {
  // ignore: non_constant_identifier_names
  _$MembershipStatusMeta get MembershipStatus => const _$MembershipStatusMeta();
}

Serializer<MembershipStatus> _$membershipStatusSerializer =
    _$MembershipStatusSerializer();

class _$MembershipStatusSerializer
    implements PrimitiveSerializer<MembershipStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'member': 'member',
    'pending': 'pending',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'member': 'member',
    'pending': 'pending',
  };

  @override
  final Iterable<Type> types = const <Type>[MembershipStatus];
  @override
  final String wireName = 'MembershipStatus';

  @override
  Object serialize(Serializers serializers, MembershipStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MembershipStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MembershipStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
