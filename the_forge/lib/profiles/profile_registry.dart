import 'package:forge_core/forge_core.dart';

import 'deadline_ledger.dart';
import 'calendar_overview.dart';
import 'plant_care.dart';
import 'medication_tracker.dart';
import 'household_inventory.dart';
import 'kitchen_loop.dart';
import 'routine_engine.dart';
import 'document_brain.dart';
import 'contract_tracker.dart';
import 'warranty_tracker.dart';
import 'cleaning_plan.dart';
import 'senior_contacts.dart';
import 'kids_routine.dart';

/// Central registry of all available profiles ("apps").
/// Adding a new "app" = adding one import + one entry here.
/// No new core code anywhere else. Ever.
///
/// Current count: 13 profiles. Engine code unchanged since M0.
final List<Profile> allProfiles = [
  deadlineLedger,
  calendarOverview,
  contractTracker,
  warrantyTracker,
  plantCare,
  cleaningPlan,
  medicationTracker,
  householdInventory,
  kitchenLoop,
  routineEngine,
  kidsRoutine,
  documentBrain,
  seniorContacts,
];

Profile? profileById(String id) {
  for (final p in allProfiles) {
    if (p.id == id) return p;
  }
  return null;
}
