import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'app.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  Stripe.publishableKey = FlutterConfig.get('STRIPE_PUBLISHABLE_KEY');
  await Stripe.instance.applySettings();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const App());
}
