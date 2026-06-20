import 'package:forge_core/forge_core.dart';

import 'deadline_ledger.dart';
import 'household_inventory.dart';
import 'routine_engine.dart';
import 'medication_tracker.dart';
import 'kitchen_loop.dart';
import 'plant_care.dart';
import 'document_brain.dart';

/// Central registry of all available profiles ("apps").
/// Adding a new "app" = adding one import + one entry here.
/// No new core code anywhere else. Ever.
final List<Profile> allProfiles = [
  deadlineLedger,
  plantCare,
  medicationTracker,
  householdInventory,
  kitchenLoop,
  routineEngine,
  documentBrain,
  // M5: familyCare, seniorMode, couchMode, brainDump, ...
];

Profile? profileById(String id) {
  for (final p in allProfiles) {
    if (p.id == id) return p;
  }
  return null;
}
