/// M5 Batch D — Hybrid, Family, and Lifestyle profiles.
import 'package:forge_core/forge_core.dart';

final stillAliveCheck = Profile(
  id: 'still_alive_check', title: 'Lebenszeichen', view: ViewId.bigButton,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Check alle X Tage', 'int', required: true),
    FieldSpec('lastDone', 'Letzter Check', 'date'),
    FieldSpec('contact', 'Person', 'text', required: true),
  ],
  actions: const ['complete', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'still_alive_check',
  skin: const {'icon': 'favorite_border'},
);

final briefkasten = Profile(
  id: 'briefkasten', title: 'Briefkasten leeren', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Alle X Tage', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt geleert', 'date'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'briefkasten',
  skin: const {'icon': 'mail'},
);

final muelltonnen = Profile(
  id: 'muelltonnen', title: 'Mülltonnen', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Abholintervall (Tage)', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt rausgestellt', 'date'),
    FieldSpec('bin', 'Tonne (Rest/Bio/Papier/Gelb)', 'text'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'muelltonnen',
  skin: const {'icon': 'delete'},
);

final luftfilter = Profile(
  id: 'luftfilter', title: 'Luftfilter / Klima', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Wechsel alle X Tage', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt gewechselt', 'date'),
    FieldSpec('device', 'Gerät', 'text'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'luftfilter',
  skin: const {'icon': 'air'},
);

final blutspendeTermin = Profile(
  id: 'blutspende', title: 'Blutspende', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Min. Abstand (56 Tage)', 'int', required: true),
    FieldSpec('lastDone', 'Letzte Spende', 'date'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'blutspende',
  skin: const {'icon': 'bloodtype'},
);

final babysitter = Profile(
  id: 'babysitter', title: 'Babysitter / Betreuung', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Nächster Termin', 'date'),
    FieldSpec('contact', 'Betreuungsperson', 'text'),
    FieldSpec('cost', 'Kosten/Stunde (€)', 'double'),
  ],
  actions: const ['complete', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'babysitter',
  skin: const {'icon': 'child_care'},
);

final haustierImpfung = Profile(
  id: 'haustier_impfung', title: 'Tier-Impfungen', view: ViewId.calendar,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Nächste Impfung', 'date', required: true),
    FieldSpec('warnDays', 'Vorwarnung', 'int'),
    FieldSpec('pet', 'Tier', 'text'),
    FieldSpec('vaccine', 'Impfstoff', 'text'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'haustier_impfung',
  skin: const {'icon': 'pets'},
);

final vereinsbeitrag = Profile(
  id: 'vereinsbeitrag', title: 'Vereinsbeiträge', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Fällig am', 'date', required: true),
    FieldSpec('intervalDays', 'Intervall', 'int'),
    FieldSpec('cost', 'Beitrag (€)', 'double'),
    FieldSpec('club', 'Verein', 'text'),
  ],
  actions: const ['complete', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'vereinsbeitrag',
  skin: const {'icon': 'groups'},
);

final bettwaescheWechsel = Profile(
  id: 'bettwaesche', title: 'Bettwäsche', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Wechsel alle X Tage', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt', 'date'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'bettwaesche',
  skin: const {'icon': 'bed'},
);

final staubsaugerBeutel = Profile(
  id: 'staubsauger_beutel', title: 'Staubsaugerbeutel', view: ViewId.list,
  defaultWeights: const {'stock': 0.6, 'time': 0.4},
  fields: const [
    FieldSpec('qty', 'Vorrat', 'double', required: true),
    FieldSpec('reorderAt', 'Nachkaufen ab', 'double', required: true),
    FieldSpec('intervalDays', 'Wechsel alle X Tage', 'int'),
    FieldSpec('lastDone', 'Letzter Wechsel', 'date'),
  ],
  actions: const ['complete', 'setQty', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'staubsauger_beutel',
  skin: const {'icon': 'vacuum'},
);

final nagelSchneiden = Profile(
  id: 'nagel_schneiden', title: 'Nägel schneiden', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Alle X Tage', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt', 'date'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'nagel_schneiden',
  skin: const {'icon': 'content_cut'},
);

final haarschnitt = Profile(
  id: 'haarschnitt', title: 'Friseur', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Alle X Wochen (×7)', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt', 'date'),
    FieldSpec('cost', 'Kosten (€)', 'double'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'haarschnitt',
  skin: const {'icon': 'content_cut'},
);

final sportVerein = Profile(
  id: 'sport_verein', title: 'Training / Kurse', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Trainingstag alle X Tage', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt', 'date'),
    FieldSpec('location', 'Ort', 'text'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'sport_verein',
  skin: const {'icon': 'sports'},
);
