enum MessageReact {
  love,
  like,
  haha,
}

extension MessageReactExtension on MessageReact {
  String get value {
    switch (this) {
      case MessageReact.love:
        return "love";
      case MessageReact.like:
        return "like";
      case MessageReact.haha:
        return "haha";
    }
  }

  static MessageReact fromString(String value) {
    switch (value.toLowerCase()) {
      case "love":
        return MessageReact.love;
      case "like":
        return MessageReact.like;
      case "haha":
        return MessageReact.haha;
      default:
        return MessageReact.like;
    }
  }

  static String getEmojiFromReactWithCount({
    required String react,
    required int count,
  }) {
    String emoji;
    switch (react.toLowerCase()) {
      case 'love':
        emoji = '❤️';
        break;
      case 'like':
        emoji = '👍';
        break;
      case 'haha':
        emoji = '😂';
        break;
      default:
        emoji = '';
    }

    return '$emoji $count';
  }
}

extension MessageReactParser on String {
  MessageReact toMessageReact() {
    return MessageReact.values.firstWhere(
      (e) => e.name.toLowerCase() == toLowerCase(),
      orElse: () => MessageReact.like,
    );
  }
}
