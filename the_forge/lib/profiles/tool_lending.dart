import 'package:forge_core/forge_core.dart';

/// Tool Lending Tracker — "Wem habe ich was verliehen?"
/// Time-driven: reminds you to ask for it back after X days.
final toolLending = Profile(
  id: 'tool_lending',
  title: 'Verliehen',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Zurück bis', 'date', required: true),
    FieldSpec('warnDays', 'Vorwarnung (Tage)', 'int'),
    FieldSpec('lentTo', 'Verliehen an', 'text', required: true),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (item) => item.state == ItemState.active && item.type == 'tool_lending',
  skin: const {'icon': 'handshake'},
);
