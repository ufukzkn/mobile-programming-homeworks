import 'package:flutter_test/flutter_test.dart';
import 'package:campus_event_explorer/data/events.dart';
import 'package:campus_event_explorer/models/campus_event.dart';

void main() {
  test(
    'fixture meets event, category, date, image and capacity requirements',
    () {
      final events = createEvents();
      expect(events.length, greaterThanOrEqualTo(6));
      expect(events.map((e) => e.id).toSet().length, events.length);
      expect(
        events.map((e) => e.category).toSet().length,
        greaterThanOrEqualTo(3),
      );
      expect(
        events.map((e) => e.image).toSet().length,
        greaterThanOrEqualTo(3),
      );
      expect(events.any((e) => e.initialAvailable == 0), isTrue);
      expect(events.any((e) => e.initialAvailable == 1), isTrue);
      for (final e in events) {
        expect(e.date.isAfter(DateTime(2026, 10, 25, 23, 59)), isTrue);
        expect(e.available, inInclusiveRange(0, e.capacity));
      }
    },
  );

  test(
    'last place can be joined once and cancelled without capacity drift',
    () {
      final e = createEvents().firstWhere((e) => e.initialAvailable == 1);
      expect(e.join(), isTrue);
      expect(e.available, 0);
      expect(e.join(), isFalse);
      expect(e.available, 0);
      expect(e.cancelParticipation(), isTrue);
      expect(e.available, 1);
      expect(e.cancelParticipation(), isFalse);
      for (var i = 0; i < 20; i++) {
        e.join();
        e.cancelParticipation();
      }
      expect(e.available, e.initialAvailable);
    },
  );

  test(
    'full event rejects joining and favorite changes cannot affect seats',
    () {
      final e = createEvents().firstWhere((e) => e.initialAvailable == 0);
      e.isFavorite = true;
      expect(e.join(), isFalse);
      expect(e.isJoined, isFalse);
      expect(e.available, 0);
      expect(e.isFavorite, isTrue);
    },
  );

  test(
    'trimmed case insensitive search combines with category and each view',
    () {
      final events = createEvents();
      final e = events.first;
      e.isFavorite = true;
      e.join();
      for (final view in EventView.values) {
        expect(
          filterEvents(
            events,
            view: view,
            query: '  fLuTtEr  ',
            category: EventCategory.technology,
          ),
          [e],
        );
        expect(
          filterEvents(
            events,
            view: view,
            query: 'flutter',
            category: EventCategory.sports,
          ),
          isEmpty,
        );
        expect(filterEvents(events, view: view, query: 'nonexistent'), isEmpty);
      }
      expect(filterEvents(events, view: EventView.favorites).length, 1);
      expect(filterEvents(events, view: EventView.joined).length, 1);
    },
  );

  test('new session has no favorites or participation', () {
    final old = createEvents();
    old.first.isFavorite = true;
    old.first.join();
    expect(createEvents().every((e) => !e.isFavorite && !e.isJoined), isTrue);
  });
}
