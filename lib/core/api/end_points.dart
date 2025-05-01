class EndPoints {
  static const String baseUrl = "http://10.0.2.2:5000/api/";
  static const String webSocketUrl = "http://10.0.2.2:5000/api/";

  // auth
  static const String login = "auth/login";
  static const String signup = "auth/signup";
  static const String verifyOTP = "auth/verifyOTP";
  static const String resendOTP = "auth/resendOTP";
  static const String refreshToken = "auth/refreshToken";

  // user
  static const String searchInUsers = "user/search";
  static const String getUser = "user";
  static const String updateUser = "user";
  static const String uploadProfileImage = "user/image";
  static const String getUserCurrentStatus = "user/currentStatus";

  // contacts
  static const String getUserContacts = "contact";
  static const String createContact = "contact";
}
