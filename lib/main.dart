import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/models/data_store.dart';
import 'home_screen.dart';
import 'login/signIn.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Fetch the songs from Firebase if the user is logged in else do this after sign in
  if (DataStore().isUserLoggedIn) {
    await DataStore().loadAllData();
  }

  runApp(MyApp());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Constant.darkBlue,
    statusBarColor: Constant.blue,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ନିଗମ ଲହରୀ',
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Constant.darkBlue,
        primarySwatch: Colors.deepPurple,
        appBarTheme: AppBarTheme(color: Constant.blue),

        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      home: Container(
        child: Scaffold(
          body: AnimatedSplashScreen(
            splash: Image(
              image: AssetImage('assets/image/nsslogo.png'),
            ),
            splashIconSize: 200,
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.transparent,
            nextScreen: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final user = snapshot.data;
                  if (user == null) {
                    return SignIn();
                  }
                  return HomeScreen();
                } else {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
