//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/poll_option_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'poll_dto.g.dart';

/// PollDto
///
/// Properties:
/// * [options]
/// * [totalVotes]
/// * [myVote] - The position you voted for, or null.
/// * [endsAt]
/// * [closed] - Past endsAt: no more votes.
@BuiltValue()
abstract class PollDto implements Built<PollDto, PollDtoBuilder> {
  @BuiltValueField(wireName: r'options')
  BuiltList<PollOptionDto> get options;

  @BuiltValueField(wireName: r'totalVotes')
  num get totalVotes;

  /// The position you voted for, or null.
  @BuiltValueField(wireName: r'myVote')
  num? get myVote;

  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  /// Past endsAt: no more votes.
  @BuiltValueField(wireName: r'closed')
  bool get closed;

  PollDto._();

  factory PollDto([void updates(PollDtoBuilder b)]) = _$PollDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PollDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PollDto> get serializer => _$PollDtoSerializer();
}

class _$PollDtoSerializer implements PrimitiveSerializer<PollDto> {
  @override
  final Iterable<Type> types = const [PollDto, _$PollDto];

  @override
  final String wireName = r'PollDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PollDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'options';
    yield serializers.serialize(
      object.options,
      specifiedType: const FullType(BuiltList, [FullType(PollOptionDto)]),
    );
    yield r'totalVotes';
    yield serializers.serialize(
      object.totalVotes,
      specifiedType: const FullType(num),
    );
    yield r'myVote';
    yield object.myVote == null
        ? null
        : serializers.serialize(
            object.myVote,
            specifiedType: const FullType.nullable(num),
          );
    yield r'endsAt';
    yield serializers.serialize(
      object.endsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'closed';
    yield serializers.serialize(
      object.closed,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PollDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PollDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PollOptionDto)]),
          ) as BuiltList<PollOptionDto>;
          result.options.replace(valueDes);
          break;
        case r'totalVotes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.totalVotes = valueDes;
          break;
        case r'myVote':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.myVote = valueDes;
          break;
        case r'endsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endsAt = valueDes;
          break;
        case r'closed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.closed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PollDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PollDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}
