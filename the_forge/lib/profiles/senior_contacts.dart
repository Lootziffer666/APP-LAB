import 'package:forge_core/forge_core.dart';

/// Senior Simple Mode — big buttons for most important contacts/actions.
/// No due dates, no stock. Just a list of things to tap.
/// Uses bigButton view for maximum accessibility.
final seniorContacts = Profile(
  id: 'senior_contacts',
  title: 'Einfach-Modus',
  view: ViewId.bigButton,
  defaultWeights: const {'time': 0.5, 'progress': 0.5},
  fields: const [
    FieldSpec('intervalDays', 'Erinnerung alle X Tage', 'int'),
    FieldSpec('steps', 'Schritte', 'steps'),
  ],
  actions: const ['complete', 'reset'],
  filter: (item) =>
      item.state == ItemState.active && item.type == 'senior_contacts',
  skin: const {
    'icon': 'accessibility_new',
    'emptyLottie': 'assets/lottie/hello.json',
  },
);
