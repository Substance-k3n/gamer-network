//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'comment_sort.g.dart';

class CommentSort extends EnumClass {
  @BuiltValueEnumConst(wireName: r'oldest')
  static const CommentSort oldest = _$oldest;
  @BuiltValueEnumConst(wireName: r'top')
  static const CommentSort top = _$top;

  static Serializer<CommentSort> get serializer => _$commentSortSerializer;

  const CommentSort._(String name) : super(name);

  static BuiltSet<CommentSort> get values => _$values;
  static CommentSort valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class CommentSortMixin = Object with _$CommentSortMixin;
