import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    required super.timestamp,
    super.isRead = false,
    super.payload,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: _parseNotificationType(json['type'] as String?),
      timestamp: _parseDateTime(json['timestamp']),
      isRead: json['isRead'] as bool? ?? false,
      payload: json['payload'] is Map<String, dynamic>
          ? json['payload'] as Map<String, dynamic>
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'payload': payload,
    };
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      type: entity.type,
      timestamp: entity.timestamp,
      isRead: entity.isRead,
      payload: entity.payload,
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      type: type,
      timestamp: timestamp,
      isRead: isRead,
      payload: payload,
    );
  }

  static NotificationType _parseNotificationType(String? typeStr) {
    if (typeStr == null) return NotificationType.system;
    switch (typeStr.toLowerCase()) {
      case 'transaction':
        return NotificationType.transaction;
      case 'bill':
        return NotificationType.bill;
      case 'security':
        return NotificationType.security;
      case 'promo':
        return NotificationType.promo;
      case 'system':
      default:
        return NotificationType.system;
    }
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    } else if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return DateTime.now();
  }
}
