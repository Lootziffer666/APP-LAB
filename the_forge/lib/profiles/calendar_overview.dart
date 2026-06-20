import 'package:forge_core/forge_core.dart';

/// Calendar Overview — the SAME data as Deadline Ledger, just in a calendar view.
/// This proves: switching the view is a one-line change, not a new app.
final calendarOverview = Profile(
  id: 'calendar_overview',
  title: 'Kalender',
  view: ViewId.calendar,
  defaultWeights: const {'time': 1},
  fields: const [
    FieldSpec('dueDate', 'Fällig am', 'date', required: true),
    FieldSpec('intervalDays', 'Intervall (Tage)', 'int'),
    FieldSpec('warnDays', 'Vorwarnung (Tage)', 'int'),
  ],
  actions: const ['complete', 'snooze', 'archive'],
  // Shows ALL time-driven items (across types) in one calendar
  filter: (item) =>
      item.state == ItemState.active &&
      (item.attrs.containsKey('dueDate') ||
       item.attrs.containsKey('intervalDays') ||
       item.attrs.containsKey('archiveDate')),
  skin: const {
    'icon': 'calendar_month',
    'emptyLottie': 'assets/lottie/empty_calendar.json',
  },
);
