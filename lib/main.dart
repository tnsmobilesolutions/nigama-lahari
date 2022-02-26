import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_application_1/nigamLahari/nigam_lahari.dart';import 'package:audio_service/audio_service.dart';
import 'login/signIn.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ନିଗମ ଲହରୀ',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: SignIn(),
    );
  }
}





// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(NigamLahari());
// }

// class NigamLahari extends StatelessWidget {
//   final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: _initialization,
//         builder: (context, snapshot) {
//           // Check for Errors
//           if (snapshot.hasError) {
//             print("Something Went Wrong");
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           return MaterialApp(
//             title: 'ନିଗମ ଲହରୀ',
//             theme: ThemeData(
//               primarySwatch: Colors.deepPurple,
//             ),
//             debugShowCheckedModeBanner: false,
//             home: SignIn(),
//           );
//         });
//   }
// }
