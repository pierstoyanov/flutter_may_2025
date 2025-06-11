import 'dart:convert';

class EventItem {
  final String id;
  String title;
  String description;
  DateTime startTime;
  DateTime endTime;
  String createdBy;
  String? color;
  DateTime createdAt;

  EventItem({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.createdBy,
    required this.createdAt,
    this.color
  });

  // Convert EventItem to a Map for Firestore/JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'color': color
    };
  }

  // Create EventItem from a Map
  factory EventItem.fromMap(Map<String, dynamic> map) {
    return EventItem(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: DateTime.parse(map['endTime'] as String),
      createdBy: map['createdBy'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String), 
      color: map['color'] as String?
    );
  }

  String toJson() => json.encode(toMap());

  factory EventItem.fromJson(String source) => EventItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EventItem(id: $id, title: $title, description: $description, startTime: $startTime, endTime: $endTime, createdBy: $createdBy, color: $color, createdAt: $createdAt)';
  }
}