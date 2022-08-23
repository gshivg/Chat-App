// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:chat_app_asper/main.dart';
import 'package:chat_app_asper/models/chat_room_model.dart';
import 'package:chat_app_asper/screens/chat_room_screen.dart';
import 'package:chat_app_asper/utils/constant.dart';
import 'package:chat_app_asper/utils/reusable_test_fiels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_asper/models/user_model.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const SearchPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Search',
          style: TextStyle(
            color: StandardColorLibrary.kColor1,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: StandardColorLibrary.kColor4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: StandardColorLibrary.kColor4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              reusableTextField1('display', _searchController, false,
                  Icons.search_rounded, TextInputType.text),
              const SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {});
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
                    'Search',
                    style: TextStyle(
                      color: StandardColorLibrary.kColor6,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: _searchController.text)
                    .where('email', isNotEqualTo: widget.userModel.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;

                      if (dataSnapshot.docs.isNotEmpty) {
                        Map<String, dynamic> userMap =
                            dataSnapshot.docs[0].data() as Map<String, dynamic>;

                        UserModel searchedUser = UserModel.fromMap(userMap);

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(searchedUser.profilePic!),
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text(
                            searchedUser.fullName.toString(),
                            style: const TextStyle(
                              color: StandardColorLibrary.kColor6,
                            ),
                          ),
                          subtitle: Text(
                            searchedUser.email.toString(),
                            style: const TextStyle(
                              color: StandardColorLibrary.kColor6,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.keyboard_arrow_right,
                            color: StandardColorLibrary.kColor6,
                          ),
                          onTap: (() async {
                            ChatRoomModel? chatroom =
                                await getChatRoomMOdel(searchedUser);
                            if (chatroom != null) {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => ChatRoom(
                                        chatRoom: chatroom,
                                        targetUser: searchedUser,
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser,
                                      )),
                                ),
                              );
                            }
                          }),
                        );
                      } else {
                        return const Text(
                          'No results Found',
                          style: TextStyle(
                            color: StandardColorLibrary.kColor6,
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return const Text(
                        'An Error has occured',
                        style: TextStyle(
                          color: StandardColorLibrary.kColor6,
                        ),
                      );
                    } else {
                      return const Text(
                        'No results Found',
                        style: TextStyle(
                          color: StandardColorLibrary.kColor6,
                        ),
                      );
                    }
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSimpleSnackbar(BuildContext context, String title, String message) {
    Flushbar(
      duration: const Duration(seconds: 3),
      title: title,
      message: message,
      titleColor: StandardColorLibrary.kColor6,
      messageColor: StandardColorLibrary.kColor6,
      backgroundColor: StandardColorLibrary.kColor5,
    ).show(context);
  }

  Future<ChatRoomModel?> getChatRoomMOdel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('participants.${widget.userModel.uid}', isEqualTo: true)
        .where('participants.${targetUser.uid}', isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Fetch existing room
      log('chat room exists');

      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatRoom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = existingChatRoom;
      String check1 = existingChatRoom.ChatRoomId.toString();

      log('test check 3');
      log('existing chatroom id $check1');
    } else {
      // create new room
      log('chat room does not exist');
      ChatRoomModel newChatRoom = ChatRoomModel(
          ChatRoomId: uuid.v1(),
          lastMessage: '',
          latest: DateTime.now(),
          participants: {
            widget.userModel.uid.toString(): true,
            targetUser.uid.toString(): true,
          });

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(newChatRoom.ChatRoomId)
          .set(newChatRoom.toMap());

      log('new chatroom created');

      chatRoom = newChatRoom;
      String check1 = newChatRoom.ChatRoomId.toString();

      log('test check 1');
      log('new chatroom id $check1');
    }
    String check1 = chatRoom.ChatRoomId.toString();

    log('test check 2');
    log('chatroom id $check1');
    log('chat room returned');

    return chatRoom;
  }
}
