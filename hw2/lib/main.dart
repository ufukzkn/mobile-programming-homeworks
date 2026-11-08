import 'package:flutter/material.dart';

import 'smart_device.dart';

void main() => runApp(const SmartHomeApp());

const _ink = Color(0xFF17283B);
const _muted = Color(0xFF536679);
const _accent = Color(0xFF006C61);
const _border = Color(0xFFDEE7EC);
const _canvas = Color(0xFFF3F7FA);

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Smart Home Controller',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: _accent),
      scaffoldBackgroundColor: _canvas,
      sliderTheme: const SliderThemeData(trackHeight: 4),
    ),
    home: const HomeScreen(),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<SmartDevice> _devices;

  @override
  void initState() {
    super.initState();
    _devices = [
      SmartLight.evening('Living room'),
      Thermostat('Bedroom'),
      SmartSpeaker('Kitchen'),
    ];
    for (final device in _devices) {
      device.connect();
    }
  }

  Future<void> _addDevice() async {
    final selection = await showDialog<(_DeviceType, String)>(
      context: context,
      builder: (_) => const _AddDeviceDialog(),
    );
    if (!mounted || selection == null) return;
    final (type, room) = selection;
    final device = type.create(room)..connect();
    setState(() => _devices.add(device));
  }

  Future<void> _removeDevice(SmartDevice device) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove device?'),
        content: Text('Remove ${device.name} from ${device.room}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (mounted && confirmed == true) {
      setState(() => _devices.remove(device));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: [
              const _DashboardHeader(),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Your devices',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonalIcon(
                    onPressed: _addDevice,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add device'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_devices.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 28),
                  child: Text(
                    'No devices yet. Add a device to get started.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted),
                  ),
                ),
              for (final device in _devices) ...[
                Padding(
                  key: ObjectKey(device),
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildDeviceCard(device),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
    bottomNavigationBar: DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 4,
            children: [
              const Icon(Icons.devices_other_rounded, size: 18, color: _accent),
            
              Text(
                'Total Devices: ${_devices.length}',
                style: const TextStyle(color: _muted),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildDeviceCard(SmartDevice device) => switch (device) {
    SmartLight light => _DeviceCard(
      device: light,
      onRemove: () => _removeDevice(light),
      icon: Icons.lightbulb_outline_rounded,
      tint: const Color(0xFFFFF1D6),
      iconColor: const Color(0xFF875300),
      active: light.isOn,
      action: Switch(
        key: const ValueKey('light-power'),
        value: light.isOn,
        onChanged: (on) => setState(() => light.setPower(on)),
        thumbIcon: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? const Icon(Icons.check_rounded)
              : null,
        ),
      ),
      content: Column(
        children: [
          _ValueSlider(
            label: 'Brightness',
            value: light.isOn ? light.brightness : 0,
            onChanged: light.isOn
                ? (value) => setState(() => light.setBrightness(value))
                : null,
          ),
          if (light.scheduledTime case final time?)
            Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 14, color: _muted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Evening preset · $time',
                    style: const TextStyle(fontSize: 11, color: _muted),
                  ),
                ),
              ],
            ),
        ],
      ),
    ),
    Thermostat thermostat => _DeviceCard(
      device: thermostat,
      onRemove: () => _removeDevice(thermostat),
      icon: Icons.thermostat_rounded,
      tint: const Color(0xFFFCE8E1),
      iconColor: const Color(0xFFA63B2A),
      active: thermostat.temperature != thermostat.roomTemperature,
      content: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Target ${thermostat.temperature}°C',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _ink,
                  ),
                ),
                Text(
                  'Room ${thermostat.roomTemperature}°C',
                  style: const TextStyle(fontSize: 12, color: _muted),
                ),
              ],
            ),
          ),
          IconButton.outlined(
            tooltip: 'Decrease temperature',
            onPressed: thermostat.temperature > Thermostat.minTemperature
                ? () => setState(() => thermostat.adjustTemperature(-1))
                : null,
            icon: const Icon(Icons.remove_rounded),
          ),
          const SizedBox(width: 6),
          IconButton.outlined(
            tooltip: 'Increase temperature',
            onPressed: thermostat.temperature < Thermostat.maxTemperature
                ? () => setState(() => thermostat.adjustTemperature(1))
                : null,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    ),
    SmartSpeaker speaker => _DeviceCard(
      device: speaker,
      onRemove: () => _removeDevice(speaker),
      icon: Icons.speaker_outlined,
      tint: const Color(0xFFE8EAFE),
      iconColor: const Color(0xFF454A9E),
      active: speaker.isPlaying,
      action: IconButton.filledTonal(
        tooltip: speaker.isPlaying ? 'Pause speaker' : 'Play speaker',
        onPressed: () => setState(speaker.togglePlayback),
        icon: Icon(
          speaker.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        ),
      ),
      content: _ValueSlider(
        label: 'Volume',
        value: speaker.volume,
        onChanged: (value) => setState(() => speaker.setVolume(value)),
      ),
    ),
    _ => throw StateError('Unsupported device: ${device.name}'),
  };
}

enum _DeviceType {
  light('Smart Light'),
  thermostat('Thermostat'),
  speaker('Smart Speaker');

  const _DeviceType(this.label);
  final String label;

  SmartDevice create(String room) => switch (this) {
    light => SmartLight(room),
    thermostat => Thermostat(room),
    speaker => SmartSpeaker(room),
  };
}

class _AddDeviceDialog extends StatefulWidget {
  const _AddDeviceDialog();

  @override
  State<_AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<_AddDeviceDialog> {
  final _formKey = GlobalKey<FormState>();
  _DeviceType _type = _DeviceType.light;
  String _room = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, (_type, _room.trim()));
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    title: const Text('Add device'),
    content: SizedBox(
      width: 320,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<_DeviceType>(
              key: const ValueKey('device-type'),
              initialValue: _type,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Device type'),
              items: [
                for (final type in _DeviceType.values)
                  DropdownMenuItem(value: type, child: Text(type.label)),
              ],
              onChanged: (type) {
                if (type != null) setState(() => _type = type);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Room name',
                hintText: 'e.g. Office',
              ),
              maxLength: 30,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              validator: (value) =>
                  (value ?? '').trim().isEmpty ? 'Enter a room name.' : null,
              onChanged: (value) => _room = value,
              onFieldSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(onPressed: _submit, child: const Text('Add')),
    ],
  );
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      gradient: const LinearGradient(
        colors: [Color(0xFF142B40), Color(0xFF214B59)],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.home_outlined, color: Color(0xFFA9EBDD), size: 19),
            SizedBox(width: 8),
            Text(
              'HOME CONTROL',
              style: TextStyle(
                color: Color(0xFFA9EBDD),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Smart Home\nController',
          style: TextStyle(
            color: Colors.white,
            fontSize: 31,
            height: 1.06,
            letterSpacing: -.8,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Lights, climate and sound in one place.',
          style: TextStyle(color: Color(0xFFD4E4EC), fontSize: 12),
        ),
      ],
    ),
  );
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({
    required this.device,
    required this.onRemove,
    required this.icon,
    required this.tint,
    required this.iconColor,
    required this.active,
    required this.content,
    this.action,
  });

  final SmartDevice device;
  final VoidCallback onRemove;
  final IconData icon;
  final Color tint, iconColor;
  final bool active;
  final Widget content;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(15, 13, 15, 12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _border),
      borderRadius: BorderRadius.circular(19),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: iconColor, size: 23),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: _ink,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Wrap(
                    spacing: 7,
                    runSpacing: 3,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        device.room,
                        style: const TextStyle(fontSize: 12, color: _muted),
                      ),
                      _StatusBadge(
                        label: device.isConnected
                            ? device.getStatus()
                            : 'Offline',
                        active: active && device.isConnected,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (action case final control?) ...[
              const SizedBox(width: 6),
              control,
            ],
            PopupMenuButton<bool>(
              tooltip: 'Options for ${device.name} in ${device.room}',
              onSelected: (_) => onRemove(),
              itemBuilder: (_) => const [
                PopupMenuItem(value: true, child: Text('Remove device')),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, color: _border),
        const SizedBox(height: 7),
        content,
      ],
    ),
  );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: active ? const Color(0xFFDDF4EB) : const Color(0xFFEFF3F5),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: active ? _accent : _muted,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _ValueSlider extends StatelessWidget {
  const _ValueSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        label,
        style: const TextStyle(
          color: _muted,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      Expanded(
        child: Semantics(
          label: label,
          child: Slider(
            value: value.toDouble(),
            max: 100,
            divisions: 20,
            label: '$value%',
            onChanged: onChanged == null ? null : (v) => onChanged!(v.round()),
          ),
        ),
      ),
      SizedBox(
        width: 37,
        child: Text(
          '$value%',
          textAlign: TextAlign.end,
          style: const TextStyle(
            color: _ink,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ],
  );
}
