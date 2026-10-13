// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AccountState _$active = const AccountState._('active');
const AccountState _$banned = const AccountState._('banned');
const AccountState _$deleted = const AccountState._('deleted');

AccountState _$valueOf(String name) {
  switch (name) {
    case 'active':
      return _$active;
    case 'banned':
      return _$banned;
    case 'deleted':
      return _$deleted;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AccountState> _$values =
    BuiltSet<AccountState>(const <AccountState>[
  _$active,
  _$banned,
  _$deleted,
]);

class _$AccountStateMeta {
  const _$AccountStateMeta();
  AccountState get active => _$active;
  AccountState get banned => _$banned;
  AccountState get deleted => _$deleted;
  AccountState valueOf(String name) => _$valueOf(name);
  BuiltSet<AccountState> get values => _$values;
}

abstract class _$AccountStateMixin {
  // ignore: non_constant_identifier_names
  _$AccountStateMeta get AccountState => const _$AccountStateMeta();
}

Serializer<AccountState> _$accountStateSerializer = _$AccountStateSerializer();

class _$AccountStateSerializer implements PrimitiveSerializer<AccountState> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'banned': 'banned',
    'deleted': 'deleted',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'banned': 'banned',
    'deleted': 'deleted',
  };

  @override
  final Iterable<Type> types = const <Type>[AccountState];
  @override
  final String wireName = 'AccountState';

  @override
  Object serialize(Serializers serializers, AccountState object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AccountState deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AccountState.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
