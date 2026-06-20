/// M5 Batch A — Deadline/Time-driven profiles that don't exist yet.
import 'package:forge_core/forge_core.dart';

final impfTracker = Profile(
  id: 'impf_tracker', title: 'Impfungen', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Nächste Impfung', 'date', required: true),
    FieldSpec('warnDays', 'Vorwarnung', 'int'),
    FieldSpec('vaccine', 'Impfstoff', 'text'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'impf_tracker',
  skin: const {'icon': 'vaccines'},
);

final tuevReminder = Profile(
  id: 'tuev_reminder', title: 'TÜV & Prüfungen', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Nächster Termin', 'date', required: true),
    FieldSpec('warnDays', 'Vorwarnung', 'int'),
    FieldSpec('vehicle', 'Fahrzeug / Gerät', 'text'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'tuev_reminder',
  skin: const {'icon': 'verified'},
);

final steuerTermine = Profile(
  id: 'steuer_termine', title: 'Steuer & Fristen', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Abgabefrist', 'date', required: true),
    FieldSpec('warnDays', 'Vorwarnung', 'int'),
    FieldSpec('category', 'Art (ESt, USt, ...)', 'text'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'steuer_termine',
  skin: const {'icon': 'account_balance'},
);

final versicherungen = Profile(
  id: 'versicherungen', title: 'Versicherungen', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Kündigungsfrist', 'date', required: true),
    FieldSpec('warnDays', 'Vorwarnung', 'int'),
    FieldSpec('cost', 'Jahresbeitrag (€)', 'double'),
    FieldSpec('provider', 'Anbieter', 'text'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'versicherungen',
  skin: const {'icon': 'shield'},
);

final mietvertrag = Profile(
  id: 'mietvertrag', title: 'Mietvertrag & Nebenkosten', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Kündigungsfrist', 'date'),
    FieldSpec('intervalDays', 'Zahlungsintervall', 'int'),
    FieldSpec('cost', 'Monatl. Miete (€)', 'double'),
  ],
  actions: const ['complete', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'mietvertrag',
  skin: const {'icon': 'home'},
);

final zahnarztTermin = Profile(
  id: 'zahnarzt_termin', title: 'Arzttermine', view: ViewId.calendar,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Nächster Termin', 'date', required: true),
    FieldSpec('intervalDays', 'Alle X Monate (×30)', 'int'),
    FieldSpec('doctor', 'Arzt / Praxis', 'text'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'zahnarzt_termin',
  skin: const {'icon': 'medical_services'},
);

final reifenwechsel = Profile(
  id: 'reifenwechsel', title: 'Reifenwechsel', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Wechsel bis', 'date', required: true),
    FieldSpec('warnDays', 'Vorwarnung', 'int'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'reifenwechsel',
  skin: const {'icon': 'tire_repair'},
);

final rauchmelderCheck = Profile(
  id: 'rauchmelder_check', title: 'Rauchmelder & Prüfung', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Prüfintervall (Tage)', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt geprüft', 'date'),
    FieldSpec('location', 'Raum', 'text'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'rauchmelder_check',
  skin: const {'icon': 'detector_smoke'},
);

final wasserfilter = Profile(
  id: 'wasserfilter', title: 'Filter & Patronen', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Wechsel alle X Tage', 'int', required: true),
    FieldSpec('lastDone', 'Zuletzt gewechselt', 'date'),
    FieldSpec('device', 'Gerät', 'text'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'wasserfilter',
  skin: const {'icon': 'filter_alt'},
);

final backupReminder = Profile(
  id: 'backup_reminder', title: 'Backup & Datensicherung', view: ViewId.list,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('intervalDays', 'Alle X Tage', 'int', required: true),
    FieldSpec('lastDone', 'Letztes Backup', 'date'),
    FieldSpec('device', 'Gerät / Dienst', 'text'),
  ],
  actions: const ['complete', 'snooze'],
  filter: (i) => i.state == ItemState.active && i.type == 'backup_reminder',
  skin: const {'icon': 'cloud_upload'},
);
