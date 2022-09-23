// ignore_for_file: prefer_typing_uninitialized_variables,, avoid_init_to_null, sized_box_for_whitespace, avoid_print
//sized_box_for_whitespace, prefer_is_not_empty,
//unused_local_variable, depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:chat_app_asper/models/user_model.dart';
import 'package:chat_app_asper/screens/home_screen.dart';
import 'package:chat_app_asper/utils/constant.dart';
import 'package:chat_app_asper/utils/reusable_test_fiels.dart';
import 'package:chat_app_asper/utils/ui_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SetInfoScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser1;
  const SetInfoScreen(
      {Key? key, required this.firebaseUser1, required this.userModel})
      : super(key: key);
  @override
  State<SetInfoScreen> createState() => _SetInfoScreenState();
}

class _SetInfoScreenState extends State<SetInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: StandardColorLibrary.kColor4,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              GestureDetector(
                  onTap: () {
                    showPhotoOptions();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 100,
                    backgroundImage:
                        (imageFile == null) ? null : FileImage(imageFile!),
                    child: (imageFile == null)
                        ? const Icon(
                            Icons.person,
                            size: 60,
                          )
                        : null,
                  )),
              reusableTextField1('Enter Full Name', _nameController, false,
                  Icons.text_fields, TextInputType.name),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    log('pressed');
                    checkNull();
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
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  void showSimpleSnackbar(BuildContext context, String title, String? message) {
    Flushbar(
      duration: const Duration(seconds: 4),
      title: title,
      message: message,
      titleColor: StandardColorLibrary.kColor4,
      messageColor: StandardColorLibrary.kColor4,
      backgroundColor: StandardColorLibrary.kColor1,
    ).show(context);
  }

  void showPhotoOptions() {
    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text('Upload Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: (() {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                }),
                leading: const FaIcon(FontAwesomeIcons.solidFileImage),
                title: const Text(
                  'Select from Gallery',
                ),
              ),
              ListTile(
                onTap: (() {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                }),
                leading: const FaIcon(FontAwesomeIcons.camera),
                title: const Text(
                  'Take a photo',
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 25,
    );
    if (croppedImage != null) {
      imageFile = File(croppedImage.path);
    }
  }

  void checkNull() {
    String name = _nameController.text.trim();
    if (name.isEmpty || imageFile == null) {
      log('check null');
      showSimpleSnackbar(context, 'Incomplete Fields',
          'Please select a profile Picture and Enter your full name.');
    } else {
      log('uploading');
      upLoadData();
    }
  }

  void upLoadData() async {
    UIHelper.showLoadingDialog('Uploading Image...\nPlease wait', context);
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('profilePictures')
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);
    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    String name = _nameController.text.trim();

    widget.userModel.fullName = name;
    widget.userModel.profilePic = imageUrl;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      log('data uploaded');
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            firebaseUser: widget.firebaseUser1,
            userModel: widget.userModel,
          ),
        ),
      );
    });
  }
}
