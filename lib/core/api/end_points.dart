import 'package:whatsapp/core/api/api_urls.dart';

class EndPoints {
  // Auth
  static const String login = "${ApiUrls.userApiBaseUrl}/auth/login";
  static const String signup = "${ApiUrls.userApiBaseUrl}/auth/signup";
  static const String verifyOTP = "${ApiUrls.userApiBaseUrl}/auth/verifyOTP";
  static const String resendOTP = "${ApiUrls.userApiBaseUrl}/auth/resendOTP";
  static const String refreshToken = "${ApiUrls.userApiBaseUrl}/auth/refreshToken";

  // User
  static const String getUser = "${ApiUrls.userApiBaseUrl}/user";
  static const String updateUser = "${ApiUrls.userApiBaseUrl}/user";
  static const String uploadProfileImage = "${ApiUrls.userApiBaseUrl}/user/image";
  static const String deleteProfileImage = "${ApiUrls.userApiBaseUrl}/user/image";
  static const String saveFcmToken = "${ApiUrls.userApiBaseUrl}/user/api/register-fcm-token";
  static const String searchInUsers = "${ApiUrls.userApiBaseUrl}/user/search";
  static String getUserCurrentStatus({required int userId}) =>
      "${ApiUrls.userApiBaseUrl}/user/currentStatus/$userId";

  // Contacts
  static const String getUserContacts = "${ApiUrls.userApiBaseUrl}/contact";
  static const String createContact = "${ApiUrls.userApiBaseUrl}/contact";

  // Stories
  static const String createStory = "${ApiUrls.userApiBaseUrl}/status";
  static const String getCurrentUserStory = "${ApiUrls.userApiBaseUrl}/status";
  static const String getUserContactsStory =
      "${ApiUrls.userApiBaseUrl}/status/getUserCotactsStatus";
  static String viewStory({required int storyId}) =>
      "${ApiUrls.userApiBaseUrl}/status/view/$storyId";
  static String deleteStory({required int storyId}) =>
      "${ApiUrls.userApiBaseUrl}/status/$storyId";
  static String reactStory({required int storyId}) =>
      "${ApiUrls.userApiBaseUrl}/status/react/$storyId";
  static String getReactsOnStory({required String storyId}) =>
      "${ApiUrls.userApiBaseUrl}/status/reacts/$storyId";
  static String getViewsOnStory({required String storyId}) =>
      "${ApiUrls.userApiBaseUrl}/status/views/$storyId";

  // Chats
  static const String createChat = "${ApiUrls.chatApiBaseUrl}/chat";
  static const String getUserChats = "${ApiUrls.chatApiBaseUrl}/chat";
  static const String uploadChatImage = "${ApiUrls.chatApiBaseUrl}/chat/uploadChatImage";
  static String pinChat({required int chatId}) =>
      "${ApiUrls.chatApiBaseUrl}/chat/pin/$chatId";
  static String unPinChat({required int chatId}) =>
      "${ApiUrls.chatApiBaseUrl}/chat/unPin/$chatId";
  static String getChatMessages({required int chatId}) =>
      "${ApiUrls.chatApiBaseUrl}/chat/messages/$chatId";
  static String getMessageHistory({required int messageId}) =>
      "${ApiUrls.chatApiBaseUrl}/chat/message/$messageId/history";
  static String getMessageReacts({required int messageId}) =>
      "${ApiUrls.chatApiBaseUrl}/chat/message/$messageId/reacts";
}
