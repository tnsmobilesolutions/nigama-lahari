import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/models/data_store.dart';
import 'package:provider/provider.dart';
import 'API/userAPI.dart';
import 'home_screen.dart';
import 'login/signIn.dart';
import 'models/usermodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Fetch the songs from Firebase if the user is logged in else do this after sign in
  if (DataStore().isUserLoggedIn) {
    await DataStore().loadAllData();
  }

  runApp(MyApp());

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Constant.darkBlue,
      statusBarColor: Constant.blue,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
    Constant.isDarkMode = Constant.brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppUser(),
      //value: Counter(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ନିଗମ ଲହରୀ',
        //light theme
        theme: ThemeData(
          brightness: Brightness.light,
          cupertinoOverrideTheme: CupertinoThemeData(
            primaryColor: Constant.orange,
          ),
          listTileTheme: ListTileThemeData(tileColor: Constant.yellow),
          iconTheme: IconThemeData(color: Constant.yellow),
          buttonTheme: ButtonThemeData(
              buttonColor: Constant.orange, textTheme: ButtonTextTheme.primary),
          fontFamily: 'Roboto',
          primaryColor: Constant.darkOrange,
          textTheme: TextTheme(button: TextStyle(color: Constant.black)),
          scaffoldBackgroundColor: Constant.white,
          appBarTheme: AppBarTheme(color: Constant.darkOrange),
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: Constant.orange),
        ),

        darkTheme: ThemeData(
          cupertinoOverrideTheme: CupertinoThemeData(
            primaryColor: Constant.orange,
          ),
          listTileTheme: ListTileThemeData(tileColor: Constant.lightblue),
          iconTheme: IconThemeData(color: Constant.orange),
          buttonTheme: ButtonThemeData(
              buttonColor: Constant.orange, textTheme: ButtonTextTheme.primary),
          fontFamily: 'Roboto',
          primaryColor: Constant.orange,
          textTheme: TextTheme(button: TextStyle(color: Constant.orange)),
          scaffoldBackgroundColor: Constant.darkBlue,
          appBarTheme: AppBarTheme(color: Constant.blue),
          brightness: Brightness.dark,
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: Constant.orange),
        ),
        themeMode: ThemeMode.dark,
        home: Scaffold(
          body: AnimatedSplashScreen(
            splash: Image(
              image: AssetImage('assets/image/nsslogo-2.png'),
            ),
            splashIconSize: 200,
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Constant.darkBlue,
            nextScreen: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final user = snapshot.data;

                  if (user == null) {
                    return SignIn();
                  } else {
                    return FutureBuilder<AppUser?>(
                      future: userAPI().getAppUserFromUid(user.uid),
                      builder: (_, snap) {
                        if (snap.hasData) {
                          return HomeScreen(loggedInUser: snap.data);
                          // ChangeNotifierProvider(
                          //   create: (_) => AppUser(),
                          //   //value: snap.data,
                          //   builder: (context, Widget) {
                          //     // No longer throws
                          //     return HomeScreen(loggedInUser: snap.data);
                          //   },
                          // );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  }
                } else {
                  return SignIn();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
