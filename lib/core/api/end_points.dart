class EndPoints {
  static const String baseUrl = "http://10.0.2.2:5000/api/";
  static const String webSocketUrl = "http://10.0.2.2:3000/api/";

  // auth
  static const String login = "${baseUrl}auth/login";
  static const String signup = "${baseUrl}auth/signup";
  static const String verifyOTP = "${baseUrl}auth/verifyOTP";
  static const String resendOTP = "${baseUrl}auth/resendOTP";
  static const String refreshToken = "${baseUrl}auth/refreshToken";

  // user
  static const String searchInUsers = "${baseUrl}user/search";
  static const String getUser = "${baseUrl}user";
  static const String updateUser = "${baseUrl}user";
  static const String uploadProfileImage = "${baseUrl}user/image";
  static const String getUserCurrentStatus = "${baseUrl}user/currentStatus";

  // contacts
  static const String getUserContacts = "${baseUrl}contact";
  static const String createContact = "${baseUrl}contact";

  // stories
  static const String createStory = "${baseUrl}status";
  static const String getCurrentUserStory = "${baseUrl}status";
  static const String getUserContactsStory = "${baseUrl}status/getUserCotactsStatus";
  static String viewStory({required int storyId}) => "${baseUrl}status/view/$storyId";
  static String deleteStory({required int storyId}) => "${baseUrl}status/$storyId";
  static String reactStory({required int storyId}) => "${baseUrl}status/react/$storyId";
  static String getReactsOnStory({required String storyId}) =>
      "${baseUrl}status/reacts/$storyId";
  static String getViewsOnStory({required String storyId}) =>
      "${baseUrl}status/views/$storyId";

  // chats (uses webSocketUrl instead of baseUrl)
  static const String createChat = "${webSocketUrl}chat";
  static const String getUserChats = "${webSocketUrl}chat";
  static const String uploadChatImage = "${webSocketUrl}chat/uploadChatImage";
  static String pinChat({required int chatId}) => "${webSocketUrl}chat/pin/$chatId";
  static String unPinChat({required int chatId}) => "${webSocketUrl}chat/unPin/$chatId";
  static String getChatMessages({required int chatId}) => "${webSocketUrl}chat/messages/$chatId";
  static String getMessageHistory({required int messageId}) => "${webSocketUrl}chat/message/$messageId/history";
  static String getMessageReacts({required int messageId}) => "${webSocketUrl}chat/message/$messageId/reacts";
}
