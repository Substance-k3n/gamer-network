// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PostType _$discussion = const PostType._('discussion');
const PostType _$gameplay = const PostType._('gameplay');
const PostType _$recruitment = const PostType._('recruitment');
const PostType _$poll = const PostType._('poll');
const PostType _$milestone = const PostType._('milestone');
const PostType _$question = const PostType._('question');
const PostType _$lookingForPlayers = const PostType._('lookingForPlayers');
const PostType _$tipGuide = const PostType._('tipGuide');
const PostType _$review = const PostType._('review');
const PostType _$event = const PostType._('event');
const PostType _$meme = const PostType._('meme');

PostType _$valueOf(String name) {
  switch (name) {
    case 'discussion':
      return _$discussion;
    case 'gameplay':
      return _$gameplay;
    case 'recruitment':
      return _$recruitment;
    case 'poll':
      return _$poll;
    case 'milestone':
      return _$milestone;
    case 'question':
      return _$question;
    case 'lookingForPlayers':
      return _$lookingForPlayers;
    case 'tipGuide':
      return _$tipGuide;
    case 'review':
      return _$review;
    case 'event':
      return _$event;
    case 'meme':
      return _$meme;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PostType> _$values = BuiltSet<PostType>(const <PostType>[
  _$discussion,
  _$gameplay,
  _$recruitment,
  _$poll,
  _$milestone,
  _$question,
  _$lookingForPlayers,
  _$tipGuide,
  _$review,
  _$event,
  _$meme,
]);

class _$PostTypeMeta {
  const _$PostTypeMeta();
  PostType get discussion => _$discussion;
  PostType get gameplay => _$gameplay;
  PostType get recruitment => _$recruitment;
  PostType get poll => _$poll;
  PostType get milestone => _$milestone;
  PostType get question => _$question;
  PostType get lookingForPlayers => _$lookingForPlayers;
  PostType get tipGuide => _$tipGuide;
  PostType get review => _$review;
  PostType get event => _$event;
  PostType get meme => _$meme;
  PostType valueOf(String name) => _$valueOf(name);
  BuiltSet<PostType> get values => _$values;
}

abstract class _$PostTypeMixin {
  // ignore: non_constant_identifier_names
  _$PostTypeMeta get PostType => const _$PostTypeMeta();
}

Serializer<PostType> _$postTypeSerializer = _$PostTypeSerializer();

class _$PostTypeSerializer implements PrimitiveSerializer<PostType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'discussion': 'discussion',
    'gameplay': 'gameplay',
    'recruitment': 'recruitment',
    'poll': 'poll',
    'milestone': 'milestone',
    'question': 'question',
    'lookingForPlayers': 'looking_for_players',
    'tipGuide': 'tip_guide',
    'review': 'review',
    'event': 'event',
    'meme': 'meme',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'discussion': 'discussion',
    'gameplay': 'gameplay',
    'recruitment': 'recruitment',
    'poll': 'poll',
    'milestone': 'milestone',
    'question': 'question',
    'looking_for_players': 'lookingForPlayers',
    'tip_guide': 'tipGuide',
    'review': 'review',
    'event': 'event',
    'meme': 'meme',
  };

  @override
  final Iterable<Type> types = const <Type>[PostType];
  @override
  final String wireName = 'PostType';

  @override
  Object serialize(Serializers serializers, PostType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PostType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PostType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
