// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_kind.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PostKind _$text = const PostKind._('text');
const PostKind _$moment = const PostKind._('moment');
const PostKind _$discussion = const PostKind._('discussion');
const PostKind _$poll = const PostKind._('poll');
const PostKind _$recruit = const PostKind._('recruit');

PostKind _$valueOf(String name) {
  switch (name) {
    case 'text':
      return _$text;
    case 'moment':
      return _$moment;
    case 'discussion':
      return _$discussion;
    case 'poll':
      return _$poll;
    case 'recruit':
      return _$recruit;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PostKind> _$values = BuiltSet<PostKind>(const <PostKind>[
  _$text,
  _$moment,
  _$discussion,
  _$poll,
  _$recruit,
]);

class _$PostKindMeta {
  const _$PostKindMeta();
  PostKind get text => _$text;
  PostKind get moment => _$moment;
  PostKind get discussion => _$discussion;
  PostKind get poll => _$poll;
  PostKind get recruit => _$recruit;
  PostKind valueOf(String name) => _$valueOf(name);
  BuiltSet<PostKind> get values => _$values;
}

abstract class _$PostKindMixin {
  // ignore: non_constant_identifier_names
  _$PostKindMeta get PostKind => const _$PostKindMeta();
}

Serializer<PostKind> _$postKindSerializer = _$PostKindSerializer();

class _$PostKindSerializer implements PrimitiveSerializer<PostKind> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'text': 'text',
    'moment': 'moment',
    'discussion': 'discussion',
    'poll': 'poll',
    'recruit': 'recruit',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'text': 'text',
    'moment': 'moment',
    'discussion': 'discussion',
    'poll': 'poll',
    'recruit': 'recruit',
  };

  @override
  final Iterable<Type> types = const <Type>[PostKind];
  @override
  final String wireName = 'PostKind';

  @override
  Object serialize(Serializers serializers, PostKind object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PostKind deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PostKind.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
