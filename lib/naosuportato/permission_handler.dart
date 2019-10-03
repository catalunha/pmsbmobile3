class PermissionHandler {
  factory PermissionHandler() {
    return PermissionHandler.private();
  }

  PermissionHandler.private();

  Future<dynamic> checkPermissionStatus(dynamic permission) async {}

  Future<dynamic> checkServiceStatus(dynamic permission) async {}

  Future<dynamic> openAppSettings() async {}

  Future<dynamic> requestPermissions(List<dynamic> permissions) async {}

  Future<dynamic> shouldShowRequestPermissionRationale(
      dynamic permission) async {}
}

class PermissionStatus {
  const PermissionStatus._(this.value);

  final int value;
  static const PermissionStatus denied = PermissionStatus._(0);
  static const PermissionStatus disabled = PermissionStatus._(1);
  static const PermissionStatus granted = PermissionStatus._(2);
  static const PermissionStatus restricted = PermissionStatus._(3);
  static const PermissionStatus unknown = PermissionStatus._(4);
  static const List<PermissionStatus> values = <PermissionStatus>[
    denied,
    disabled,
    granted,
    restricted,
    unknown,
  ];

  static const List<String> _names = <String>[
    'denied',
    'disabled',
    'granted',
    'restricted',
    'unknown',
  ];

  @override
  String toString() => 'PermissionStatus.${_names[value]}';
}

class PermissionGroup {
  const PermissionGroup._(this.value);

  final int value;
  static const PermissionGroup calendar = PermissionGroup._(0);
  static const PermissionGroup camera = PermissionGroup._(1);
  static const PermissionGroup contacts = PermissionGroup._(2);
  static const PermissionGroup location = PermissionGroup._(3);
  static const PermissionGroup locationAlways = PermissionGroup._(4);
  static const PermissionGroup locationWhenInUse = PermissionGroup._(5);
  static const PermissionGroup mediaLibrary = PermissionGroup._(6);
  static const PermissionGroup microphone = PermissionGroup._(7);
  static const PermissionGroup phone = PermissionGroup._(8);
  static const PermissionGroup photos = PermissionGroup._(9);
  static const PermissionGroup reminders = PermissionGroup._(10);
  static const PermissionGroup sensors = PermissionGroup._(11);
  static const PermissionGroup sms = PermissionGroup._(12);
  static const PermissionGroup speech = PermissionGroup._(13);
  static const PermissionGroup storage = PermissionGroup._(14);
  static const PermissionGroup ignoreBatteryOptimizations =
      PermissionGroup._(15);
  static const PermissionGroup unknown = PermissionGroup._(16);

  static const List<PermissionGroup> values = <PermissionGroup>[
    calendar,
    camera,
    contacts,
    location,
    locationAlways,
    locationWhenInUse,
    mediaLibrary,
    microphone,
    phone,
    photos,
    reminders,
    sensors,
    sms,
    speech,
    storage,
    ignoreBatteryOptimizations,
    unknown,
  ];

  static const List<String> _names = <String>[
    'calendar',
    'camera',
    'contacts',
    'location',
    'locationAlways',
    'locationWhenInUse',
    'mediaLibrary',
    'microphone',
    'phone',
    'photos',
    'reminders',
    'sensors',
    'sms',
    'speech',
    'storage',
    'ignoreBatteryOptimizations',
    'unknown',
  ];

  @override
  String toString() => 'PermissionGroup.${_names[value]}';
}
