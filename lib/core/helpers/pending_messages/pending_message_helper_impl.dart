import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/helpers/pending_messages/pending_message_helper.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';

class PendingMessagesHelperImpl implements PendingMessagesHelper {
  static String key = StorageKeys.pendingMessages.toString();

  @override
  Future<void> addPendingMessage(Map<String, dynamic> message) async {
    debugPrint('📥 Adding pending message: $message');
    final list = AppStorageHelper.getString(key);
    final List<Map<String, dynamic>> messages =
        list != null ? List<Map<String, dynamic>>.from(jsonDecode(list)) : [];
    messages.add(message);
    await AppStorageHelper.setString(key, jsonEncode(messages));
    debugPrint('✅ Message added. Total pending: ${messages.length}');
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingMessages() async {
    final list = AppStorageHelper.getString(key);
    if (list == null) {
      debugPrint('📭 No pending messages found.');
      return [];
    }
    final decoded = List<Map<String, dynamic>>.from(jsonDecode(list));
    debugPrint('📦 Retrieved ${decoded.length} pending messages. : $decoded');
    return decoded;
  }

  @override
  Future<void> removePendingMessage(Map<String, dynamic> message) async {
    debugPrint('🗑 Attempting to remove pending message: $message');
    final messages = await getPendingMessages();
    final initialLength = messages.length;
    messages.removeWhere((m) => mapEquals(m, message));
    await AppStorageHelper.setString(key, jsonEncode(messages));
    debugPrint(
        '✅ Message removed. Before: $initialLength, After: ${messages.length}');
  }

  @override
  Future<void> clear() async {
    debugPrint('🧹 Clearing all pending messages.');
    await AppStorageHelper.remove(key);
    debugPrint('✅ Pending messages cleared.');
  }
}
