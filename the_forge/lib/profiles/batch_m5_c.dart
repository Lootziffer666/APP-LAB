/// M5 Batch C — Routine/Progress-driven profiles.
import 'package:forge_core/forge_core.dart';

final shutdownRitual = Profile(
  id: 'shutdown_ritual', title: 'Feierabend-Ritual', view: ViewId.board,
  defaultWeights: const {'progress': 1},
  fields: const [FieldSpec('steps', 'Schritte', 'steps', required: true)],
  actions: const ['toggleStep', 'reset'],
  filter: (i) => i.state == ItemState.active && i.type == 'shutdown_ritual',
  skin: const {'icon': 'nightlight'},
);

final morningRoutineAdult = Profile(
  id: 'morning_routine_adult', title: 'Morgenroutine', view: ViewId.board,
  defaultWeights: const {'progress': 1},
  fields: const [FieldSpec('steps', 'Schritte', 'steps', required: true)],
  actions: const ['toggleStep', 'reset'],
  filter: (i) => i.state == ItemState.active && i.type == 'morning_routine_adult',
  skin: const {'icon': 'wb_sunny'},
);

final packlistReise = Profile(
  id: 'packlist_reise', title: 'Packliste', view: ViewId.board,
  defaultWeights: const {'progress': 1},
  fields: const [FieldSpec('steps', 'Items', 'steps', required: true)],
  actions: const ['toggleStep', 'reset', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'packlist_reise',
  skin: const {'icon': 'luggage'},
);

final einkaufszettel = Profile(
  id: 'einkaufszettel', title: 'Einkaufszettel', view: ViewId.board,
  defaultWeights: const {'progress': 1},
  fields: const [FieldSpec('steps', 'Items', 'steps', required: true)],
  actions: const ['toggleStep', 'reset', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'einkaufszettel',
  skin: const {'icon': 'shopping_cart'},
);

final wochenplanung = Profile(
  id: 'wochenplanung', title: 'Wochenplanung', view: ViewId.board,
  defaultWeights: const {'progress': 0.6, 'time': 0.4},
  fields: const [
    FieldSpec('steps', 'Aufgaben', 'steps', required: true),
    FieldSpec('dueDate', 'Fällig am (Sonntag)', 'date'),
  ],
  actions: const ['toggleStep', 'reset', 'complete'],
  filter: (i) => i.state == ItemState.active && i.type == 'wochenplanung',
  skin: const {'icon': 'view_week'},
);

final projektChecklist = Profile(
  id: 'projekt_checklist', title: 'Projekt-Checkliste', view: ViewId.board,
  defaultWeights: const {'progress': 1},
  fields: const [
    FieldSpec('steps', 'Meilensteine', 'steps', required: true),
    FieldSpec('dueDate', 'Deadline', 'date'),
  ],
  actions: const ['toggleStep', 'reset', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'projekt_checklist',
  skin: const {'icon': 'assignment'},
);

final gartenSaison = Profile(
  id: 'garten_saison', title: 'Garten-Saison', view: ViewId.board,
  defaultWeights: const {'progress': 0.5, 'time': 0.5},
  fields: const [
    FieldSpec('steps', 'Aufgaben', 'steps', required: true),
    FieldSpec('dueDate', 'Erledigen bis', 'date'),
  ],
  actions: const ['toggleStep', 'reset', 'complete'],
  filter: (i) => i.state == ItemState.active && i.type == 'garten_saison',
  skin: const {'icon': 'yard'},
);

final umzugChecklist = Profile(
  id: 'umzug_checklist', title: 'Umzug-Checkliste', view: ViewId.board,
  defaultWeights: const {'progress': 0.7, 'time': 0.3},
  fields: const [
    FieldSpec('steps', 'Aufgaben', 'steps', required: true),
    FieldSpec('dueDate', 'Umzugstag', 'date'),
  ],
  actions: const ['toggleStep', 'reset', 'archive'],
  filter: (i) => i.state == ItemState.active && i.type == 'umzug_checklist',
  skin: const {'icon': 'local_shipping'},
);
