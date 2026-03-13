class CheckInModel {
  CheckInModel({
    required this.studentName,
    required this.studentId,
    required this.timestamp,
    required this.previousTopic,
    required this.expectedTopic,
    required this.mood,
    this.latitude,
    this.longitude,
    this.qrCode,
  });

  final String studentName;
  final String studentId;
  final DateTime timestamp;
  final String previousTopic;
  final String expectedTopic;
  final int mood;
  final double? latitude;
  final double? longitude;
  final String? qrCode;

  Map<String, dynamic> toMap() {
    return {
      'studentName': studentName,
      'studentId': studentId,
      'timestamp': timestamp.toIso8601String(),
      'previousTopic': previousTopic,
      'expectedTopic': expectedTopic,
      'mood': mood,
      'latitude': latitude,
      'longitude': longitude,
      'qrCode': qrCode,
    };
  }

  factory CheckInModel.fromMap(Map<String, dynamic> map) {
    return CheckInModel(
      studentName: map['studentName'] as String? ?? '',
      studentId: map['studentId'] as String? ?? '',
      timestamp: _parseTimestamp(map['timestamp']),
      previousTopic: map['previousTopic'] as String? ?? '',
      expectedTopic: map['expectedTopic'] as String? ?? '',
      mood: (map['mood'] as num?)?.toInt() ?? 3,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      qrCode: map['qrCode'] as String?,
    );
  }
}

class FinishClassModel {
  FinishClassModel({
    required this.timestamp,
    required this.learnedToday,
    required this.feedback,
    this.latitude,
    this.longitude,
    this.qrCode,
  });

  final DateTime timestamp;
  final String learnedToday;
  final String feedback;
  final double? latitude;
  final double? longitude;
  final String? qrCode;

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'learnedToday': learnedToday,
      'feedback': feedback,
      'latitude': latitude,
      'longitude': longitude,
      'qrCode': qrCode,
    };
  }

  factory FinishClassModel.fromMap(Map<String, dynamic> map) {
    return FinishClassModel(
      timestamp: _parseTimestamp(map['timestamp']),
      learnedToday: map['learnedToday'] as String? ?? '',
      feedback: map['feedback'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      qrCode: map['qrCode'] as String?,
    );
  }
}

DateTime _parseTimestamp(dynamic raw) {
  if (raw is DateTime) {
    return raw;
  }

  if (raw is String) {
    return DateTime.tryParse(raw) ?? DateTime.now();
  }

  return DateTime.now();
}
