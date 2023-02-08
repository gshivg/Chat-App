// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable, sized_box_for_whitespace, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/set_info_screen.dart';
import 'package:chat_app/screens/sign-in-screen.dart';
import 'package:chat_app/utils/constant.dart';
import 'package:chat_app/utils/reusable_test_fiels.dart';
import 'package:chat_app/utils/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _pass2Controller = TextEditingController();
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                reusableTextField1('Enter Email', _emailController, false,
                    Icons.email_rounded, TextInputType.emailAddress),
                reusableTextField1('Enter Password', _passController, true,
                    Icons.lock_rounded, TextInputType.visiblePassword),
                reusableTextField1('Confirm Password', _pass2Controller, true,
                    Icons.lock_rounded, TextInputType.visiblePassword),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      signUpButtonLogic();
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
                      'Sign Up',
                      style: const TextStyle(
                        color: Colors.black87,
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
          "Already have an account?",
          style: TextStyle(color: StandardColorLibrary.kColor2),
        ),
        SizedBox(
          width: 2,
        ),
        GestureDetector(
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            log('popped page');
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: ((context) => SignInScreen())));
            log('page pushed');
          },
          child: const Text(
            "Sign In!",
            style: TextStyle(
              color: StandardColorLibrary.kColor2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void showSimpleSnackbar(BuildContext context, String title, String? message) {
    Flushbar(
      duration: Duration(seconds: 4),
      title: title,
      message: message,
      titleColor: StandardColorLibrary.kColor6,
      messageColor: StandardColorLibrary.kColor6,
      backgroundColor: StandardColorLibrary.kColor5,
    ).show(context);
  }

  signUpButtonLogic() {
    String email = _emailController.text.trim();
    String pass = _pass2Controller.text.trim();
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(email.contains('@')) || (!email.contains('.com'))) {
      showSimpleSnackbar(
        context,
        'Check Input',
        'Improper Email Provided',
      );
    } else if (_passController.text.isEmpty || _pass2Controller.text.isEmpty) {
      showSimpleSnackbar(
        context,
        'Enter Password',
        'Enter Password to proceed',
      );
    } else if (_pass2Controller.text.trim() != _passController.text.trim()) {
      showSimpleSnackbar(
        context,
        'Check Input',
        'Passwords do not match.',
      );
    } else if (pass.length < 8) {
      showSimpleSnackbar(
        context,
        'Password Error',
        'Password should be more than 8 characters.',
      );
    } else {
      signUp(email, pass);
    }
  }

  void signUp(String email, String pass) async {
    UserCredential? credential;
    UIHelper.showLoadingDialog('Signing you up....', context);
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      if (error.code == 'email-already-in-use') {
        log(error.code);
        showSimpleSnackbar(
          context,
          'Account already exists',
          'This email is already linked with another account',
        );
      } else {
        showSimpleSnackbar(
          context,
          'Some error has eccured',
          'Try again after some time',
        );
      }
    }
    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullName: '',
        profilePic: '',
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetInfoScreen(
              firebaseUser1: credential!.user!,
              userModel: newUser,
            ),
          ),
        );
      });
    }
  }
}
