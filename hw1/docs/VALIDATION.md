# Verification record

Verified on 2026-10-23 (Europe/Istanbul) using Flutter 3.47.6 Stable.

| Check | Result |
| --- | --- |
| `flutter analyze` | No issues found |
| `flutter test` | 9 tests passed |
| `flutter build apk --debug` | Successful |
| `flutter build apk --release` | Successful, approximately 47.2 MB |
| Release APK install | Successful on Medium Phone API 37.0, emulator-5554 |
| Offline native launch | Successful with emulator Wi-Fi and mobile data disabled |
| Offline interactions | Save favorite, confirm join, Favorites and My Events all worked |
| Network cleanup | Emulator Wi-Fi and mobile data restored to their previous enabled state |
| `flutter build web --no-web-resources-cdn` | Successful |
| Chrome preview | 430x932 and 1280x900 viewport checks; no browser console errors |
| Native image viewer | Double-tap opened a separate viewer with Back navigation |

The actual native screenshots are in `docs/screenshots/`.

The five logic tests cover fixture requirements, capacity/duplicate joins, full events and independent favorites, combined filtering across all views, and session reset. The four widget tests cover cross-screen favorites/shared filters, dialog Yes/No/dismiss plus last-seat cancellation, full-event disabling plus enlarged-image navigation, and empty search plus a narrow 360x800 layout.

The Android build pins installed NDK 30.0.16248370 because the new Android SDK CLI did not auto-install the template's older NDK. No application dependency was added to work around it.


## 2026-10-24 assessment recheck

- Flutter remains 3.47.6 Stable.
- All 9 tests passed again; analysis reported no issues.
- Android release APK rebuilt successfully from the repository's `hw1/` directory (approximately 47.2 MB).
- README links, local images/fonts/license and all 7 screenshot files checked.
- Public source link checked without GitHub authentication.
