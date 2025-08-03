import 'package:whatsapp/features/chats/domain/entities/message_reaction_info.dart';

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

  static MessageReact fromEmoji(String emoji) {
    switch (emoji) {
      case '❤️':
        return MessageReact.love;
      case '👍':
        return MessageReact.like;
      case '😂':
        return MessageReact.haha;
      default:
        return MessageReact.like;
    }
  }

  static String getEmojiFromReactWithCount({
    required List<MessageReactionInfo> reacts,
  }) {
    final Map<MessageReact, int> reactCounts = {};

    for (var react in reacts) {
      reactCounts[react.messageReact] =
          (reactCounts[react.messageReact] ?? 0) + 1;
    }

    final priority = {
      MessageReact.like: 1,
      MessageReact.love: 2,
      MessageReact.haha: 3,
    };

    final emojiMap = {
      MessageReact.like: '👍',
      MessageReact.love: '❤️',
      MessageReact.haha: '😂',
    };

    final sortedReacts = reactCounts.entries.toList()
      ..sort((a, b) {
        final countCompare = b.value.compareTo(a.value);
        if (countCompare != 0) return countCompare;

        return priority[a.key]!.compareTo(priority[b.key]!);
      });

    return sortedReacts
        .map((entry) => '${emojiMap[entry.key]} ${entry.value}')
        .join(' ');
  }

  static String getEmojiFromReact({
    required String react,
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

    return emoji;
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
