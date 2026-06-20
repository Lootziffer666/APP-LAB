import 'package:forge_core/forge_core.dart';
import 'package:test/test.dart';

// Fixed "now" matching one-engine-test.js: 2026-06-19T09:00:00Z
final int now = DateTime.utc(2026, 6, 19, 9).millisecondsSinceEpoch;
const int day = 86400000;

Item make(String title, Map<String, double> weights, Map<String, Object?> attrs) =>
    Item(
      id: title,
      type: 'test',
      title: title,
      weights: weights,
      attrs: attrs,
      createdAt: now,
      updatedAt: now,
    );

void main() {
  group('one engine, weighting shifted — same proof as JS', () {
    test('plant (pure interval/time)', () {
      final r = evaluate(
          make('Monstera', {'time': 1}, {'intervalDays': 7, 'lastDone': now - 6 * day}),
          now);
      expect(r.driver, 'time');
      expect(r.urgency, 0.86);
      expect(r.bucket, Bucket.due);
    });

    test('contract cancellation (pure dueDate)', () {
      final r = evaluate(
          make('Handytarif', {'time': 1}, {'dueDate': now + 5 * day, 'warnDays': 30}),
          now);
      expect(r.bucket, Bucket.due);
      expect(r.urgency, 0.83);
    });

    test('screw inventory (pure stock)', () {
      final r = evaluate(
          make('Spax 4x40', {'stock': 1}, {'qty': 3, 'reorderAt': 20}), now);
      expect(r.driver, 'stock');
      expect(r.bucket, Bucket.due);
      expect(r.urgency, 0.85);
    });

    test('document retention expired (pure retention)', () {
      final r = evaluate(
          make('Stromrechnung 2016', {'retention': 1},
              {'archiveDate': now - 2 * day, 'warnDays': 30}),
          now);
      expect(r.driver, 'retention');
      expect(r.bucket, Bucket.critical);
      expect(r.urgency, 1.0);
    });

    test('kids morning routine (pure progress)', () {
      final r = evaluate(
          make('Morgenroutine', {'progress': 1}, {
            'steps': [
              {'t': 'anziehen', 'done': true},
              {'t': 'Zähne', 'done': false},
              {'t': 'Frühstück', 'done': false},
              {'t': 'Schuhe', 'done': false},
            ]
          }),
          now);
      expect(r.driver, 'progress');
      expect(r.urgency, 0.75);
      expect(r.bucket, Bucket.due);
    });

    test('THE PROOF: medication = intake + supply in ONE weight vector', () {
      final r = evaluate(
          make('Vitamin D', {'time': 0.6, 'stock': 0.4}, {
            'intervalDays': 1,
            'lastDone': now - 1 * day,
            'qty': 8,
            'reorderAt': 10,
          }),
          now);
      // two "apps" collapsed: time dominates today, low stock already pushing
      expect(r.driver, 'time');
      expect(r.urgency, 0.68);
      expect(r.bucket, Bucket.due);
    });

    test('new app = pure data, no code: car inspection due far off', () {
      final r = evaluate(
          make('TÜV', {'time': 1}, {'dueDate': now + 40 * day, 'warnDays': 30}),
          now);
      expect(r.bucket, Bucket.ok);
      expect(r.urgency, 0.0);
    });
  });

  test('extensibility: register a new signal without touching the engine', () {
    final reg = SignalRegistry.builtin()
      ..register('mood', (a, n) => ((a['mood'] as num?)?.toDouble() ?? 0));
    final r = evaluate(make('vibes', {'mood': 1}, {'mood': 0.7}), now, registry: reg);
    expect(r.driver, 'mood');
    expect(r.bucket, Bucket.due);
  });
}
