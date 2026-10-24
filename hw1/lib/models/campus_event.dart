enum EventCategory {
  technology('Technology'),
  arts('Arts'),
  sports('Sports');

  const EventCategory(this.label);
  final String label;
}

enum EventView { explore, favorites, joined }

/// Fixed event data and in-memory state. Derived availability prevents drift.
class CampusEvent {
  CampusEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.venue,
    required this.description,
    required this.image,
    required this.capacity,
    required this.initialAvailable,
    required this.host,
  }) : assert(capacity > 0),
       assert(initialAvailable >= 0 && initialAvailable <= capacity);

  final String id, title, venue, description, image, host;
  final EventCategory category;
  final DateTime date;
  final int capacity, initialAvailable;
  bool isFavorite = false;
  bool _isJoined = false;
  bool get isJoined => _isJoined;
  int get available => initialAvailable - (_isJoined ? 1 : 0);

  bool join() {
    if (_isJoined || available == 0) return false;
    _isJoined = true;
    return true;
  }

  bool cancelParticipation() {
    if (!_isJoined) return false;
    _isJoined = false;
    return true;
  }

  String get shortDate => '${monthName(date.month)} ${date.day}';
  String get time =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  String get fullDate =>
      '${weekdayName(date.weekday)}, $shortDate, ${date.year}';
  String get dateTimeLabel => '$shortDate · $time';
}

String monthName(int month) => const [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
][month - 1];
String weekdayName(int weekday) => const [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
][weekday - 1];

/// The same query/category pair is used by every view.
List<CampusEvent> filterEvents(
  List<CampusEvent> events, {
  required EventView view,
  String query = '',
  EventCategory? category,
}) {
  final normalized = query.trim().toLowerCase();
  return events.where((event) {
    final inView = switch (view) {
      EventView.explore => true,
      EventView.favorites => event.isFavorite,
      EventView.joined => event.isJoined,
    };
    return inView &&
        (category == null || event.category == category) &&
        event.title.toLowerCase().contains(normalized);
  }).toList();
}
