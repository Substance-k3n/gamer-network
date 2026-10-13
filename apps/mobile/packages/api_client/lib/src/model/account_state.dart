//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_state.g.dart';

class AccountState extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const AccountState active = _$active;
  @BuiltValueEnumConst(wireName: r'banned')
  static const AccountState banned = _$banned;
  @BuiltValueEnumConst(wireName: r'deleted')
  static const AccountState deleted = _$deleted;

  static Serializer<AccountState> get serializer => _$accountStateSerializer;

  const AccountState._(String name) : super(name);

  static BuiltSet<AccountState> get values => _$values;
  static AccountState valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AccountStateMixin = Object with _$AccountStateMixin;
