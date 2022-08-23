import 'dart:developer';
import 'dart:io';

import 'package:chat_app_asper/main.dart';
import 'package:chat_app_asper/models/chat_room_model.dart';
import 'package:chat_app_asper/models/message_model.dart';
import 'package:chat_app_asper/models/user_model.dart';
import 'package:chat_app_asper/utils/border_styles.dart';
import 'package:chat_app_asper/utils/constant.dart';
import 'package:chat_app_asper/utils/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ChatRoom extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatRoom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoom(
      {super.key,
      required this.targetUser,
      required this.chatRoom,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(
                widget.targetUser.profilePic.toString(),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(widget.targetUser.fullName.toString()),
          ],
        ),
        centerTitle: true,
        backgroundColor: StandardColorLibrary.kColor4,
      ),
      body: Container(
        color: StandardColorLibrary.kColor4,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          child: Column(
            children: [
              // For Chats
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(widget.chatRoom.ChatRoomId)
                      .collection('messages')
                      .orderBy('createdOn', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState != ConnectionState.active) {
                      log('test check 1');
                      return const Center(child: CircularProgressIndicator());
                    }
                    log('test check 2');
                    if (snapshot.hasData) {
                      log('test check 3');
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;
                      log('test check 4');
                      return ListView.builder(
                        reverse: true,
                        itemCount: dataSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          log('test check 4.5');
                          MessageModel currentMessage = MessageModel.fromMap(
                              dataSnapshot.docs[index].data()
                                  as Map<String, dynamic>);
                          log('test check 5');
                          if (currentMessage.isPhoto == true) {
                            return photoFrame(
                                currentMessage.text.toString(),
                                (currentMessage.sender ==
                                    widget.userModel.uid));
                          } else {
                            return messageBubble(
                                currentMessage.text.toString(),
                                (currentMessage.sender ==
                                    widget.userModel.uid));
                          }
                        },
                      );
                    } else if (snapshot.hasError) {
                      log('test check 6');
                      return const Text(
                        'Some error ha occured!\nPlease check your internet connection',
                      );
                    } else {
                      log('test check 7');
                      return const Text(
                        'Say Hi to your new friend',
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Message',
                        fillColor: StandardColorLibrary.kColor6,
                        filled: true,
                        border: kChatRoomBorder,
                        errorBorder: kChatRoomBorder,
                        enabledBorder: kChatRoomBorder,
                        focusedBorder: kChatRoomBorder,
                        disabledBorder: kChatRoomBorder,
                        focusedErrorBorder: kChatRoomBorder,
                      ),
                      maxLines: null,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      showPhotoOptions();

                      _messageController.clear();
                    }),
                    icon: const Icon(
                      Icons.camera_alt,
                      color: StandardColorLibrary.kColor1,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      sendMessage(false, _messageController.text.trim(), null);
                      _messageController.clear();
                    }),
                    icon: const Icon(
                      Icons.send,
                      color: StandardColorLibrary.kColor1,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage(bool photo, String? what, File? thisPhoto) async {
    log(thisPhoto.toString());
    log(what.toString());
    DateTime rightNow = DateTime.now();
    if (what == null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref('sentPictures')
          .child(uuid.v1())
          .putFile(thisPhoto!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      log(imageUrl);
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        sender: widget.userModel.uid,
        createdOn: rightNow,
        text: imageUrl,
        isPhoto: photo,
        seen: false,
      );
      log('image message constructed');
      String check1 = widget.chatRoom.ChatRoomId.toString();
      log('test check 1.1');
      log('chatroom id $check1');
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom.ChatRoomId)
          .collection('messages')
          .doc(newMessage.messageId)
          .set(newMessage.toMap())
          .onError((error, stackTrace) {
        log('line 168');
      });

      widget.chatRoom.lastMessage = what;
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom.ChatRoomId)
          .set(widget.chatRoom.toMap());

      widget.chatRoom.latest = rightNow;
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom.ChatRoomId)
          .set(widget.chatRoom.toMap())
          .then((value) {
        log('chaat room updated with time --> $rightNow');
      });
    }

    if (what!.isNotEmpty) {
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        sender: widget.userModel.uid,
        createdOn: rightNow,
        text: what,
        isPhoto: photo,
        seen: false,
      );
      String check1 = widget.chatRoom.ChatRoomId.toString();
      log('test check 1.1');
      log('chatroom id $check1');
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom.ChatRoomId)
          .collection('messages')
          .doc(newMessage.messageId)
          .set(newMessage.toMap())
          .onError((error, stackTrace) {
        log('line 168');
      });

      widget.chatRoom.lastMessage = what;
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom.ChatRoomId)
          .set(widget.chatRoom.toMap());

      widget.chatRoom.latest = rightNow;
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom.ChatRoomId)
          .set(widget.chatRoom.toMap())
          .then((value) {
        log('chaat room updated with time --> $rightNow');
      });
    } else {
      log('empty text field');
    }
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
      compressQuality: 25,
    );
    if (croppedImage != null) {
      sendMessage(true, null, File(croppedImage.path));
    }
  }
}

Row photoFrame(String url, bool me) {
  return Row(
    mainAxisAlignment: me ? MainAxisAlignment.end : MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
              color: me
                  ? StandardColorLibrary.kColor1
                  : StandardColorLibrary.kColor8,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  height: 200,
                  width: 200,
                  image: NetworkImage(url),
                ),
              ],
            ),
          ),
        ),
      )
    ],
  );
}
