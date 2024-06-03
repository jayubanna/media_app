import 'package:flutter/material.dart';
import 'package:media_booster/view/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:media_booster/view/home_page.dart';
import 'package:media_booster/view/login_page.dart';
import 'package:media_booster/view/music_page.dart';

import 'home_provider/music_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MusicPlayerProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/":(context) => SplashScreen(),
          "login_page": (context) => LoginPage(),
          "home_page": (context) => HomePage(),
          "music_page": (context) => MusicPlayerScreen(),
        },
      ),
    );
  }
}
