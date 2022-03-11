import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/data_store.dart';

import 'login/signIn.dart';
import 'home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Fetch the songs from Firebase if the user is logged in else do this after sign in
  if (DataStore().isUserLoggedIn) {
    await DataStore().loadAllData();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ନିଗମ ଲହରୀ',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: StreamBuilder<User?>(
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
    );
  }
}
 

    // return MaterialApp(
    //   title: 'ନିଗମ ଲହରୀ',
    //   theme: ThemeData(
    //     primarySwatch: Colors.green,
    //   ),
    //   debugShowCheckedModeBanner: true,
    //   home: FutureBuilder(
    //     future: checkLoginStatus(),
    //     builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
    //       if (snapshot.data == false) {
    //         return SignIn();
    //       }

    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Container(
    //           color: Colors.white,
    //           child: Center(
    //             child: CircularProgressIndicator(),
    //           ),
    //         );
    //       }
    //       return HomeScreen();
    //     },
    //   ),
    // );