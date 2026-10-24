import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../theme.dart';

Color categoryColor(EventCategory category) => switch (category) {
  EventCategory.technology => const Color(0xFFE8E4F7),
  EventCategory.arts => const Color(0xFFFFE7D9),
  EventCategory.sports => const Color(0xFFE5EDCB),
};

class CategoryPill extends StatelessWidget {
  const CategoryPill({super.key, required this.category});
  final EventCategory category;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
    decoration: BoxDecoration(
      color: categoryColor(category),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      category.label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: ink,
      ),
    ),
  );
}

class AvailabilityLabel extends StatelessWidget {
  const AvailabilityLabel({super.key, required this.event});
  final CampusEvent event;
  @override
  Widget build(BuildContext context) {
    final color = event.isJoined
        ? forest
        : event.available == 0
        ? const Color(0xFF906456)
        : event.available == 1
        ? const Color(0xFFAB6330)
        : forest;
    final label = event.isJoined
        ? "You're going"
        : event.available == 0
        ? 'Full'
        : event.available == 1
        ? 'Last place!'
        : '${event.available} places left';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          event.isJoined ? Icons.check_circle_outline_rounded : Icons.circle,
          size: event.isJoined ? 15 : 6,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.onFavorite,
    required this.onOpen,
  });
  final CampusEvent event;
  final VoidCallback onFavorite, onOpen;
  @override
  Widget build(BuildContext context) => Container(
    key: ValueKey('card-${event.id}'),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: line),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Semantics(
              label: 'Open details for ${event.title}',
              button: true,
              child: InkWell(
                onTap: onOpen,
                child: AspectRatio(
                  aspectRatio: 2.15,
                  child: Hero(
                    tag: 'image-${event.id}',
                    child: Image.asset(
                      event.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: paper,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  event.shortDate.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: IconButton.filledTonal(
                key: ValueKey('favorite-${event.id}'),
                tooltip: event.isFavorite
                    ? 'Remove ${event.title} from favorites'
                    : 'Save ${event.title} to favorites',
                style: IconButton.styleFrom(
                  backgroundColor: paper,
                  foregroundColor: forest,
                ),
                onPressed: onFavorite,
                icon: Icon(
                  event.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 21,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 7),
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
              const SizedBox(height: 13),
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.6,
                ),
              ),
              const SizedBox(height: 12),
              EventMeta(
                icon: Icons.schedule_rounded,
                text: event.dateTimeLabel,
              ),
              const SizedBox(height: 7),
              EventMeta(icon: Icons.place_outlined, text: event.venue),
              const SizedBox(height: 12),
              const Divider(height: 1),
              Row(
                children: [
                  const Icon(
                    Icons.people_outline_rounded,
                    color: muted,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${event.capacity} total places',
                      style: const TextStyle(fontSize: 11, color: muted),
                    ),
                  ),
                  TextButton(
                    key: ValueKey('details-${event.id}'),
                    onPressed: onOpen,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View details',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 7),
                        Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class EventMeta extends StatelessWidget {
  const EventMeta({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 16, color: muted),
      const SizedBox(width: 7),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, color: muted, height: 1.4),
        ),
      ),
    ],
  );
}
