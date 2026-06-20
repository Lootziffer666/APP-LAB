/// M5 Batch B — Stock/Inventory-driven profiles.
import 'package:forge_core/forge_core.dart';

final gewuerzRegal = Profile(
  id: 'gewuerz_regal', title: 'Gewürze & Vorräte', view: ViewId.grid,
  defaultWeights: const {'stock': 1},
  fields: const [
    FieldSpec('qty', 'Menge', 'double', required: true),
    FieldSpec('reorderAt', 'Nachkaufen ab', 'double', required: true),
    FieldSpec('location', 'Ort', 'text'),
  ],
  actions: const ['setQty', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'gewuerz_regal',
  skin: const {'icon': 'lunch_dining'},
);

final tiefkuehlgut = Profile(
  id: 'tiefkuehlgut', title: 'Tiefkühlgut', view: ViewId.grid,
  defaultWeights: const {'stock': 0.5, 'time': 0.5},
  fields: const [
    FieldSpec('qty', 'Menge', 'double', required: true),
    FieldSpec('reorderAt', 'Min. Vorrat', 'double'),
    FieldSpec('dueDate', 'Haltbar bis', 'date'),
    FieldSpec('warnDays', 'Vorwarnung', 'int'),
  ],
  actions: const ['setQty', 'complete', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'tiefkuehlgut',
  skin: const {'icon': 'ac_unit'},
);

final druckerpatrone = Profile(
  id: 'drucker_patrone', title: 'Drucker & Toner', view: ViewId.list,
  defaultWeights: const {'stock': 1},
  fields: const [
    FieldSpec('qty', 'Füllstand (%)', 'double', required: true),
    FieldSpec('reorderAt', 'Bestellen ab (%)', 'double', required: true),
  ],
  actions: const ['setQty', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'drucker_patrone',
  skin: const {'icon': 'print'},
);

final putzmittel = Profile(
  id: 'putzmittel', title: 'Putzmittel-Vorrat', view: ViewId.grid,
  defaultWeights: const {'stock': 1},
  fields: const [
    FieldSpec('qty', 'Vorrat', 'double', required: true),
    FieldSpec('reorderAt', 'Nachkaufen ab', 'double', required: true),
    FieldSpec('location', 'Lagerort', 'text'),
  ],
  actions: const ['setQty', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'putzmittel',
  skin: const {'icon': 'cleaning_services'},
);

final heizoel = Profile(
  id: 'heizoel', title: 'Heizöl / Pellets / Gas', view: ViewId.list,
  defaultWeights: const {'stock': 1},
  fields: const [
    FieldSpec('qty', 'Füllstand (Liter/kg)', 'double', required: true),
    FieldSpec('reorderAt', 'Bestellen ab', 'double', required: true),
  ],
  actions: const ['setQty', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'heizoel',
  skin: const {'icon': 'local_fire_department'},
);

final kontaktlinsen = Profile(
  id: 'kontaktlinsen', title: 'Kontaktlinsen', view: ViewId.list,
  defaultWeights: const {'stock': 0.6, 'time': 0.4},
  fields: const [
    FieldSpec('qty', 'Vorrat (Paare)', 'double', required: true),
    FieldSpec('reorderAt', 'Nachbestellen ab', 'double', required: true),
    FieldSpec('intervalDays', 'Wechsel alle X Tage', 'int'),
    FieldSpec('lastDone', 'Letzter Wechsel', 'date'),
  ],
  actions: const ['complete', 'setQty', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'kontaktlinsen',
  skin: const {'icon': 'visibility'},
);

final windeln = Profile(
  id: 'windeln', title: 'Baby-Vorrat', view: ViewId.grid,
  defaultWeights: const {'stock': 1},
  fields: const [
    FieldSpec('qty', 'Vorrat', 'double', required: true),
    FieldSpec('reorderAt', 'Nachkaufen ab', 'double', required: true),
    FieldSpec('location', 'Lagerort', 'text'),
  ],
  actions: const ['setQty', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'windeln',
  skin: const {'icon': 'child_friendly'},
);

final seriennummern = Profile(
  id: 'seriennummern', title: 'Seriennummern & Assets', view: ViewId.grid,
  defaultWeights: const {'stock': 0}, // no urgency, pure archive
  fields: const [
    FieldSpec('serialNumber', 'Seriennummer', 'text', required: true),
    FieldSpec('purchasePrice', 'Kaufpreis (€)', 'double'),
    FieldSpec('location', 'Standort', 'text'),
  ],
  actions: const ['archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'seriennummern',
  skin: const {'icon': 'qr_code'},
);
