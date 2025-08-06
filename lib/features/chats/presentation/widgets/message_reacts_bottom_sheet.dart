import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/message_reaction_info.dart';
import 'package:whatsapp/features/chats/domain/enums/message_react.dart';

class MessageReactsBottomSheet extends StatelessWidget {
  const MessageReactsBottomSheet({
    super.key,
    required this.reacts,
  });

  final List<MessageReactionInfo> reacts;

  @override
  Widget build(BuildContext context) {
    final reactCounts = <MessageReact, int>{};
    for (var r in reacts) {
      reactCounts[r.messageReact] = (reactCounts[r.messageReact] ?? 0) + 1;
    }

    final tabs = [
      {
        'label': 'All',
        'emoji': '📋',
        'count': reacts.length,
      },
      {
        'label': 'like',
        'emoji': MessageReactExtension.getEmojiFromReact(react: 'like'),
        'count': reactCounts[MessageReact.like] ?? 0,
      },
      {
        'label': 'love',
        'emoji': MessageReactExtension.getEmojiFromReact(react: 'love'),
        'count': reactCounts[MessageReact.love] ?? 0,
      },
      {
        'label': 'haha',
        'emoji': MessageReactExtension.getEmojiFromReact(react: 'haha'),
        'count': reactCounts[MessageReact.haha] ?? 0,
      },
    ];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) => DefaultTabController(
        length: tabs.length,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              height: 5,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),
            TabBar(
              isScrollable: true,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              tabs: tabs.map((tab) {
                return Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          tab['label'] == "All"
                              ? "All"
                              : tab['emoji'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                          )),
                      const SizedBox(width: 4),
                      Text(
                        (tab['count'] as int).toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const VerticalGap(8),
            Flexible(
              child: TabBarView(
                children: tabs.map((tab) {
                  final label = tab['label'] as String;

                  final filteredReacts = label == 'All'
                      ? reacts
                      : reacts
                          .where((r) =>
                              r.messageReact ==
                              MessageReactExtension.fromString(label))
                          .toList();

                  if (filteredReacts.isEmpty) {
                    return const Center(child: Text('No reactions'));
                  }

                  return ListView.separated(
                    controller: scrollController,
                    itemCount: filteredReacts.length,
                    separatorBuilder: (context, index) => const VerticalGap(8),
                    itemBuilder: (context, index) {
                      final reaction = filteredReacts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                BuildUserProfileImage(
                                  circleAvatarRadius: 30,
                                  userEntity: reaction.user,
                                ),
                                Positioned(
                                  bottom: -14,
                                  right: -14,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(360),
                                    ),
                                    child: Text(
                                      MessageReactExtension.getEmojiFromReact(
                                        react: reaction.messageReact.value,
                                      ),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const HorizontalGap(24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const VerticalGap(20),
                                  Text(
                                    reaction.user.name,
                                    style: AppTextStyles.poppinsBold(
                                        context, 18),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const VerticalGap(20),
                                  Visibility(
                                    visible:
                                        index < filteredReacts.length - 1,
                                    child: const Divider(
                                      height: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
