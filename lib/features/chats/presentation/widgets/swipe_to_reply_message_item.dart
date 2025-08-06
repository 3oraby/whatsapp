import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_overlay_menu/smart_overlay_menu.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_status.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';
import 'package:whatsapp/features/chats/presentation/widgets/custom_bubble_message_item.dart';
import 'package:whatsapp/features/chats/presentation/widgets/message_interaction_menu.dart';
import 'package:whatsapp/features/chats/presentation/widgets/message_reaction_overlay_menu.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class SwipeToReplyMessageItem extends StatefulWidget {
  final MessageEntity msg;
  final bool isFromMe;
  final bool showClipper;
  final void Function(MessageEntity msg) onReply;
  final MessageEntity? repliedMsg;
  final UserEntity currentUser;

  const SwipeToReplyMessageItem({
    super.key,
    required this.msg,
    required this.isFromMe,
    required this.showClipper,
    required this.onReply,
    required this.currentUser,
    this.repliedMsg,
  });

  @override
  State<SwipeToReplyMessageItem> createState() =>
      _SwipeToReplyMessageItemState();
}

class _SwipeToReplyMessageItemState extends State<SwipeToReplyMessageItem> {
  double _dragOffset = 0.0;
  final double maxOffset = 80;
  final double triggerOffset = 60;
  bool _isDragging = false;

  final SmartOverlayMenuController smartOverlayMenuController =
      SmartOverlayMenuController();

  late MessageStreamCubit messageStreamCubit;

  @override
  void initState() {
    super.initState();
    messageStreamCubit = BlocProvider.of<MessageStreamCubit>(context);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;

      if (_dragOffset < 0) _dragOffset = 0;
      if (_dragOffset > maxOffset) _dragOffset = maxOffset;

      _isDragging = _dragOffset > 5;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    log("Drag ended with offset: $_dragOffset");

    if (_dragOffset >= triggerOffset) {
      log("Trigger reply on message: ${widget.msg.id}");
      widget.onReply(widget.msg);
    }

    setState(() {
      _dragOffset = 0;
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool canUseMessageOptions =
        !widget.msg.isDeleted && widget.msg.status != MessageStatus.pending;

    return SmartOverlayMenu(
      key: ValueKey(widget.msg.id),
      controller: smartOverlayMenuController,
      scaleDownWhenTooLarge: true,
      disabled: !canUseMessageOptions,
      bottomWidgetPadding: EdgeInsets.all(12),
      topWidgetAlignment:
          widget.isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      bottomWidgetAlignment:
          widget.isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      topWidget: MessageReactionOverlayMenu(
        currentUser: widget.currentUser,
        msg: widget.msg,
        onReactTap: (reactType, isCreate) {
          messageStreamCubit.emitMessageReaction(
            messageId: widget.msg.id,
            reactType: reactType,
            isCreate: isCreate,
          );

          smartOverlayMenuController.close();
        },
      ),
      bottomWidget: MessageInteractionMenu(
        messageStreamCubit: messageStreamCubit,
        message: widget.msg,
        onReply: () {
          widget.onReply(widget.msg);
        },
      ),
      child: GestureDetector(
        onHorizontalDragUpdate: !canUseMessageOptions ? null : _handleDragUpdate,
        onHorizontalDragEnd: !canUseMessageOptions ? null : _handleDragEnd,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              opacity: _isDragging ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Icon(
                    Icons.reply,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(_dragOffset, 0),
              child: CustomBubbleMessageItem(
                isFromMe: widget.isFromMe,
                msg: widget.msg,
                showClipper: widget.showClipper,
                repliedMsg: widget.repliedMsg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
