# Smart Home Controller

BIM493 Mobile Programming I, Assignment 2. The Flutter dashboard starts with three simulated devices: a living-room light, a bedroom thermostat and a kitchen speaker.

- **Smart Light:** toggle power or adjust brightness. Turning the light off preserves its last brightness setting. Its evening preset is shown on the card.
- **Thermostat:** change the target in 1°C steps. The status shows Heating, Cooling or At target based on the simulated room temperature.
- **Smart Speaker:** toggle playback and adjust volume.
- **Device list:** use **Add device** to choose a type and name its room. Use a card's menu to remove it. The footer shows the number currently in the list and the total created during the session.

The dashboard is a local simulation. It does not control physical hardware, play audio, or execute scheduled actions. The device list and settings reset on restart.

## Run

Open `hw2/` as the Flutter project. Tested with Flutter 3.47.6 Stable.

```sh
flutter pub get
flutter run
```

Use a running Android emulator or phone, or select Chrome with `flutter run -d chrome`. The Android project uses NDK `30.0.16248370`; install that version via Android Studio's SDK Manager if needed.

## Dart design

| Concept | Implementation |
| --- | --- |
| Class, object, inheritance | `SmartLight`, `Thermostat` and `SmartSpeaker` extend `SmartDevice`; one instance of each is created in `HomeScreen.initState`. |
| Abstraction and polymorphism | `SmartDevice` declares abstract `getStatus()`. Each subclass overrides it; device cards invoke it through the base type. |
| Constructors | `SmartLight.evening` is a named factory; the dashboard also uses the unnamed `Thermostat` and `SmartSpeaker` constructors. |
| Interface | `SmartDevice` implements the `Connectable` interface, and all three subclasses inherit its implementation. |
| Mixin | `SmartLight` uses `Schedulable` to store the evening preset. |
| Keywords | `this` initializes constructor fields, `super` calls the parent constructor, and the `static` device counter increments for each created object. The footer reads that counter directly. |

Model definitions are in `lib/smart_device.dart`; the dashboard and device controls are in `lib/main.dart`.

## Checks

```sh
flutter analyze
flutter test
```
