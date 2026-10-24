import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../theme.dart';
import '../widgets/event_card.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.onFavorite,
    required this.onParticipation,
  });
  final CampusEvent event;
  final VoidCallback onFavorite, onParticipation;
  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool _confirming = false;

  Future<void> _confirmParticipation() async {
    final event = widget.event;
    if (_confirming || (!event.isJoined && event.available == 0)) return;
    setState(() => _confirming = true);
    final cancelling = event.isJoined;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: Icon(
          cancelling
              ? Icons.event_busy_outlined
              : Icons.confirmation_number_outlined,
          color: forest,
          size: 30,
        ),
        title: Text(
          cancelling ? 'Cancel participation?' : 'Join this event?',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            EventMeta(
              icon: Icons.calendar_today_outlined,
              text: '${event.fullDate} · ${event.time}',
            ),
            const SizedBox(height: 10),
            EventMeta(icon: Icons.place_outlined, text: event.venue),
            const SizedBox(height: 17),
            Text(
              cancelling
                  ? 'Your place will be released for another student.'
                  : 'One place will be reserved for you in this app session.',
              style: const TextStyle(fontSize: 12, color: muted, height: 1.6),
            ),
          ],
        ),
        actions: [
          TextButton(
            key: const ValueKey('confirm-no'),
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('No'),
          ),
          FilledButton(
            key: const ValueKey('confirm-yes'),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed == true) {
      widget.onParticipation();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            cancelling
                ? 'Participation cancelled. Your place is available again.'
                : "You're in! Find this event in My Events.",
          ),
        ),
      );
    }
    setState(() => _confirming = false);
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final full = !event.isJoined && event.available == 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'The details',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            key: const ValueKey('details-favorite'),
            tooltip: event.isFavorite
                ? 'Remove from favorites'
                : 'Save to favorites',
            onPressed: () {
              widget.onFavorite();
              setState(() {});
            },
            icon: Icon(
              event.isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: forest,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Semantics(
                    label: '${event.title} image. Double tap to enlarge.',
                    child: GestureDetector(
                      key: const ValueKey('details-image'),
                      onDoubleTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => EventImageScreen(event: event),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(23),
                        child: AspectRatio(
                          aspectRatio: 1.65,
                          child: Hero(
                            tag: 'image-${event.id}',
                            child: Image.asset(
                              event.image,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 9, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.open_in_full_rounded, size: 11, color: muted),
                      SizedBox(width: 5),
                      Text(
                        'Double-tap image to take a closer look',
                        style: TextStyle(fontSize: 9, color: muted),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CategoryPill(category: event.category),
                          const Spacer(),
                          AvailabilityLabel(event: event),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 31,
                          height: 1.14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _infoTile(
                        Icons.calendar_month_outlined,
                        event.fullDate,
                        '${event.time} · Türkiye time (UTC+3)',
                      ),
                      const SizedBox(height: 17),
                      _infoTile(
                        Icons.place_outlined,
                        event.venue,
                        'Eskişehir Technical University',
                      ),
                      const SizedBox(height: 17),
                      _infoTile(
                        Icons.people_outline_rounded,
                        '${event.available} of ${event.capacity} places available',
                        '${event.initialAvailable} places available before your participation',
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1),
                      const SizedBox(height: 24),
                      const Text(
                        'A little about the event',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: muted,
                          height: 1.9,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF0E0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.diversity_2_outlined,
                              color: forest,
                              size: 26,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'BROUGHT TOGETHER BY',
                                    style: TextStyle(
                                      fontSize: 8,
                                      letterSpacing: 1.5,
                                      color: forest,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    event.host,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Event ID: ${event.id} · Fictional campus event',
                        style: const TextStyle(fontSize: 10, color: muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
        decoration: const BoxDecoration(
          color: paper,
          border: Border(top: BorderSide(color: line)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.isJoined
                          ? 'See you there.'
                          : full
                          ? 'All places taken'
                          : 'Make it a plan.',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      event.isJoined
                          ? 'You have 1 reserved place'
                          : full
                          ? 'You can still save this event'
                          : '${event.available} ${event.available == 1 ? 'place' : 'places'} available',
                      style: const TextStyle(fontSize: 10, color: muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                key: const ValueKey('participation-button'),
                onPressed: full || _confirming ? null : _confirmParticipation,
                child: Text(
                  event.isJoined
                      ? 'Cancel participation'
                      : full
                      ? 'Full'
                      : 'Join event',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String subtitle) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: line),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: forest),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: muted, height: 1.5),
            ),
          ],
        ),
      ),
    ],
  );
}

class EventImageScreen extends StatelessWidget {
  const EventImageScreen({super.key, required this.event});
  final CampusEvent event;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: ink,
    appBar: AppBar(
      backgroundColor: ink,
      foregroundColor: Colors.white,
      title: Text(event.title, style: const TextStyle(fontSize: 14)),
    ),
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: Hero(
                  tag: 'image-${event.id}',
                  child: Image.asset(
                    event.image,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Pinch or scroll to zoom · drag to explore',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ),
        ],
      ),
    ),
  );
}
