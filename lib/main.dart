import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:insta/providers/user_provider.dart';
import 'package:insta/responsive/mobile_screen_layout.dart';
import 'package:insta/responsive/web_screen_layout.dart';
import 'package:insta/utils/colors.dart';
import 'package:provider/provider.dart';
import 'responsive/responsive_screen_layou.dart';
import 'package:insta/screen/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDLOlnwRZ95PPwiv9OZefdbNkQQn6BP7G4",
            authDomain: "igclone-60985.firebaseapp.com",
            projectId: "igclone-60985",
            storageBucket: "igclone-60985.appspot.com",
            messagingSenderId: "328183751429",
            appId: "1:328183751429:web:ee06a900e1c733e13acd6c"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ), 
      ],
      child: MaterialApp(
          theme: ThemeData.dark()
              .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
          debugShowCheckedModeBanner: false,
          title: 'Instagram Clone',
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return const ResponsiveSreen(
                      mobileScreenLayout: MobileScreenLayout(),
                      webScreenLayout: WebScreenLayout(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error}',
                      ),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }
                return const LoginScreen();
              })),
    );
  }
}
