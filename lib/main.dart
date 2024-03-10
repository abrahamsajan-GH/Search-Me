import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:search_me/constants/constants.dart';
import 'package:search_me/firebase/firebase_options.dart';
import 'package:search_me/screens/admin/widgets/admin_landing.dart';
import 'package:search_me/screens/org/widgets/org_landing.dart';

import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Addressbuk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: blackClr),
          bodyMedium: TextStyle(color: blackClr),
        ),
        primarySwatch: blueClr,
      ),
      home: const AuthChecker(),
    );
  }
}

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  AuthCheckerState createState() => AuthCheckerState();
}

class AuthCheckerState extends State<AuthChecker> {
  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  Future<void> checkUserLoggedIn() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        if (user.email == "admin@gmail.com") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdminLanding()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => OrgLanding()),
          );
        }
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
