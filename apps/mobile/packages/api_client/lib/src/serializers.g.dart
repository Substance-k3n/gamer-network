// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add(AcceptedRequestDto.serializer)
      ..add(AccountState.serializer)
      ..add(AdminReportDto.serializer)
      ..add(AdminReportPageDto.serializer)
      ..add(AdminUserDto.serializer)
      ..add(AdminUserPageDto.serializer)
      ..add(AgeRange.serializer)
      ..add(AnswerCheckInBody.serializer)
      ..add(AppConfigResponse.serializer)
      ..add(AuthResponse.serializer)
      ..add(AvatarType.serializer)
      ..add(AvatarUploadBody.serializer)
      ..add(AvatarUploadDto.serializer)
      ..add(BanBody.serializer)
      ..add(BlockBody.serializer)
      ..add(BlockListDto.serializer)
      ..add(ChangePasswordBody.serializer)
      ..add(CheckInAnswer.serializer)
      ..add(CheckInDto.serializer)
      ..add(CheckInListDto.serializer)
      ..add(CodeBody.serializer)
      ..add(ConnectionDto.serializer)
      ..add(ConnectionPageDto.serializer)
      ..add(ConnectionRequestDto.serializer)
      ..add(ConnectionRequestListDto.serializer)
      ..add(CreateListingBody.serializer)
      ..add(CreateListingBodyDurationHoursEnum.serializer)
      ..add(Day.serializer)
      ..add(DeleteAccountBody.serializer)
      ..add(DevicePlatform.serializer)
      ..add(ErrorBody.serializer)
      ..add(ErrorResponse.serializer)
      ..add(ForgotPasswordBody.serializer)
      ..add(GameDto.serializer)
      ..add(GameRefDto.serializer)
      ..add(GamingIdDto.serializer)
      ..add(GamingIdInput.serializer)
      ..add(GamingIdKind.serializer)
      ..add(GoogleBody.serializer)
      ..add(HealthResponse.serializer)
      ..add(HealthResponseDatabaseEnum.serializer)
      ..add(HealthResponseStatusEnum.serializer)
      ..add(IdVisibility.serializer)
      ..add(InviteStatus.serializer)
      ..add(InviteWhen.serializer)
      ..add(ListingDto.serializer)
      ..add(ListingDtoDurationHoursEnum.serializer)
      ..add(ListingPageDto.serializer)
      ..add(ListingStatsDto.serializer)
      ..add(ListingStatus.serializer)
      ..add(LoginBody.serializer)
      ..add(MarkReadBody.serializer)
      ..add(MeDto.serializer)
      ..add(MetricsDto.serializer)
      ..add(ModeDto.serializer)
      ..add(ModeRefDto.serializer)
      ..add(MyListingDto.serializer)
      ..add(MyRequestDto.serializer)
      ..add(NoteBody.serializer)
      ..add(NotificationDto.serializer)
      ..add(NotificationPageDto.serializer)
      ..add(NotificationType.serializer)
      ..add(Platform.serializer)
      ..add(PlayInviteDto.serializer)
      ..add(PlayInviteListDto.serializer)
      ..add(PlayStyle.serializer)
      ..add(PlayTag.serializer)
      ..add(PlayWhen.serializer)
      ..add(PlayerStatus.serializer)
      ..add(ProfileDto.serializer)
      ..add(ProfileStatsDto.serializer)
      ..add(PublicListingDto.serializer)
      ..add(RankDto.serializer)
      ..add(RankRefDto.serializer)
      ..add(RegisterDeviceBody.serializer)
      ..add(Relationship.serializer)
      ..add(ReportBody.serializer)
      ..add(ReportReason.serializer)
      ..add(ReportStatus.serializer)
      ..add(RequestStatus.serializer)
      ..add(ResetPasswordBody.serializer)
      ..add(ResetResponse.serializer)
      ..add(ResolveAction.serializer)
      ..add(ResolveReportBody.serializer)
      ..add(RoleDto.serializer)
      ..add(RoleRefDto.serializer)
      ..add(SendInviteBody.serializer)
      ..add(SendRequestBody.serializer)
      ..add(SetAvatarBody.serializer)
      ..add(SetGamesBody.serializer)
      ..add(SetGamingIdsBody.serializer)
      ..add(SetLaunchBody.serializer)
      ..add(SetPlatformsBody.serializer)
      ..add(SetStatusBody.serializer)
      ..add(SetTagsBody.serializer)
      ..add(SignupBody.serializer)
      ..add(UnreadCountDto.serializer)
      ..add(UpdateListingBody.serializer)
      ..add(UpdateMeBody.serializer)
      ..add(UserCardDto.serializer)
      ..add(UserGameDto.serializer)
      ..add(UserGameInput.serializer)
      ..add(UserRole.serializer)
      ..add(UserSearchResponse.serializer)
      ..add(UsernameAvailability.serializer)
      ..add(UsernameAvailabilityReasonEnum.serializer)
      ..add(Voice.serializer)
      ..add(WaitlistBody.serializer)
      ..add(WaitlistCountDto.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AdminReportDto)]),
          () => ListBuilder<AdminReportDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AdminUserDto)]),
          () => ListBuilder<AdminUserDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CheckInDto)]),
          () => ListBuilder<CheckInDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ConnectionDto)]),
          () => ListBuilder<ConnectionDto>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ConnectionRequestDto)]),
          () => ListBuilder<ConnectionRequestDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Day)]),
          () => ListBuilder<Day>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Platform)]),
          () => ListBuilder<Platform>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PlayTag)]),
          () => ListBuilder<PlayTag>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(UserGameDto)]),
          () => ListBuilder<UserGameDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(GamingIdDto)]),
          () => ListBuilder<GamingIdDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Day)]),
          () => ListBuilder<Day>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Platform)]),
          () => ListBuilder<Platform>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PlayTag)]),
          () => ListBuilder<PlayTag>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(UserGameDto)]),
          () => ListBuilder<UserGameDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(GamingIdDto)]),
          () => ListBuilder<GamingIdDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(GamingIdInput)]),
          () => ListBuilder<GamingIdInput>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ListingDto)]),
          () => ListBuilder<ListingDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(NotificationDto)]),
          () => ListBuilder<NotificationDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Platform)]),
          () => ListBuilder<Platform>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(RankDto)]),
          () => ListBuilder<RankDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(RoleDto)]),
          () => ListBuilder<RoleDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ModeDto)]),
          () => ListBuilder<ModeDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PlayInviteDto)]),
          () => ListBuilder<PlayInviteDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(UserCardDto)]),
          () => ListBuilder<UserCardDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(UserCardDto)]),
          () => ListBuilder<UserCardDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(UserGameInput)]),
          () => ListBuilder<UserGameInput>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(WaitlistCountDto)]),
          () => ListBuilder<WaitlistCountDto>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(const FullType(BuiltSet, const [const FullType(Day)]),
          () => SetBuilder<Day>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [const FullType(Platform)]),
          () => SetBuilder<Platform>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [const FullType(PlayTag)]),
          () => SetBuilder<PlayTag>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
