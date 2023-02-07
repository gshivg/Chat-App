// ignore_for_file: depend_on_referenced_packages, await_only_futures

import 'package:chat_app_asper/utils/firebase_helper.dart';
import 'package:chat_app_asper/models/user_model.dart';
import 'package:chat_app_asper/screens/home_screen.dart';
import 'package:chat_app_asper/screens/sign-in-screen.dart';
import 'package:chat_app_asper/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentUser = await FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    UserModel? thisUserModel =
        await FirebaseHelper.getUserModelById(currentUser.uid);
    if (thisUserModel != null) {
      runApp(MyAppLogged(firebaseUser: currentUser, userModel: thisUserModel));
    } else {
      runApp(const MyApp());
    }
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1500,
      splash: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.north_west_sharp,
            size: 70.0,
            color: StandardColorLibrary.kColor1,
          ),
          SizedBox(width: 25),
          Text(
            'RiskIt',
            style: TextStyle(
              fontSize: 70,
              color: StandardColorLibrary.kColor1,
            ),
          ),
        ],
      ),
      backgroundColor: StandardColorLibrary.kColor4,
      curve: Curves.easeInCirc,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      nextScreen: const SignInScreen(),
    );
  }
}

class MyAppLogged extends StatelessWidget {
  final User? firebaseUser;
  final UserModel? userModel;

  const MyAppLogged(
      {Key? key, required this.firebaseUser, required this.userModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenLogged(
          firebaseUser: firebaseUser!, userModel: userModel!),
    );
  }
}

class SplashScreenLogged extends StatelessWidget {
  final User? firebaseUser;
  final UserModel? userModel;
  const SplashScreenLogged({Key? key, this.firebaseUser, this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1500,
      splash: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.north_west_sharp,
            size: 70.0,
            color: StandardColorLibrary.kColor1,
          ),
          SizedBox(width: 25),
          Text(
            'RiskIt',
            style: TextStyle(
              fontSize: 70,
              color: StandardColorLibrary.kColor1,
            ),
          ),
        ],
      ),
      backgroundColor: StandardColorLibrary.kColor4,
      curve: Curves.easeInCirc,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      nextScreen:
          HomeScreen(userModel: userModel!, firebaseUser: firebaseUser!),
    );
  }
}
