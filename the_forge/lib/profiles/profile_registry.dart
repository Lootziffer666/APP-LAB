import 'package:forge_core/forge_core.dart';

// ── Individual profiles ──
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

// ── Batch M5 profiles ──
import 'batch_m5_a.dart';
import 'batch_m5_b.dart';
import 'batch_m5_c.dart';
import 'batch_m5_d.dart';
import 'batch_m5_e.dart';
import 'batch_m5_f.dart';

/// Central registry of all available profiles ("apps").
///
/// **80 profiles. 1 engine. 0 engine changes.**
///
/// Each profile is ~15-20 lines. Adding a new "app" = one entry here.
final List<Profile> allProfiles = [
  // ── TIME / DEADLINES (22) ──
  deadlineLedger,
  calendarOverview,
  birthdayReminder,
  contractTracker,
  warrantyTracker,
  subscriptionCost,
  autoService,
  toolLending,
  impfTracker,
  tuevReminder,
  steuerTermine,
  versicherungen,
  mietvertrag,
  zahnarztTermin,
  reifenwechsel,
  rauchmelderCheck,
  wasserfilter,
  backupReminder,
  bibliothekFrist,
  reisepass,
  fuehrerschein,
  schornsteinfeger,

  // ── INTERVALS / HABITS (17) ──
  plantCare,
  petCare,
  cleaningPlan,
  fitnessTracker,
  waterIntake,
  screenTime,
  sleepTracker,
  passwordRotation,
  gratitudeLog,
  briefkasten,
  muelltonnen,
  luftfilter,
  blutspendeTermin,
  bettwaescheWechsel,
  nagelSchneiden,
  haarschnitt,
  sportVerein,

  // ── STOCK / INVENTORY (12) ──
  medicationTracker,
  householdInventory,
  kitchenLoop,
  savingsGoal,
  gewuerzRegal,
  tiefkuehlgut,
  druckerpatrone,
  putzmittel,
  heizoel,
  kontaktlinsen,
  windeln,
  seriennummern,

  // ── HYBRID (stock + time) (3) ──
  staubsaugerBeutel,
  grillenGas,
  saisonKleidung,

  // ── ROUTINES / PROGRESS (10) ──
  routineEngine,
  kidsRoutine,
  shutdownRitual,
  morningRoutineAdult,
  packlistReise,
  einkaufszettel,
  wochenplanung,
  projektChecklist,
  gartenSaison,
  umzugChecklist,

  // ── DOCUMENTS / RETENTION (2) ──
  documentBrain,
  dachrinne,

  // ── FAMILY / LIFESTYLE (5) ──
  stillAliveCheck,
  babysitter,
  haustierImpfung,
  vereinsbeitrag,
  seniorContacts,

  // ── MAINTENANCE / HOUSE (7) ──
  aquariumPflege,
  kaminholz,
  poolPflege,
  solarAnlage,
  entkalken,
  matratzeWenden,
  kuechengeraeteReinigung,
];

Profile? profileById(String id) {
  for (final p in allProfiles) {
    if (p.id == id) return p;
  }
  return null;
}
