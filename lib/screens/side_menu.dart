// ignore_for_file: must_be_immutable

import 'package:chat_app_asper/main.dart';
import 'package:chat_app_asper/models/user_model.dart';
import 'package:chat_app_asper/screens/profile_screen.dart';
import 'package:chat_app_asper/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  UserModel userModel;
  NavDrawer({Key? key, required this.context, required this.userModel})
      : super(key: key);
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: StandardColorLibrary.kColor4,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: StandardColorLibrary.kColor1,
            ),
            child: Text(
              'Side menu',
              style:
                  TextStyle(color: StandardColorLibrary.kColor6, fontSize: 25),
            ),
          ),
          ListTile(
            leading:
                const Icon(Icons.input, color: StandardColorLibrary.kColor6),
            title: const Text(
              'Welcome',
              style: TextStyle(color: StandardColorLibrary.kColor6),
            ),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.verified_user,
                color: StandardColorLibrary.kColor6),
            title: const Text(
              'Profile',
              style: TextStyle(color: StandardColorLibrary.kColor6),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => ProfileScreen(
                      userModel: userModel,
                    )),
              ),
            ),
          ),
          ListTile(
            leading:
                const Icon(Icons.settings, color: StandardColorLibrary.kColor6),
            title: const Text(
              'Settings',
              style: TextStyle(color: StandardColorLibrary.kColor6),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.border_color,
                color: StandardColorLibrary.kColor6),
            title: const Text(
              'Feedback',
              style: TextStyle(color: StandardColorLibrary.kColor6),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app,
                color: StandardColorLibrary.kColor6),
            title: const Text(
              'Logout',
              style: TextStyle(color: StandardColorLibrary.kColor6),
            ),
            onTap: () {
              signOut();
            },
          ),
        ],
      ),
    );
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const MyApp();
      }));
    });
  }
}
