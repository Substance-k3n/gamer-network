// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolve_action.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ResolveAction _$dismiss = const ResolveAction._('dismiss');
const ResolveAction _$warn = const ResolveAction._('warn');
const ResolveAction _$removeListing = const ResolveAction._('removeListing');
const ResolveAction _$ban = const ResolveAction._('ban');

ResolveAction _$valueOf(String name) {
  switch (name) {
    case 'dismiss':
      return _$dismiss;
    case 'warn':
      return _$warn;
    case 'removeListing':
      return _$removeListing;
    case 'ban':
      return _$ban;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ResolveAction> _$values =
    BuiltSet<ResolveAction>(const <ResolveAction>[
  _$dismiss,
  _$warn,
  _$removeListing,
  _$ban,
]);

class _$ResolveActionMeta {
  const _$ResolveActionMeta();
  ResolveAction get dismiss => _$dismiss;
  ResolveAction get warn => _$warn;
  ResolveAction get removeListing => _$removeListing;
  ResolveAction get ban => _$ban;
  ResolveAction valueOf(String name) => _$valueOf(name);
  BuiltSet<ResolveAction> get values => _$values;
}

abstract class _$ResolveActionMixin {
  // ignore: non_constant_identifier_names
  _$ResolveActionMeta get ResolveAction => const _$ResolveActionMeta();
}

Serializer<ResolveAction> _$resolveActionSerializer =
    _$ResolveActionSerializer();

class _$ResolveActionSerializer implements PrimitiveSerializer<ResolveAction> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'dismiss': 'dismiss',
    'warn': 'warn',
    'removeListing': 'remove_listing',
    'ban': 'ban',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'dismiss': 'dismiss',
    'warn': 'warn',
    'remove_listing': 'removeListing',
    'ban': 'ban',
  };

  @override
  final Iterable<Type> types = const <Type>[ResolveAction];
  @override
  final String wireName = 'ResolveAction';

  @override
  Object serialize(Serializers serializers, ResolveAction object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ResolveAction deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ResolveAction.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
