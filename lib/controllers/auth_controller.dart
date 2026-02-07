import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthController {

  static const String _accessTokenKey = 'access_token';
  static const String _userModelKey = 'user_model';


  static String? accessToken;
  static UserModel? userModel;


  static Future<void> saveUserData(
    UserModel model,
    String token,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_accessTokenKey, token);
    await prefs.setString(_userModelKey, jsonEncode(model.toJson()));

    accessToken = token;
    userModel = model;
  }


  static Future<bool> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString(_accessTokenKey);
    final userData = prefs.getString(_userModelKey);

    if (token != null && userData != null) {
      accessToken = token;
      userModel = UserModel.fromJson(jsonDecode(userData));
      return true; 
    }
    return false; 
  }

  
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_accessTokenKey);
    await prefs.remove(_userModelKey);

    accessToken = null;
    userModel = null;
  }

  static bool isLoggedIn() {
    return accessToken != null;
  }
}
