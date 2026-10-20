// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_filter.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FeedFilter _$forYou = const FeedFilter._('forYou');
const FeedFilter _$connections = const FeedFilter._('connections');
const FeedFilter _$lfg = const FeedFilter._('lfg');
const FeedFilter _$game = const FeedFilter._('game');

FeedFilter _$valueOf(String name) {
  switch (name) {
    case 'forYou':
      return _$forYou;
    case 'connections':
      return _$connections;
    case 'lfg':
      return _$lfg;
    case 'game':
      return _$game;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FeedFilter> _$values = BuiltSet<FeedFilter>(const <FeedFilter>[
  _$forYou,
  _$connections,
  _$lfg,
  _$game,
]);

class _$FeedFilterMeta {
  const _$FeedFilterMeta();
  FeedFilter get forYou => _$forYou;
  FeedFilter get connections => _$connections;
  FeedFilter get lfg => _$lfg;
  FeedFilter get game => _$game;
  FeedFilter valueOf(String name) => _$valueOf(name);
  BuiltSet<FeedFilter> get values => _$values;
}

abstract class _$FeedFilterMixin {
  // ignore: non_constant_identifier_names
  _$FeedFilterMeta get FeedFilter => const _$FeedFilterMeta();
}

Serializer<FeedFilter> _$feedFilterSerializer = _$FeedFilterSerializer();

class _$FeedFilterSerializer implements PrimitiveSerializer<FeedFilter> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'forYou': 'for_you',
    'connections': 'connections',
    'lfg': 'lfg',
    'game': 'game',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'for_you': 'forYou',
    'connections': 'connections',
    'lfg': 'lfg',
    'game': 'game',
  };

  @override
  final Iterable<Type> types = const <Type>[FeedFilter];
  @override
  final String wireName = 'FeedFilter';

  @override
  Object serialize(Serializers serializers, FeedFilter object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FeedFilter deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FeedFilter.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
