import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spoco_app/pages/home-page.dart';
import 'package:spoco_app/pages/login-page.dart';
import 'package:spoco_app/pages/register-page.dart';
import 'package:spoco_app/pages/splash.dart';
import 'firebase_options.dart';


main() async

 {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
 
    return MaterialApp(
     
      debugShowCheckedModeBanner: false,
   
      initialRoute: "/",
      routes: {
        "/": (context) => const Splash(),
         "/register": (context) => const RegisterPage(),
        "/home": (context) => const HomePage(),
        "/login": (context) => const LoginPage(),
      //"/loginForm": (context) => const LoginPageForm(),
       
      },
    );
  }
}