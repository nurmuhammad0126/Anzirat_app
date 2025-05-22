class AppModel {
  final String? locationName;
  final bool? isOnline;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double altitude;
  final double speed;
  final double speedAccuracy;
  final double heading;
  final double time;

  AppModel({
    this.locationName,
    this.isOnline,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.altitude,
    required this.speed,
    required this.speedAccuracy,
    required this.heading,
    required this.time,
  });

  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
      locationName: json["locationName"],
      isOnline: json['isOnline'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      accuracy: (json['accuracy'] ?? 0).toDouble(),
      altitude: (json['altitude'] ?? 0).toDouble(),
      speed: (json['speed'] ?? 0).toDouble(),
      speedAccuracy: (json['speedAccuracy'] ?? 0).toDouble(),
      heading: (json['heading'] ?? 0).toDouble(),
      time: (json['time'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'speed': speed,
      'speedAccuracy': speedAccuracy,
      'heading': heading,
      'time': time,
    };
  }

  AppModel copyWith({
    String? locationName,
    double? latitude,
    double? longitude,
    double? accuracy,
    double? altitude,
    double? speed,
    double? speedAccuracy,
    double? heading,
    double? time,
    bool? isOnline,
  }) {
    return AppModel(
      locationName: locationName ?? this.locationName,
      isOnline: isOnline ?? this.isOnline,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      speed: speed ?? this.speed,
      speedAccuracy: speedAccuracy ?? this.speedAccuracy,
      heading: heading ?? this.heading,
      time: time ?? this.time,
    );
  }
}
