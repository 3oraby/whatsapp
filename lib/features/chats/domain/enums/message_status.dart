enum MessageStatus {
  pending,
  sent,
  delivered,
  read,
}

extension MessageStatusExtension on MessageStatus {
  String get value {
    switch (this) {
      case MessageStatus.pending:
        return "pending";
      case MessageStatus.sent:
        return "sent";
      case MessageStatus.delivered:
        return "deliverd";
      case MessageStatus.read:
        return "read";
    }
  }

  static MessageStatus fromString(String value) {
    switch (value) {
      case "pending":
        return MessageStatus.pending;
      case "sent":
        return MessageStatus.sent;
      case "deliverd":
        return MessageStatus.delivered;
      case "read":
        return MessageStatus.read;
      default:
        return MessageStatus.sent;
    }
  }
}

extension MessageStatusParser on String {
  MessageStatus toMessageStatus() {
    return MessageStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == toLowerCase(),
      orElse: () => MessageStatus.pending,
    );
  }
}
