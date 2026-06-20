/// P1 — the single universal record. One table, not one schema per theme.

/// Lifecycle state of any item, regardless of theme.
enum ItemState { active, snoozed, done, archived }

/// One entry in an item's audit trail (which verb fired, when).
class HistoryEntry {
  final int at; // epoch millis
  final String verb;
  final Map<String, Object?> meta;

  const HistoryEntry(this.at, this.verb, [this.meta = const {}]);

  Map<String, Object?> toJson() => {'at': at, 'verb': verb, if (meta.isNotEmpty) 'meta': meta};

  factory HistoryEntry.fromJson(Map<String, Object?> j) => HistoryEntry(
        j['at'] as int,
        j['verb'] as String,
        (j['meta'] as Map?)?.cast<String, Object?>() ?? const {},
      );
}

/// The universal item. A plant, a contract, a screw, a document, a routine —
/// all are this, differing only by [attrs] and [weights].
class Item {
  final String id;
  final String type; // free label, e.g. "plant", "contract" — pure metadata
  final String title;

  /// Raw, theme-specific facts: dueDate, intervalDays, lastDone, qty,
  /// reorderAt, location, file, steps, archiveDate, warnDays, ...
  final Map<String, Object?> attrs;

  /// THE differentiator. Signal-key -> weight. {time:1}, {stock:1},
  /// {time:0.6, stock:0.4}, ... This is what makes an item behave like a
  /// specific "app".
  final Map<String, double> weights;

  final ItemState state;
  final String? parentId; // routine -> steps, recipe -> ingredients
  final List<String> refs; // arbitrary cross-links
  final List<HistoryEntry> history;
  final int createdAt;
  final int updatedAt;

  const Item({
    required this.id,
    required this.type,
    required this.title,
    this.attrs = const {},
    this.weights = const {},
    this.state = ItemState.active,
    this.parentId,
    this.refs = const [],
    this.history = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  Item copyWith({
    String? title,
    Map<String, Object?>? attrs,
    Map<String, double>? weights,
    ItemState? state,
    String? parentId,
    List<String>? refs,
    List<HistoryEntry>? history,
    int? updatedAt,
  }) {
    return Item(
      id: id,
      type: type,
      title: title ?? this.title,
      attrs: attrs ?? this.attrs,
      weights: weights ?? this.weights,
      state: state ?? this.state,
      parentId: parentId ?? this.parentId,
      refs: refs ?? this.refs,
      history: history ?? this.history,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'attrs': attrs,
        'weights': weights,
        'state': state.name,
        if (parentId != null) 'parentId': parentId,
        'refs': refs,
        'history': history.map((h) => h.toJson()).toList(),
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  factory Item.fromJson(Map<String, Object?> j) => Item(
        id: j['id'] as String,
        type: j['type'] as String,
        title: j['title'] as String,
        attrs: (j['attrs'] as Map?)?.cast<String, Object?>() ?? const {},
        weights: ((j['weights'] as Map?) ?? const {})
            .map((k, v) => MapEntry(k as String, (v as num).toDouble())),
        state: ItemState.values.byName(j['state'] as String? ?? 'active'),
        parentId: j['parentId'] as String?,
        refs: ((j['refs'] as List?) ?? const []).cast<String>(),
        history: ((j['history'] as List?) ?? const [])
            .map((e) => HistoryEntry.fromJson((e as Map).cast<String, Object?>()))
            .toList(),
        createdAt: j['createdAt'] as int,
        updatedAt: j['updatedAt'] as int,
      );
}
