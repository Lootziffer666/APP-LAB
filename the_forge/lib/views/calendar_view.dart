import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_core/forge_core.dart';

import '../state/forge_state.dart';
import '../theme/forge_colors.dart';
import '../theme/forge_design_bridge.dart';
import '../widgets/forge_item_card.dart';

/// CalendarView — monthly dot-calendar with item list per selected day.
/// Shows which days have due items and lets the user drill into a day.
class CalendarView extends ConsumerStatefulWidget {
  const CalendarView({super.key, required this.items, required this.profile});

  final List<Item> items;
  final Profile profile;

  @override
  ConsumerState<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<CalendarView> {
  late DateTime _selectedDay;
  late DateTime _focusMonth;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusMonth = DateTime(_selectedDay.year, _selectedDay.month);
  }

  /// Get due date for an item (either dueDate or computed from interval).
  DateTime? _itemDueDate(Item item) {
    final due = item.attrs['dueDate'];
    if (due is int) return DateTime.fromMillisecondsSinceEpoch(due);

    final interval = item.attrs['intervalDays'];
    final lastDone = item.attrs['lastDone'];
    if (interval is num && lastDone is int) {
      return DateTime.fromMillisecondsSinceEpoch(
          lastDone + (interval.toInt() * 86400000));
    }

    final archive = item.attrs['archiveDate'];
    if (archive is int) return DateTime.fromMillisecondsSinceEpoch(archive);

    return null;
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<Item> _itemsForDay(DateTime day) {
    return widget.items.where((item) {
      final d = _itemDueDate(item);
      return d != null && _sameDay(d, day);
    }).toList();
  }

  Map<int, Bucket> _dayBuckets() {
    final map = <int, Bucket>{};
    for (final item in widget.items) {
      final d = _itemDueDate(item);
      if (d == null) continue;
      if (d.year != _focusMonth.year || d.month != _focusMonth.month) continue;
      final status = evaluateItem(item);
      final existing = map[d.day];
      if (existing == null || status.bucket.index > existing.index) {
        map[d.day] = status.bucket;
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final dayBuckets = _dayBuckets();
    final itemsToday = _itemsForDay(_selectedDay);
    final daysInMonth =
        DateTime(_focusMonth.year, _focusMonth.month + 1, 0).day;
    final firstWeekday =
        DateTime(_focusMonth.year, _focusMonth.month, 1).weekday; // 1=Mon

    return Column(
      children: [
        // Month header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: () => setState(() {
                  _focusMonth = DateTime(
                      _focusMonth.year, _focusMonth.month - 1);
                }),
              ),
              Text(
                _monthName(_focusMonth.month) + ' ${_focusMonth.year}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: () => setState(() {
                  _focusMonth = DateTime(
                      _focusMonth.year, _focusMonth.month + 1);
                }),
              ),
            ],
          ),
        ),
        // Weekday headers
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(d,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: ForgeColors.muted.withAlpha(150),
                            )),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 4),
        // Day grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
            ),
            itemCount: daysInMonth + firstWeekday - 1,
            itemBuilder: (context, index) {
              if (index < firstWeekday - 1) return const SizedBox.shrink();
              final day = index - firstWeekday + 2;
              final date = DateTime(_focusMonth.year, _focusMonth.month, day);
              final isSelected = _sameDay(date, _selectedDay);
              final isToday = _sameDay(date, DateTime.now());
              final bucket = dayBuckets[day];

              return GestureDetector(
                onTap: () => setState(() => _selectedDay = date),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ForgeColors.periwinkle.withAlpha(40)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday
                        ? Border.all(color: ForgeColors.periwinkle, width: 1.5)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isToday ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                      if (bucket != null) ...[
                        const SizedBox(height: 2),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: ForgeDesignBridge.instance
                                .bucketColor(bucket),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(height: 20),
        // Items for selected day
        Expanded(
          child: itemsToday.isEmpty
              ? Center(
                  child: Text(
                    'Nichts am ${_selectedDay.day}.${_selectedDay.month}.',
                    style: TextStyle(color: ForgeColors.muted.withAlpha(150)),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: itemsToday.length,
                  itemBuilder: (context, index) => ForgeItemCard(
                    item: itemsToday[index],
                    profile: widget.profile,
                  ),
                ),
        ),
      ],
    );
  }

  String _monthName(int m) => const [
        '', 'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni',
        'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember',
      ][m];
}
