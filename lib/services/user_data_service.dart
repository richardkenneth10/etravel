import 'dart:convert';

import 'package:etravel/config/app_constants.dart';
import 'package:etravel/models/exceptions/etravel_exception.dart';
import 'package:etravel/models/user/user_data.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'api.dart';

class UserDataService extends GetxService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  UserData? _currentUser;

  UserData? get currentUser => _currentUser;

  Future<void> verifyAndUpdatePhone(String phone, int otp) async {
    final res = await Get.find<APIService>().api.patch(
      '/profile/verify-and-update-phone',
      data: {
        "phone": phone,
        "otp": otp,
      },
    );
    await _saveTokens(res.data);
  }

  Future<void> updateNames(String firstName, String lastName) async {
    final res = await Get.find<APIService>().api.patch(
      '/profile/update-profile',
      data: {
        "first_name": firstName,
        "last_name": lastName,
      },
    );
    await _saveTokens(res.data);
  }

  Future<void> updateEmail(String email) async {
    final res = await Get.find<APIService>().api.patch(
      '/profile/update-profile',
      data: {
        "email": email,
      },
    );
    await _saveTokens(res.data);
  }

  Future<void> updateProfileWithGoogle() async {
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
    final res = await Get.find<APIService>().api.patch(
      '/profile/update-profile-from-google',
      data: {
        "accessToken": googleSignInAuthentication.accessToken!,
      },
    );
    await _saveTokens(res.data);
  }

  Future updateProfileWithFacebook() async {
    final loginResult = await FacebookAuth.i.login();
    if (loginResult.status != LoginStatus.success) {
      throw const ETravelException('Sign in failed');
    }

    final token = loginResult.accessToken!.token;

    final res = await Get.find<APIService>().api.patch(
      '/profile/update-profile-from-facebook',
      data: {
        "accessToken": token,
      },
    );
    await _saveTokens(res.data);
  }

  Future<void> _saveTokens(dynamic responseData) async {
    final accessToken = responseData["accessToken"];
    final refreshToken = responseData["refreshToken"];
    final userProfile = responseData["user"];

    await _secureStorage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
    await _secureStorage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
    await _secureStorage.write(
        key: USER_PROFILE_KEY, value: json.encode(userProfile));
    await updateCurrentUser();
  }

  @override
  Future<void> onInit() async {
    super.onInit();

    final user = await _secureStorage.read(key: USER_PROFILE_KEY);

    if (user == null) {
      return;
    }

    final userJSON = json.decode(user) as Map<String, dynamic>;
    final userData = UserData.fromJson(userJSON);
    _currentUser = userData;
  }

  updateCurrentUser() async {
    final user = await _secureStorage.read(key: USER_PROFILE_KEY);

    if (user == null) {
      return;
    }

    final userJSON = json.decode(user) as Map<String, dynamic>;
    final userData = UserData.fromJson(userJSON);
    _currentUser = userData;
  }
}
