/// M5 Batch E — Remaining niche profiles.
import 'package:forge_core/forge_core.dart';

final grillenGas = Profile(
  id: 'grillen_gas', title: 'Gasflasche / Grill',
  view: ViewId.list,
  defaultWeights: const {'stock': 1},
  fields: const [
    FieldSpec('qty', 'Füllstand (%)', 'double', required: true),
    FieldSpec('reorderAt', 'Tauschen ab (%)', 'double'),
  ],
  actions: const ['setQty', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'grillen_gas',
  skin: const {'icon': 'outdoor_grill'},
);

final bibliothekFrist = Profile(
  id: 'bibliothek_frist', title: 'Bibliothek / Leihfrist',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Rückgabe bis', 'date', required: true),
    FieldSpec('warnDays', 'Vorwarnung', 'int'),
    FieldSpec('title_book', 'Titel', 'text'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'bibliothek_frist',
  skin: const {'icon': 'menu_book'},
);

final reisepass = Profile(
  id: 'reisepass', title: 'Reisepass & Ausweise',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Gültig bis', 'date', required: true),
    FieldSpec('warnDays', 'Vorwarnung (Tage)', 'int'),
    FieldSpec('docType', 'Dokumenttyp', 'text'),
  ],
  actions: const ['snooze', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'reisepass',
  skin: const {'icon': 'badge'},
);

final fuehrerschein = Profile(
  id: 'fuehrerschein', title: 'Führerschein & Zulassung',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Gültig bis / Erneuerung', 'date'),
    FieldSpec('warnDays', 'Vorwarnung', 'int'),
  ],
  actions: const ['snooze', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'fuehrerschein',
  skin: const {'icon': 'badge'},
);

final saisonKleidung = Profile(
  id: 'saison_kleidung', title: 'Saisonkleidung',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Umziehen bis', 'date'),
    FieldSpec('warnDays', 'Vorwarnung', 'int'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'saison_kleidung',
  skin: const {'icon': 'checkroom'},
);

final schornsteinfeger = Profile(
  id: 'schornsteinfeger', title: 'Schornsteinfeger',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Nächster Termin', 'date', required: true),
    FieldSpec('intervalDays', 'Intervall', 'int'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'schornsteinfeger',
  skin: const {'icon': 'fireplace'},
);

final dachrinne = Profile(
  id: 'dachrinne', title: 'Dachrinne reinigen',
  view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Alle X Monate (×30)', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt', 'date'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'dachrinne',
  skin: const {'icon': 'roofing'},
);
