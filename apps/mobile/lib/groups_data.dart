import 'package:api_client/api_client.dart';

import 'theme.dart';

// Groups come from the API (docs/FEED_AND_GROUPS_API.md, phases 4–5).
// This file keeps their labels and the create / edit form's working copy.

const groupKindLabel = {
  GroupKind.game: 'Game',
  GroupKind.city: 'City',
  GroupKind.campus: 'Campus',
  GroupKind.squad: 'Squad',
};

/// The skin colour for a group's tone.
Tone toneOfGroup(GroupTone t) => switch (t) {
  GroupTone.lav => Tone.lav,
  GroupTone.soft => Tone.soft,
  GroupTone.grey => Tone.grey,
  _ => Tone.accent,
};

/// Most rules a group can have, and the longest one (the API's limits).
const maxRules = 10, maxRuleLength = 140;

/// The create / edit group form. [editId] is set when editing.
class GroupDraft {
  GroupDraft();

  GroupDraft.of(GroupDto g)
    : editId = g.id,
      name = g.name,
      place = g.place,
      about = g.about,
      kind = g.kind,
      gameId = g.game?.id,
      approval = g.approval,
      tone = g.tone,
      rules = [...g.rules];

  String? editId;
  String name = '', place = 'Addis Ababa', about = '';
  GroupKind kind = GroupKind.game;
  String? gameId;
  bool approval = false;
  GroupTone tone = GroupTone.accent;
  List<String> rules = [];

  /// Why the API refused the name (group_name_taken), shown under it.
  String? nameError;

  List<String> get cleanRules => [
    for (final r in rules)
      if (r.trim().isNotEmpty) r.trim(),
  ];
}

/// "1,204" style member counts.
String groupCount(int n) =>
    n >= 1000 ? '${n ~/ 1000},${(n % 1000).toString().padLeft(3, '0')}' : '$n';

/// "Mar 2025": the month a group started.
String monthYear(DateTime t) {
  const m = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final l = t.toLocal();
  return '${m[l.month - 1]} ${l.year}';
}
