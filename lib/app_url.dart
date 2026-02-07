class AppUrl {
  // static const String baseUrl = "https://task.teamrabbil.com/api/v1";
  static const String baseUrl = "http://35.73.30.144:2005/api/v1";

  static const String registration = "$baseUrl/registration";
  static const String login = "$baseUrl/login";
  static const String profileUpdate = "$baseUrl/profileUpdate";

  static const String createTask = "$baseUrl/createTask";
  static const String updateTaskStatus = "$baseUrl/updateTaskStatus";
  static const String listTaskByStatus = "$baseUrl/listTaskByStatus";
  static const String deleteTask = "$baseUrl/deleteTask";
  static const String taskStatusCount = "$baseUrl/taskStatusCount";

  static const String recoverVerifyEmail = "$baseUrl/RecoverVerifyEmail";
  static const String recoverVerifyOTP = "$baseUrl/RecoverVerifyOTP";
  static const String recoverResetPass = "$baseUrl/RecoverResetPass";
}
