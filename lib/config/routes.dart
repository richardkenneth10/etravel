import 'package:etravel/screens/auth/auth.dart';
import 'package:etravel/screens/auth/otp/otp.dart';
import 'package:etravel/screens/auth/phone/phone.dart';
import 'package:etravel/screens/auth/setup_profile/email/email.dart';
import 'package:etravel/screens/auth/setup_profile/name/name.dart';
import 'package:etravel/screens/auth/setup_profile/setup_profile.dart';
import 'package:etravel/screens/card_form/card_form.dart';
import 'package:etravel/screens/home/home.dart';
import 'package:etravel/screens/initial/initial.dart';
import 'package:etravel/screens/payment/payment.dart';
import 'package:etravel/screens/save_payment_details/save_payment_details.dart';
import 'package:get/get.dart';

class Routes {
  static final List<GetPage> allRoutes = [
    initial,
    auth,
    phone,
    otp,
    setupProfile,
    email,
    name,
    home,
    cardForm,
    savePaymentDetails,
    payment,
  ];

  static String initialRoute = '/';

  static get authScreen => auth.name;

  static get phoneScreen => phone.name;

  static get otpScreen => otp.name;

  static get setupProfileScreen => setupProfile.name;

  static get emailScreen => email.name;

  static get nameScreen => name.name;

  static get homeScreen => home.name;

  static get cardFormScreen => cardForm.name;

  static get savePaymentDetailsScreen => savePaymentDetails.name;

  static get paymentScreen => payment.name;

  static get initialScreen => initial.name;
}
