import 'package:etravel/config/app_colors.dart';
import 'package:etravel/config/etravel_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_bindings.dart';
import 'config/routes.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ETravel Cab',
      theme: ETravelTheme.light,
      debugShowCheckedModeBanner: false,
      getPages: Routes.allRoutes,
      initialRoute: Routes.initialRoute,
      initialBinding: AppBinding(),
    );
  }
}
