import 'package:flutter/material.dart';

import '../data/events.dart';
import '../models/campus_event.dart';
import '../theme.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _events = createEvents();
  final _searchController = TextEditingController();
  EventView _view = EventView.explore;
  EventCategory? _category;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _favorite(CampusEvent event) =>
      setState(() => event.isFavorite = !event.isFavorite);
  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _category = null;
    });
  }

  Future<void> _open(CampusEvent event) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EventDetailsScreen(
          event: event,
          onFavorite: () => _favorite(event),
          onParticipation: () => setState(() {
            if (event.isJoined) {
              event.cancelParticipation();
            } else {
              event.join();
            }
          }),
        ),
      ),
    );
    // Both routes reference the same event objects. Refresh on return.
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final results = filterEvents(
      _events,
      view: _view,
      query: _query,
      category: _category,
    );
    final joinedCount = _events.where((event) => event.isJoined).length;
    final favoritesCount = _events.where((event) => event.isFavorite).length;
    final title = switch (_view) {
      EventView.explore => 'Find your next\ngood moment.',
      EventView.favorites => 'Good things,\nsaved for later.',
      EventView.joined => 'Your plans.\nYour people.',
    };
    final subtitle = switch (_view) {
      EventView.explore => 'A little curiosity. A lot happening on campus.',
      EventView.favorites => 'The events that caught your eye.',
      EventView.joined => 'Make some room for moments that matter.',
    };
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          key: ValueKey('list-${_view.name}'),
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: forest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.spa_outlined,
                                color: lime,
                                size: 23,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'campus',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1.3,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: line),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.place_outlined,
                                    size: 13,
                                    color: forest,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'ESTÜ',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 29),
                        Row(
                          children: [
                            Container(width: 18, height: 2, color: forest),
                            const SizedBox(width: 8),
                            const Text(
                              'THE CAMPUS EDIT · AUTUMN 2026',
                              style: TextStyle(
                                color: forest,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 13),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 38,
                            height: 1.12,
                            letterSpacing: -1.8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: muted,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 23),
                        if (_view == EventView.explore) ...[
                          Container(
                            padding: const EdgeInsets.all(17),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF0E0),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.auto_awesome_outlined,
                                  color: forest,
                                  size: 25,
                                ),
                                SizedBox(width: 13),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'More than a timetable.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Learn something. Meet someone. Show up.',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: forest,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.north_east_rounded,
                                  color: forest,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 21),
                        ],
                        TextField(
                          key: const ValueKey('event-search'),
                          controller: _searchController,
                          onChanged: (value) => setState(() => _query = value),
                          decoration: InputDecoration(
                            hintText: 'Search events by title',
                            hintStyle: const TextStyle(
                              fontSize: 12,
                              color: muted,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              size: 21,
                              color: muted,
                            ),
                            suffixIcon: _query.isEmpty
                                ? null
                                : IconButton(
                                    key: const ValueKey('clear-search'),
                                    tooltip: 'Clear search',
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 19,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _query = '');
                                    },
                                  ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: line),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: forest,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 13),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _filterChip('All', null),
                              for (final category in EventCategory.values)
                                _filterChip(category.label, category),
                            ],
                          ),
                        ),
                        const SizedBox(height: 23),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                switch (_view) {
                                  EventView.explore => 'Around campus',
                                  EventView.favorites => 'Your favorites',
                                  EventView.joined => 'Your upcoming events',
                                },
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -.5,
                                ),
                              ),
                            ),
                            Text(
                              '${results.length} ${results.length == 1 ? 'event' : 'events'}',
                              key: const ValueKey('result-count'),
                              style: const TextStyle(
                                fontSize: 11,
                                color: muted,
                              ),
                            ),
                          ],
                        ),
                        if (_view == EventView.joined) ...[
                          const SizedBox(height: 5),
                          Text(
                            '$joinedCount joined in total · search and filters apply here too',
                            key: const ValueKey('joined-total'),
                            style: const TextStyle(fontSize: 11, color: forest),
                          ),
                        ],
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (results.isEmpty)
              SliverToBoxAdapter(child: _emptyState())
            else
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final columns = constraints.maxWidth >= 900
                              ? 3
                              : constraints.maxWidth >= 620
                              ? 2
                              : 1;
                          final width =
                              (constraints.maxWidth - 20 * (columns - 1)) /
                              columns;
                          return Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: [
                              for (final event in results)
                                SizedBox(
                                  width: width,
                                  child: EventCard(
                                    event: event,
                                    onFavorite: () => _favorite(event),
                                    onOpen: () => _open(event),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Text(
                  'A LITTLE CURIOSITY GOES A LONG WAY.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8,
                    letterSpacing: 1.8,
                    color: muted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: line)),
        ),
        child: NavigationBar(
          height: 73,
          backgroundColor: paper,
          indicatorColor: const Color(0xFFE3EDCF),
          selectedIndex: _view.index,
          onDestinationSelected: (index) =>
              setState(() => _view = EventView.values[index]),
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_rounded),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite_border_rounded),
              selectedIcon: const Icon(Icons.favorite_rounded),
              label: favoritesCount == 0
                  ? 'Favorites'
                  : 'Favorites ($favoritesCount)',
            ),
            NavigationDestination(
              icon: const Icon(Icons.confirmation_number_outlined),
              selectedIcon: const Icon(Icons.confirmation_number_rounded),
              label: 'My Events ($joinedCount)',
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, EventCategory? category) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ChoiceChip(
      key: ValueKey('filter-$label'),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _category == category ? Colors.white : muted,
        ),
      ),
      selected: _category == category,
      showCheckmark: false,
      selectedColor: forest,
      backgroundColor: paper,
      side: BorderSide(color: _category == category ? forest : line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onSelected: (_) => setState(() => _category = category),
    ),
  );

  Widget _emptyState() {
    final filtered = _query.trim().isNotEmpty || _category != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 50),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              color: Color(0xFFEAF0E0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              filtered
                  ? Icons.search_off_rounded
                  : _view == EventView.favorites
                  ? Icons.favorite_border_rounded
                  : Icons.confirmation_number_outlined,
              size: 34,
              color: forest,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            filtered
                ? 'No events found'
                : _view == EventView.favorites
                ? 'Your next favorite is out there.'
                : 'Your calendar has room.',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 9),
          Text(
            filtered
                ? 'Try a different title or clear your filters.'
                : _view == EventView.favorites
                ? 'Tap a heart on an event to keep it here.'
                : 'Find an event you like and join the moment.',
            style: const TextStyle(color: muted, fontSize: 12, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            key: const ValueKey('empty-action'),
            onPressed: filtered
                ? _clearFilters
                : () => setState(() => _view = EventView.explore),
            child: Text(filtered ? 'Clear search & filters' : 'Explore events'),
          ),
        ],
      ),
    );
  }
}
