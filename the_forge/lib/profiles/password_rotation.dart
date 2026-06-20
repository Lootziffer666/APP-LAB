import 'package:forge_core/forge_core.dart';

/// Password Rotation Reminder — "Wann hast du das zuletzt geändert?"
final passwordRotation = Profile(
  id: 'password_rotation',
  title: 'Passwort-Rotation',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Alle X Tage ändern', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt geändert', 'date'),
    FieldSpec('service', 'Dienst / Account', 'text', required: true),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (item) =>
      item.state == ItemState.active && item.type == 'password_rotation',
  skin: const {'icon': 'lock_reset'},
);
