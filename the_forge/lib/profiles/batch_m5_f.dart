/// M5 Batch F — Final 7 profiles to reach 80.
import 'package:forge_core/forge_core.dart';

final aquariumPflege = Profile(
  id: 'aquarium_pflege', title: 'Aquarium',
  view: ViewId.list,
  defaultWeights: const {'time': 0.6, 'stock': 0.4},
  fields: const [
    FieldSpec('intervalDays', 'Wasserwechsel alle X Tage', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt', 'date'),
    FieldSpec('qty', 'Futter-Vorrat', 'double'),
    FieldSpec('reorderAt', 'Nachkaufen ab', 'double'),
  ],
  actions: const ['complete', 'setQty', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'aquarium_pflege',
  skin: const {'icon': 'water'},
);

final kaminholz = Profile(
  id: 'kaminholz', title: 'Kaminholz / Brennstoff',
  view: ViewId.list,
  defaultWeights: const {'stock': 1},
  fields: const [
    FieldSpec('qty', 'Vorrat (Raummeter)', 'double', required: true),
    FieldSpec('reorderAt', 'Nachbestellen ab', 'double', required: true),
  ],
  actions: const ['setQty', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'kaminholz',
  skin: const {'icon': 'fireplace'},
);

final poolPflege = Profile(
  id: 'pool_pflege', title: 'Pool / Whirlpool',
  view: ViewId.list,
  defaultWeights: const {'time': 0.7, 'stock': 0.3},
  fields: const [
    FieldSpec('intervalDays', 'Reinigung alle X Tage', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt', 'date'),
    FieldSpec('qty', 'Chlor-Vorrat', 'double'),
    FieldSpec('reorderAt', 'Nachkaufen ab', 'double'),
  ],
  actions: const ['complete', 'setQty', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'pool_pflege',
  skin: const {'icon': 'pool'},
);

final solarAnlage = Profile(
  id: 'solar_anlage', title: 'Solar / PV-Anlage',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Wartung alle X Tage', 'int', required: true),
    FieldSpec('lastDone', 'Letzte Wartung', 'date'),
    FieldSpec('device', 'Anlage / Wechselrichter', 'text'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'solar_anlage',
  skin: const {'icon': 'solar_power'},
);

final entkalken = Profile(
  id: 'entkalken', title: 'Entkalken',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Alle X Tage', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt', 'date'),
    FieldSpec('device', 'Gerät (Kaffeemaschine, Wasserkocher...)', 'text'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'entkalken',
  skin: const {'icon': 'coffee_maker'},
);

final matratzeWenden = Profile(
  id: 'matratze_wenden', title: 'Matratze wenden',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Alle X Wochen (×7)', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt', 'date'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'matratze_wenden',
  skin: const {'icon': 'bed'},
);

final kuechengeraeteReinigung = Profile(
  id: 'kuechengeraete_reinigung', title: 'Geräte-Reinigung',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Alle X Tage', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt', 'date'),
    FieldSpec('device', 'Gerät (Ofen, Geschirrspüler...)', 'text'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'kuechengeraete_reinigung',
  skin: const {'icon': 'microwave'},
);
