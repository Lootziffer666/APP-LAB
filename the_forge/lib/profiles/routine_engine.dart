import 'package:forge_core/forge_core.dart';

/// Routine Engine profile.
/// Morning routines, cleaning plans, shutdown rituals, medication sequences.
final routineEngine = Profile(
  id: 'routine_engine',
  title: 'Routinen',
  view: ViewId.board,
  defaultWeights: const {'progress': 1},
  fields: const [
    FieldSpec('steps', 'Schritte', 'steps', required: true),
    FieldSpec('intervalDays', 'Wiederholung (Tage)', 'int'),
  ],
  actions: const ['toggleStep', 'reset', 'archive'],
  filter: (item) =>
      item.state == ItemState.active && item.type == 'routine_engine',
  skin: const {
    'icon': 'checklist',
    'emptyLottie': 'assets/lottie/all_done.json',
  },
);
