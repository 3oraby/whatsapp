abstract class PendingMessagesHelper {
  Future<void> addPendingMessage(Map<String, dynamic> message);
  Future<List<Map<String, dynamic>>> getPendingMessages();
  Future<void> removePendingMessage(Map<String, dynamic> message);
  Future<void> clear();
}
