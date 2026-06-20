import 'package:forge_core/forge_core.dart';

/// Subscription Cost Tracker — recurring monthly/yearly costs.
/// Hybrid: time (renewal date) + stock (budget remaining concept).
final subscriptionCost = Profile(
  id: 'subscription_cost',
  title: 'Abo-Kosten',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Nächste Abbuchung', 'date', required: true),
    FieldSpec('intervalDays', 'Zahlungsintervall (Tage)', 'int'),
    FieldSpec('cost', 'Betrag (€)', 'double', required: true),
    FieldSpec('provider', 'Anbieter', 'text'),
  ],
  actions: const ['complete', 'archive'],
  filter: (item) =>
      item.state == ItemState.active && item.type == 'subscription_cost',
  skin: const {'icon': 'payments'},
);
