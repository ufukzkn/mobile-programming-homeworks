import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home_controller/main.dart';
import 'package:smart_home_controller/smart_device.dart';

void main() {
  test('device objects share a counter and expose type-specific status', () {
    final before = SmartDevice.totalDevices;
    final light = SmartLight.evening('Living room');
    final thermostat = Thermostat('Bedroom');
    final speaker = SmartSpeaker('Kitchen');
    final devices = <SmartDevice>[light, thermostat, speaker];
    for (final Connectable device in devices) {
      device.connect();
    }
    expect(devices.every((device) => device.isConnected), isTrue);
    expect(SmartDevice.totalDevices, before + 3);
    expect(devices.map((device) => device.getStatus()), [
      'On',
      'Heating',
      'Paused',
    ]);
    expect(light.scheduledTime, '19:00');
    light.setBrightness(60);
    light.setPower(false);
    expect(light.getStatus(), 'Off');
    light.setPower(true);
    expect(light.brightness, 60);
    thermostat.adjustTemperature(-2);
    expect(thermostat.getStatus(), 'At target');
    thermostat.adjustTemperature(-20);
    expect(thermostat.temperature, Thermostat.minTemperature);
    expect(thermostat.getStatus(), 'Cooling');
    speaker.togglePlayback();
    expect(speaker.getStatus(), 'Playing');
  });

  testWidgets(
    'three devices respond to controls without creating new devices',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final total = SmartDevice.totalDevices + 3;
      await tester.pumpWidget(const SmartHomeApp());
      final power = find.byKey(const ValueKey('light-power'));
      await tester.tap(power);
      await tester.pumpAndSettle();
      expect(find.text('Off'), findsOneWidget);
      expect(find.text('0%'), findsOneWidget);
      await tester.tap(power);
      await tester.pumpAndSettle();
      expect(find.text('75%'), findsOneWidget);
      final increase = find.byTooltip('Increase temperature');
      await tester.ensureVisible(increase);
      await tester.tap(increase);
      await tester.pumpAndSettle();
      expect(find.text('Target 23°C'), findsOneWidget);
      final play = find.byTooltip('Play speaker');
      await tester.ensureVisible(play);
      await tester.tap(play);
      await tester.pumpAndSettle();
      expect(find.text('Playing'), findsOneWidget);
      expect(find.text('Total created: $total'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'add and remove update the list while preserving the creation total',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final initialTotal = SmartDevice.totalDevices + 3;
      await tester.pumpWidget(const SmartHomeApp());
      await tester.tap(find.text('Add device'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a room name.'), findsOneWidget);
      expect(SmartDevice.totalDevices, initialTotal);

      await tester.tap(find.byKey(const ValueKey('device-type')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Smart Speaker').hitTestable().last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), '  Office  ');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
      expect(find.text('In list: 4'), findsOneWidget);
      expect(find.text('Total created: ${initialTotal + 1}'), findsOneWidget);

      final options = find.byTooltip('Options for Smart Speaker in Office');
      await tester.scrollUntilVisible(
        options,
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await Scrollable.ensureVisible(tester.element(options), alignment: 0.5);
      await tester.pumpAndSettle();
      expect(find.text('Office'), findsOneWidget);
      Future<void> openRemoval() async {
        await tester.tap(options);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Remove device'));
        await tester.pumpAndSettle();
      }

      await openRemoval();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('In list: 4'), findsOneWidget);
      await openRemoval();
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      expect(find.text('Office'), findsNothing);
      expect(find.text('In list: 3'), findsOneWidget);
      expect(find.text('Total created: ${initialTotal + 1}'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
