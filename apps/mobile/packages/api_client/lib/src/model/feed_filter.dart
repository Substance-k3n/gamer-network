//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'feed_filter.g.dart';

class FeedFilter extends EnumClass {
  @BuiltValueEnumConst(wireName: r'for_you')
  static const FeedFilter forYou = _$forYou;
  @BuiltValueEnumConst(wireName: r'connections')
  static const FeedFilter connections = _$connections;
  @BuiltValueEnumConst(wireName: r'lfg')
  static const FeedFilter lfg = _$lfg;
  @BuiltValueEnumConst(wireName: r'game')
  static const FeedFilter game = _$game;

  static Serializer<FeedFilter> get serializer => _$feedFilterSerializer;

  const FeedFilter._(String name) : super(name);

  static BuiltSet<FeedFilter> get values => _$values;
  static FeedFilter valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class FeedFilterMixin = Object with _$FeedFilterMixin;
