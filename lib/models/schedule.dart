class Schedule {
  String? id;
  String type;
  String? userId;
  DateTime time;
  bool isActive;

  Schedule({
    this.id,
    required this.type,
    this.userId,
    required this.time,
    required this.isActive,
  });

  static Schedule empty() => Schedule(
        id: "",
        type: "",
        userId: "",
        time: DateTime.now(),
        isActive: true,
      );

  Schedule copyWith({
    String? id,
    String? type,
    String? userId,
    DateTime? time,
    bool? isActive,
  }) {
    return Schedule(
      id: id ?? this.id,
      type: type ?? this.type,
      userId: type ?? this.userId,
      time: time ?? this.time,
      isActive: isActive ?? this.isActive,
    );
  }

  factory Schedule.fromMap(Map<String, dynamic> data, String docId) {
    if (data.isNotEmpty) {
      final String id = docId;
      final DateTime time = data['time'].toDate();
      final String type = data['type'];
      final String userId = data['userId'];
      final bool isActive = data['isActive'];

      return Schedule(
        id: id,
        type: type,
        userId: userId,
        time: time,
        isActive: isActive,
      );
    } else {
      return empty();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'time': time,
      'type': type,
      'isActive': isActive,
    };
  }
}
