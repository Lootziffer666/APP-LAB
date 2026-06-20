import 'package:forge_core/forge_core.dart';

/// The first profile: Deadline Ledger.
/// Everything that has a due date, interval, or warning window.
/// Plants, contracts, TÜV, medications, subscriptions — all one profile.
final deadlineLedger = Profile(
  id: 'deadline_ledger',
  title: 'Deadline Ledger',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Fällig am', 'date'),
    FieldSpec('intervalDays', 'Intervall (Tage)', 'int'),
    FieldSpec('warnDays', 'Vorwarnung (Tage)', 'int'),
    FieldSpec('lastDone', 'Zuletzt erledigt', 'date'),
  ],
  actions: const ['complete', 'snooze', 'archive', 'reset'],
  filter: (item) =>
      item.state == ItemState.active &&
      item.type == 'deadline_ledger',
  skin: const {
    'icon': 'calendar_today',
    'emptyLottie': 'assets/lottie/all_clear.json',
  },
);
