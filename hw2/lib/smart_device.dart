abstract interface class Connectable {
  void connect();
}

mixin Schedulable {
  String? scheduledTime;

  void scheduleAt(String time) {
    scheduledTime = time;
  }
}

abstract class SmartDevice implements Connectable {
  SmartDevice(this.name, this.room) {
    totalDevices++;
  }

  static int totalDevices = 0;

  final String name;
  final String room;
  bool isConnected = false;

  @override
  void connect() => isConnected = true;

  String getStatus();
}

class SmartLight extends SmartDevice with Schedulable {
  SmartLight(String room, {this.brightness = 75, this.isOn = true})
    : super('Smart Light', room);

  factory SmartLight.evening(String room) =>
      SmartLight(room)..scheduleAt('19:00');

  int brightness;
  bool isOn;

  void setPower(bool value) => isOn = value;

  void setBrightness(int value) => brightness = value.clamp(0, 100);

  @override
  String getStatus() => isOn ? 'On' : 'Off';
}

class Thermostat extends SmartDevice {
  Thermostat(String room, {this.temperature = 22, this.roomTemperature = 20})
    : super('Thermostat', room);

  static const minTemperature = 16;
  static const maxTemperature = 30;

  int temperature;
  final int roomTemperature;

  void adjustTemperature(int degrees) {
    temperature = (temperature + degrees).clamp(minTemperature, maxTemperature);
  }

  @override
  String getStatus() => temperature > roomTemperature
      ? 'Heating'
      : temperature < roomTemperature
      ? 'Cooling'
      : 'At target';
}

class SmartSpeaker extends SmartDevice {
  SmartSpeaker(String room, {this.volume = 40}) : super('Smart Speaker', room);

  int volume;
  bool isPlaying = false;

  void togglePlayback() => isPlaying = !isPlaying;

  void setVolume(int value) => volume = value.clamp(0, 100);

  @override
  String getStatus() => isPlaying ? 'Playing' : 'Paused';
}
