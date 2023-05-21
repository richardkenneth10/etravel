import 'dart:convert';
import 'dart:developer';

import 'package:etravel/app_bindings.dart';
import 'package:etravel/config/app_constants.dart';
import 'package:etravel/config/routes.dart';
import 'package:etravel/models/exceptions/etravel_exception.dart';
import 'package:etravel/services/api.dart';
import 'package:etravel/services/user_data_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends GetxService {
  static final AuthService instance = AuthService._();
  factory AuthService() => instance;
  AuthService._();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future sendOTP(String phone) async {
    final res = await Get.find<APIService>().api.post(
      '/auth/send-otp',
      data: {
        "phone": phone,
      },
    );
  }

  Future verifyOTPAndLogin(String phone, int otp) async {
    log('hi');
    final res = await Get.find<APIService>().api.post(
      '/auth/verify-phone-and-login',
      data: {
        "phone": phone,
        "otp": otp,
      },
    );
    await _saveTokens(res.data);
  }

  Future loginWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw const ETravelException('Could not get user');
    }
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser.authentication;
    log(googleSignInAuthentication.accessToken!);
    final res = await Get.find<APIService>().api.post(
      '/auth/login-with-google',
      data: {
        "accessToken": googleSignInAuthentication.accessToken!,
      },
    );
    await _saveTokens(res.data);
  }

  Future loginWithFacebook() async {
    final loginResult = await FacebookAuth.i.login();
    if (loginResult.status != LoginStatus.success) {
      throw const ETravelException('Sign in failed');
    }

    final token = loginResult.accessToken!.token;
    // log(token);

    final res = await Get.find<APIService>().api.post(
      '/auth/login-with-facebook',
      data: {
        "accessToken": token,
      },
    );
    await _saveTokens(res.data);
  }

  Future logout() async {
    final res = await Get.find<APIService>().api.delete(
          '/auth/logout',
        );

    await GoogleSignIn().signOut();
    await FacebookAuth.i.logOut();

    await _secureStorage.deleteAll();
    await Get.deleteAll(force: true);
    AppBinding().dependencies();
    Get.toNamed(Routes.authScreen);
  }

  Future<void> _saveTokens(dynamic responseData) async {
    // log(responseData["accessToken"]);
    // log(responseData["refreshToken"]);
    final accessToken = responseData["accessToken"];
    final refreshToken = responseData["refreshToken"];
    final userProfile = responseData["user"];

    await _secureStorage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
    await _secureStorage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
    await _secureStorage.write(
        key: USER_PROFILE_KEY, value: json.encode(userProfile));
    await Get.find<UserDataService>().updateCurrentUser();
  }
}
