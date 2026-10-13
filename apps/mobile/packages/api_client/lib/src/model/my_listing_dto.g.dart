// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_listing_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MyListingDto extends MyListingDto {
  @override
  final ListingDto? listing;

  factory _$MyListingDto([void Function(MyListingDtoBuilder)? updates]) =>
      (MyListingDtoBuilder()..update(updates))._build();

  _$MyListingDto._({this.listing}) : super._();
  @override
  MyListingDto rebuild(void Function(MyListingDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MyListingDtoBuilder toBuilder() => MyListingDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MyListingDto && listing == other.listing;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listing.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MyListingDto')
          ..add('listing', listing))
        .toString();
  }
}

class MyListingDtoBuilder
    implements Builder<MyListingDto, MyListingDtoBuilder> {
  _$MyListingDto? _$v;

  ListingDtoBuilder? _listing;
  ListingDtoBuilder get listing => _$this._listing ??= ListingDtoBuilder();
  set listing(ListingDtoBuilder? listing) => _$this._listing = listing;

  MyListingDtoBuilder() {
    MyListingDto._defaults(this);
  }

  MyListingDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listing = $v.listing?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MyListingDto other) {
    _$v = other as _$MyListingDto;
  }

  @override
  void update(void Function(MyListingDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MyListingDto build() => _build();

  _$MyListingDto _build() {
    _$MyListingDto _$result;
    try {
      _$result = _$v ??
          _$MyListingDto._(
            listing: _listing?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'listing';
        _listing?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MyListingDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
