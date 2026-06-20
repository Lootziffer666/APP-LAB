import 'package:forge_core/forge_core.dart';

/// Birthday / Anniversary Reminder — pure date-driven.
/// The simplest possible profile: just a name and a date.
final birthdayReminder = Profile(
  id: 'birthday_reminder',
  title: 'Geburtstage',
  view: ViewId.calendar,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Datum', 'date', required: true),
    FieldSpec('warnDays', 'Vorwarnung (Tage)', 'int'),
    FieldSpec('intervalDays', 'Jährlich (365)', 'int'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (item) =>
      item.state == ItemState.active && item.type == 'birthday_reminder',
  skin: const {'icon': 'cake'},
);
