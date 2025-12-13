class ApiConstants {
  static const String baseUrl = "http://ymart.app/api/";

  static const String loginEndpoint = "auth/token/";
  static const String registerEndpoint = "auth/register/";
  static const String userProfileEndpoint = "user/profile";
  static const String doctorEndpoint = "doctors/";
  static const String specialtyEndpoint = "specialties/";
  static const String profileEndpoint = "=auth/me/";
  static const String chatEndpoint = "chat/";
  static const String appointmentsEndpoint = "appointments/";
  static const String foldersEndpoint = "patients/me/folders/";
  static const String refreshTokenEndpoint = "${baseUrl}auth/token/refresh/";
  static filesEndpoint(int folderId) => "folders/$folderId/files/";
  static const String itemsEndpoint = "items";
}
