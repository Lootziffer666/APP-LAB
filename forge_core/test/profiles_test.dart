import 'package:forge_core/forge_core.dart';
import 'package:test/test.dart';

final int now = DateTime.utc(2026, 6, 19, 9).millisecondsSinceEpoch;
const int day = 86400000;

Item make(String title, String type, Map<String, double> weights,
        Map<String, Object?> attrs) =>
    Item(
      id: title,
      type: type,
      title: title,
      weights: weights,
      attrs: attrs,
      createdAt: now,
      updatedAt: now,
    );

void main() {
  group('Profile scenarios — each profile is pure config over the same engine', () {
    test('Plant Care: interval-only, 6 of 7 days elapsed → due', () {
      final r = evaluate(
        make('Monstera', 'plant_care', {'time': 1},
            {'intervalDays': 7, 'lastDone': now - 6 * day}),
        now,
      );
      expect(r.bucket, Bucket.due);
      expect(r.driver, 'time');
    });

    test('Plant Care: just watered → ok', () {
      final r = evaluate(
        make('Monstera', 'plant_care', {'time': 1},
            {'intervalDays': 7, 'lastDone': now}),
        now,
      );
      expect(r.bucket, Bucket.ok);
    });

    test('Medication: intake due + low stock → due, time dominates', () {
      final r = evaluate(
        make('Vitamin D', 'medication_tracker', {'time': 0.6, 'stock': 0.4},
            {'intervalDays': 1, 'lastDone': now - 1 * day, 'qty': 8, 'reorderAt': 10}),
        now,
      );
      expect(r.bucket, Bucket.due);
      expect(r.driver, 'time');
      // Both signals contribute
      expect(r.signals['time'], greaterThan(0.9));
      expect(r.signals['stock'], greaterThan(0.1));
    });

    test('Medication: taken today, plenty of stock → ok', () {
      final r = evaluate(
        make('Vitamin D', 'medication_tracker', {'time': 0.6, 'stock': 0.4},
            {'intervalDays': 1, 'lastDone': now, 'qty': 50, 'reorderAt': 10}),
        now,
      );
      expect(r.bucket, Bucket.ok);
    });

    test('Kitchen: expiry tomorrow + low qty → due', () {
      final r = evaluate(
        make('Milch', 'kitchen_loop', {'stock': 0.5, 'time': 0.5},
            {'qty': 1, 'reorderAt': 3, 'dueDate': now + 1 * day, 'warnDays': 7}),
        now,
      );
      expect(r.bucket, Bucket.due);
    });

    test('Document: retention expired → critical', () {
      final r = evaluate(
        make('Rechnung 2016', 'document_brain', {'retention': 1},
            {'archiveDate': now - 5 * day, 'warnDays': 30}),
        now,
      );
      expect(r.bucket, Bucket.critical);
      expect(r.driver, 'retention');
    });

    test('Document: retention far away → ok', () {
      final r = evaluate(
        make('Vertrag 2024', 'document_brain', {'retention': 1},
            {'archiveDate': now + 365 * day, 'warnDays': 30}),
        now,
      );
      expect(r.bucket, Bucket.ok);
    });

    test('Routine: all steps done → ok (progress = 0)', () {
      final r = evaluate(
        make('Morgenroutine', 'routine_engine', {'progress': 1}, {
          'steps': [
            {'t': 'a', 'done': true},
            {'t': 'b', 'done': true},
          ]
        }),
        now,
      );
      expect(r.bucket, Bucket.ok);
      expect(r.urgency, 0.0);
    });

    test('Routine: nothing done → critical', () {
      final r = evaluate(
        make('Putzplan', 'routine_engine', {'progress': 1}, {
          'steps': [
            {'t': 'a', 'done': false},
            {'t': 'b', 'done': false},
            {'t': 'c', 'done': false},
          ]
        }),
        now,
      );
      expect(r.bucket, Bucket.critical);
      expect(r.urgency, 1.0);
    });

    test('Inventory: fully stocked → ok', () {
      final r = evaluate(
        make('Schrauben', 'household_inventory', {'stock': 1},
            {'qty': 50, 'reorderAt': 20}),
        now,
      );
      expect(r.bucket, Bucket.ok);
    });

    test('Inventory: empty → critical', () {
      final r = evaluate(
        make('Batterien', 'household_inventory', {'stock': 1},
            {'qty': 0, 'reorderAt': 10}),
        now,
      );
      expect(r.bucket, Bucket.critical);
    });
  });

  test('complete on recurring plant resets clock, stays active', () {
    final plant = make('Monstera', 'plant_care', {'time': 1},
        {'intervalDays': 7, 'lastDone': now - 6 * day});
    final after = complete(plant, now);
    expect(after.state, ItemState.active);
    expect(after.attrs['lastDone'], now);
    // Now urgency should be 0
    expect(evaluate(after, now).bucket, Bucket.ok);
  });

  test('toggleStep drives progress signal accurately', () {
    final routine = make('Morning', 'routine_engine', {'progress': 1}, {
      'steps': [
        {'t': 'a', 'done': false},
        {'t': 'b', 'done': false},
        {'t': 'c', 'done': false},
        {'t': 'd', 'done': false},
      ]
    });
    expect(evaluate(routine, now).urgency, 1.0); // 0/4 done

    final s1 = toggleStep(routine, now, 0);
    expect(evaluate(s1, now).urgency, 0.75); // 1/4 done

    final s2 = toggleStep(s1, now, 1);
    expect(evaluate(s2, now).urgency, 0.5); // 2/4 done

    final s3 = toggleStep(s2, now, 2);
    final s4 = toggleStep(s3, now, 3);
    expect(evaluate(s4, now).urgency, 0.0); // 4/4 done → ok
  });
}
