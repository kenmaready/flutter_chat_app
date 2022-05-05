import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//
import './screens/splash.dart';
import './screens/auth.dart';
import './screens/chat.dart';
import './firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.getToken();
  print("about to call runApp(MyApp())....");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Build in Myapp() starting....");
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          backgroundColor: Colors.orange,
          accentColor: Colors.brown.shade300,
          accentColorBrightness: Brightness.light,
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.orange.shade200,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36)))),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            print("now in Streambuilder.builder...");
            if (userSnapshot.hasData) {
              print("calling ChatScreen()...");
              return ChatScreen();
            } else {
              print("calling AuthScreen()...");
              return AuthScreen();
            }
          }),
    );
  }
}
