import 'package:forge_core/forge_core.dart';

/// Contract / Subscription Tracker.
/// Cancellation deadlines, auto-renewals, subscription costs.
/// Same engine as plant watering — just different labels.
final contractTracker = Profile(
  id: 'contract_tracker',
  title: 'Verträge & Abos',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Kündigungsfrist', 'date', required: true),
    FieldSpec('warnDays', 'Vorwarnung (Tage)', 'int'),
    FieldSpec('cost', 'Monatliche Kosten (€)', 'double'),
    FieldSpec('provider', 'Anbieter', 'text'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (item) =>
      item.state == ItemState.active && item.type == 'contract_tracker',
  skin: const {
    'icon': 'receipt_long',
    'emptyLottie': 'assets/lottie/no_contracts.json',
  },
);
