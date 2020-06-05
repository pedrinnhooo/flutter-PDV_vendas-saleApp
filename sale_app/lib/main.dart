import 'package:flutter/material.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

import 'src/app_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Intercom.initialize(
    'p0ka854d',
    androidApiKey: 'android_sdk-5c525d675fc6adcb2b92f5d6977991ded9be76ce',
    iosApiKey: 'ios_sdk-39a1bd00c61ae488e71d2325f6a3a82497fbeb65',
  );
  await Intercom.logout();

  runApp(AppModule());
} 
