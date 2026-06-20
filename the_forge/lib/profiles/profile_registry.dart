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
import 'auto_service.dart';
import 'fitness_tracker.dart';
import 'subscription_cost.dart';
import 'pet_care.dart';
import 'birthday_reminder.dart';
import 'water_intake.dart';
import 'screen_time.dart';
import 'password_rotation.dart';
import 'sleep_tracker.dart';
import 'savings_goal.dart';
import 'tool_lending.dart';
import 'gratitude_log.dart';

/// Central registry of all available profiles ("apps").
///
/// Current count: **25 profiles**. Engine code unchanged since M0.
/// Each profile is ~20 lines. The full registry is this file.
/// Adding a new "app" = one import + one entry. Nothing else.
final List<Profile> allProfiles = [
  // ── TIME / DEADLINES ──
  deadlineLedger,
  calendarOverview,
  birthdayReminder,
  contractTracker,
  warrantyTracker,
  subscriptionCost,
  autoService,
  toolLending,

  // ── INTERVALS / HABITS ──
  plantCare,
  petCare,
  cleaningPlan,
  fitnessTracker,
  waterIntake,
  screenTime,
  sleepTracker,
  passwordRotation,
  gratitudeLog,

  // ── STOCK / INVENTORY ──
  medicationTracker,
  householdInventory,
  kitchenLoop,
  savingsGoal,

  // ── ROUTINES / PROGRESS ──
  routineEngine,
  kidsRoutine,

  // ── DOCUMENTS / RETENTION ──
  documentBrain,

  // ── ACCESSIBILITY ──
  seniorContacts,
];

Profile? profileById(String id) {
  for (final p in allProfiles) {
    if (p.id == id) return p;
  }
  return null;
}
