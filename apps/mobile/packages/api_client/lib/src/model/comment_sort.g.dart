// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_sort.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CommentSort _$oldest = const CommentSort._('oldest');
const CommentSort _$top = const CommentSort._('top');

CommentSort _$valueOf(String name) {
  switch (name) {
    case 'oldest':
      return _$oldest;
    case 'top':
      return _$top;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CommentSort> _$values =
    BuiltSet<CommentSort>(const <CommentSort>[
  _$oldest,
  _$top,
]);

class _$CommentSortMeta {
  const _$CommentSortMeta();
  CommentSort get oldest => _$oldest;
  CommentSort get top => _$top;
  CommentSort valueOf(String name) => _$valueOf(name);
  BuiltSet<CommentSort> get values => _$values;
}

abstract class _$CommentSortMixin {
  // ignore: non_constant_identifier_names
  _$CommentSortMeta get CommentSort => const _$CommentSortMeta();
}

Serializer<CommentSort> _$commentSortSerializer = _$CommentSortSerializer();

class _$CommentSortSerializer implements PrimitiveSerializer<CommentSort> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'oldest': 'oldest',
    'top': 'top',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'oldest': 'oldest',
    'top': 'top',
  };

  @override
  final Iterable<Type> types = const <Type>[CommentSort];
  @override
  final String wireName = 'CommentSort';

  @override
  Object serialize(Serializers serializers, CommentSort object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CommentSort deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CommentSort.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
