//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_status.g.dart';

/// expired as soon as expiresAt passes, even before the expiry job runs.
class ListingStatus extends EnumClass {
  @BuiltValueEnumConst(wireName: r'open')
  static const ListingStatus open = _$open;
  @BuiltValueEnumConst(wireName: r'full')
  static const ListingStatus full = _$full;
  @BuiltValueEnumConst(wireName: r'closed')
  static const ListingStatus closed = _$closed;
  @BuiltValueEnumConst(wireName: r'expired')
  static const ListingStatus expired = _$expired;
  @BuiltValueEnumConst(wireName: r'removed')
  static const ListingStatus removed = _$removed;

  static Serializer<ListingStatus> get serializer => _$listingStatusSerializer;

  const ListingStatus._(String name) : super(name);

  static BuiltSet<ListingStatus> get values => _$values;
  static ListingStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ListingStatusMixin = Object with _$ListingStatusMixin;
