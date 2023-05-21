import 'dart:io';

const REFRESH_TOKEN_KEY = 'refresh key';
const ACCESS_TOKEN_KEY = 'access key';
const USER_PROFILE_KEY = 'user profile key';

const GOOGLE_ISSUER = 'https://accounts.google';
const GOOGLE_CLIENT_ID_IOS =
    '238158450422-3qkvs2rtcihtkq47ifhooa4lkc23jf9h.apps.googleusercontent.com';
const GOOGLE_CLIENT_ID_ANDROID =
    '238158450422-g8qbv7anm560t4g75d7fpb6095gsbrmv.apps.googleusercontent.com';
const GOOGLE_REDIRECT_URI_IOS =
    'com.googlusercontent.apps.238158450422-3qkvs2rtcihtkq47ifhooa4lkc23jf9h.apps.googleusercontent.com:/oauthredirect';
const GOOGLE_REDIRECT_URI_ANDROID =
    'com.googlusercontent.apps.238158450422-g8qbv7anm560t4g75d7fpb6095gsbrmv.apps.googleusercontent.com:/oauthredirect';

String clientID() {
  if (Platform.isAndroid) {
    return GOOGLE_CLIENT_ID_ANDROID;
  } else if (Platform.isIOS) {
    return GOOGLE_CLIENT_ID_IOS;
  }
  return '';
}

String redirectURI() {
  if (Platform.isAndroid) {
    return GOOGLE_REDIRECT_URI_ANDROID;
  } else if (Platform.isIOS) {
    return GOOGLE_REDIRECT_URI_IOS;
  }
  return '';
}
