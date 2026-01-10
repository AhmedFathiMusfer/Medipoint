class ApiConstants {
  static const String baseUrl = "https://api.decodaai.com/api/";

  static const String loginEndpoint = "auth/token/";
  static const String registerEndpoint = "auth/register/";
  static const String forgetPasswordEndpoint = "auth/password/reset/";
  static const String verifyCodeEndpoint = "auth/password/reset/verify/";
  static const String resetPasswordEndpoint = "auth/password/reset/confirm/";
  static const String changePasswordEndpoint = "auth/password/change/";
  static const String userProfileEndpoint = "user/profile";
  static const String initEndpoint = "doctors/init/";
  static const String doctorEndpoint = "doctors/";
  static const String specialtyEndpoint = "specialties/";
  static const String profileEndpoint = "auth/me/";
  static const String chatEndpoint = "chat/";
  static const String appointmentsEndpoint = "appointments/";
  static String createPaymentIntentEndpoint(int appointmentid) =>
      '$appointmentsEndpoint$appointmentid/create-payment-intent/';

  static const String confirmPaymentEndpoint = "payments/confirm/";
  static reviewEndpoint(String doctorId) => "doctors/$doctorId/reviews/";
  static const String foldersEndpoint = "patients/me/folders/";
  static const String refreshTokenEndpoint = "${baseUrl}auth/token/refresh/";
  static filesEndpoint(int folderId) => "folders/$folderId/files/";
  static const String itemsEndpoint = "items";
}
