// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:chat_app_asper/models/user_model.dart';
import 'package:chat_app_asper/utils/border_styles.dart';
import 'package:chat_app_asper/utils/constant.dart';
import 'package:chat_app_asper/utils/ui_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  UserModel userModel;
  UpdateProfile({Key? key, required this.userModel}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController nameController = TextEditingController();

  File? imageFile;
  bool imageChanged = false;
  String? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StandardColorLibrary.kColor1,
        centerTitle: true,
        title: const Text(
          'Update Your Profile',
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: StandardColorLibrary.kColor4,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Update Your Display Picture:',
                  style: TextStyle(
                    color: StandardColorLibrary.kColor1,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: (() {
                    imageChanged = true;
                    showPhotoOptions();
                  }),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.transparent,
                    foregroundImage:
                        (imageFile == null) ? null : FileImage(imageFile!),
                    backgroundImage:
                        NetworkImage(widget.userModel.profilePic.toString()),
                  ),
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
                  'Update Your Profile Name:',
                  style: TextStyle(
                    color: StandardColorLibrary.kColor1,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: nameController,
                  style: const TextStyle(
                    color: StandardColorLibrary.kColor6,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    border: KnormalBorder,
                    enabledBorder: KnormalBorder,
                    focusedBorder: KFocusedBorder,
                    errorBorder: KErrorBorder,
                    focusedErrorBorder: KFocusedBorder,
                    hintText: widget.userModel.fullName.toString(),
                    hintStyle: const TextStyle(
                      color: StandardColorLibrary.kColor6,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: (() async {
                      if (imageChanged || nameController.text.isNotEmpty) {
                        if (nameController.text.isEmpty) {
                          nameController.text = widget.userModel.fullName!;
                        }
                        updateProfile();
                        setState(() {});
                      }
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
      setState(() {});
    }
  }

  void updateProfile() async {
    UIHelper.showLoadingDialog('Updating Profile...\nPlease wait', context);
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('profilePictures')
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);
    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    String name = nameController.text.trim();

    widget.userModel.fullName = name;
    widget.userModel.profilePic = imageUrl;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      log('data uploaded');
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
