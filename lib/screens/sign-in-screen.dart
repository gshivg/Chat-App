// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, sized_box_for_whitespace, unused_local_variable, use_build_context_synchronously

import 'dart:developer';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/utils/reusable_test_fiels.dart';
import 'package:chat_app/utils/ui_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/utils/constant.dart';
import 'package:another_flushbar/flushbar.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';

/*
  Use same page for phone / otp
  set phone number to immutabel after confirming phone number
  set otp text field as insible by default
  remove middle button
  chnange the button text from get otp to verify

  add alert dialogue box for failed verifcation 
*/

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  var passwordErrorText;
  var emailErrorText;
  var objectHeight = 55.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          color: StandardColorLibrary.kColor4,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.15, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.north_west_sharp,
                      size: 100.0,
                      color: StandardColorLibrary.kColor1,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'RiskIt',
                      style: TextStyle(
                        fontSize: 80,
                        color: StandardColorLibrary.kColor1,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                reusableTextField1('Enter Email', _emailController, false,
                    Icons.email_rounded, TextInputType.emailAddress),
                reusableTextField1('Enter Password', _passController, true,
                    Icons.lock_rounded, TextInputType.visiblePassword),
                const SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      String email = _emailController.text.trim();
                      String pass = _passController.text.trim();
                      if (!(email.contains('@')) || (!email.contains('.com'))) {
                        showSimpleSnackbar(
                          context,
                          'Check Input',
                          'Improper Email Provided',
                        );
                      } else if (_passController.text.isEmpty) {
                        showSimpleSnackbar(
                          context,
                          'Enter Password',
                          'Enter Password to proceed',
                        );
                      } else if (pass.length < 8) {
                        showSimpleSnackbar(
                          context,
                          'Password Error',
                          'Password should be more than 8 characters.',
                        );
                      } else {
                        signIn(email, pass);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return StandardColorLibrary.kColor5;
                        }
                        return StandardColorLibrary.kColor3;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      'Sign In',
                      style: const TextStyle(
                        color: StandardColorLibrary.kColor6,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                signUpOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: StandardColorLibrary.kColor2),
        ),
        SizedBox(
          width: 2,
        ),
        GestureDetector(
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
              color: StandardColorLibrary.kColor2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void showSimpleSnackbar(BuildContext context, String title, String message) {
    Flushbar(
      duration: Duration(seconds: 3),
      title: title,
      message: message,
      titleColor: StandardColorLibrary.kColor6,
      messageColor: StandardColorLibrary.kColor6,
      backgroundColor: StandardColorLibrary.kColor5,
    ).show(context);
  }

  void signIn(String email, String pass) async {
    UserCredential? credential;
    UIHelper.showLoadingDialog('signing you in...', context);
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      log('SignIn');
    } on FirebaseAuthException catch (error) {
      log(error.code);
      Navigator.pop(context);
      if (error.code == 'wrong-password') {
        showSimpleSnackbar(
          context,
          'Incorrect Password',
          'Check your password and try again.',
        );
      } else if (error.code == 'user-not-found') {
        showSimpleSnackbar(context, 'Uer not found',
            'Check your email or\nClick on Sign Up to get started');
      } else {
        showSimpleSnackbar(
          context,
          'Some Problem Has Occured',
          'Try again after some time',
        );
      }
    }
    if (credential != null) {
      String uid = credential.user!.uid;

      log('false1');
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      log(userData.toString());
      log('false2');
      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);
      log('Success');
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: ((context) {
            return HomeScreen(
              userModel: userModel,
              firebaseUser: credential!.user!,
            );
          }),
        ),
      );
    }
  }
}
