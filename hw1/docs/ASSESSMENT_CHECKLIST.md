# Assignment 1 assessment recheck

Checked against the supplied three-page Campus Event Explorer assignment on **2026-10-24**, using **Flutter 3.47.6 Stable**.

| PDF assessment criterion | Weight | Verification | Result |
| --- | ---: | --- | --- |
| Event data and Explore cards | 15 | Six unique events, three categories, all specified fields, dates after the deadline, full/last-place fixtures, scrollable cards and three bundled images. `data/events.dart`, `models/campus_event.dart`, `widgets/event_card.dart`; fixture test. | Verified |
| Combined search, filters and empty states | 15 | `trim().toLowerCase()` title search combines with All/Technology/Arts/Sports. One query/category pair applies across all views; count, clear controls and empty-state messages are implemented. Filter and widget tests. | Verified |
| Details, navigation and image enlargement | 15 | Separate details route exposes ID, title, category, date/time, venue, description, image and capacity/initial/current availability. Double-tap opens a separate zoomable image route. Normal Back navigation and favorite/participation controls are present. Navigation widget test and native screenshot. | Verified |
| Favorites and consistency across views | 15 | Explore, Favorites and My Events; favorite-only/joined-only lists; shared event instances and setState callbacks. Favoriting is independent of capacity. Cross-screen consistency and empty states checked. | Verified |
| Join/cancel logic, capacity and feedback | 20 | Yes/No confirmation includes title/date/time/venue. No/dismiss does not change data. Duplicate joins are rejected; capacity remains bounded. Full events cannot be joined. Last-seat participant can cancel; exactly one place is restored. Joined total and feedback are visible. Logic and widget tests. | Verified |
| Layout, bundled images and custom font | 10 | MaterialApp, Scaffold, Row/Column/Padding/Expanded, reusable StatelessWidgets and StatefulWidgets, simple setState. Three distinct local PNGs and four Manrope weights declared in pubspec, visibly applied, credited and licensed. Narrow phone widget test and native screenshots. | Verified |
| Source organization, README and evidence | 10 | Organized source folders, both students' names/IDs, team responsibilities, setup/run commands, actual Flutter version output, credits/licenses, limitations, four required screenshots plus three extras, and full-event/cancel-dialog/empty-search checklist. | Verified |

## Project scope and package

- Event data is fictional and stored in Dart. Images and font files are local. The native app has no required online service.
- Favorites and participation are in memory and may reset after restarting, as allowed.
- Source includes `lib/`, `pubspec.yaml`, `pubspec.lock`, assets, Android and web configuration and Gradle wrappers.
- Git and the source ZIP exclude build/cache files and local SDK paths.
- The public repository's `hw1/` link is accessible without authentication.

## Check results

- `flutter --version`: 3.47.6, Stable.
- `flutter test --reporter expanded`: 9 tests passed on 2026-10-24.
- `flutter analyze`: no issues found on 2026-10-24.
- `flutter build apk --release`: successful on 2026-10-24; APK approximately 47.2 MB.
- Native offline launch, favorites/join interaction and screenshots were verified on 2026-10-23.
