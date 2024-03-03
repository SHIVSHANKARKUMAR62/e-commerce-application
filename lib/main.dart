import 'package:admineccomerce/screen/home.dart';
import 'package:admineccomerce/screen/homepage.dart';
import 'package:admineccomerce/screen/loginScreen/loginPage.dart';
import 'package:admineccomerce/screen/splashscreen/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.blue.shade300,
          toolbarHeight: Get.height*0.12

        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}

// HomePage:-> Home()

