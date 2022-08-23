// ignore_for_file: sized_box_for_whitespace, must_be_immutable

import 'package:chat_app_asper/models/user_model.dart';
import 'package:chat_app_asper/screens/update_profile_screen.dart';
import 'package:chat_app_asper/utils/constant.dart';

import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  UserModel userModel;
  ProfileScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StandardColorLibrary.kColor1,
        centerTitle: true,
        title: const Text(
          'Your Profile',
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: StandardColorLibrary.kColor4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: Container(
                  height: 1,
                  decoration: const BoxDecoration(
                    color: StandardColorLibrary.kColor6,
                  ),
                ),
              ),
              const Text(
                'Your Display Picture:',
                style: TextStyle(
                  color: StandardColorLibrary.kColor1,
                  fontSize: 22,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    NetworkImage(widget.userModel.profilePic.toString()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: Container(
                  height: 1,
                  decoration: const BoxDecoration(
                    color: StandardColorLibrary.kColor6,
                  ),
                ),
              ),
              const Text(
                'Your Name:',
                style: TextStyle(
                  color: StandardColorLibrary.kColor1,
                  fontSize: 22,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              Text(
                widget.userModel.fullName.toString(),
                style: const TextStyle(
                  color: StandardColorLibrary.kColor6,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: Container(
                  height: 1,
                  decoration: const BoxDecoration(
                    color: StandardColorLibrary.kColor6,
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: ElevatedButton(
                  onPressed: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UpdateProfile(userModel: widget.userModel)),
                    );
                  }),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return StandardColorLibrary.kColor3;
                      }
                      return StandardColorLibrary.kColor1;
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
                  child: const Text(
                    'Update Profile',
                    style: TextStyle(
                      color: StandardColorLibrary.kColor6,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
