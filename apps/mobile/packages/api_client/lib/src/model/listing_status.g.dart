// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ListingStatus _$open = const ListingStatus._('open');
const ListingStatus _$full = const ListingStatus._('full');
const ListingStatus _$closed = const ListingStatus._('closed');
const ListingStatus _$expired = const ListingStatus._('expired');
const ListingStatus _$removed = const ListingStatus._('removed');

ListingStatus _$valueOf(String name) {
  switch (name) {
    case 'open':
      return _$open;
    case 'full':
      return _$full;
    case 'closed':
      return _$closed;
    case 'expired':
      return _$expired;
    case 'removed':
      return _$removed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingStatus> _$values =
    BuiltSet<ListingStatus>(const <ListingStatus>[
  _$open,
  _$full,
  _$closed,
  _$expired,
  _$removed,
]);

class _$ListingStatusMeta {
  const _$ListingStatusMeta();
  ListingStatus get open => _$open;
  ListingStatus get full => _$full;
  ListingStatus get closed => _$closed;
  ListingStatus get expired => _$expired;
  ListingStatus get removed => _$removed;
  ListingStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<ListingStatus> get values => _$values;
}

abstract class _$ListingStatusMixin {
  // ignore: non_constant_identifier_names
  _$ListingStatusMeta get ListingStatus => const _$ListingStatusMeta();
}

Serializer<ListingStatus> _$listingStatusSerializer =
    _$ListingStatusSerializer();

class _$ListingStatusSerializer implements PrimitiveSerializer<ListingStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'open': 'open',
    'full': 'full',
    'closed': 'closed',
    'expired': 'expired',
    'removed': 'removed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'open': 'open',
    'full': 'full',
    'closed': 'closed',
    'expired': 'expired',
    'removed': 'removed',
  };

  @override
  final Iterable<Type> types = const <Type>[ListingStatus];
  @override
  final String wireName = 'ListingStatus';

  @override
  Object serialize(Serializers serializers, ListingStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
