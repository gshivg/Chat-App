import 'dart:developer';

import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/utils/firebase_helper.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:chat_app/utils/constant.dart';
import 'package:chat_app/screens/side_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chat_app/screens/chat_room_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const HomeScreen(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const FaIcon(FontAwesomeIcons.bars),
            color: StandardColorLibrary.kColor1,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'RiskIt',
          style: TextStyle(
            color: StandardColorLibrary.kColor1,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: StandardColorLibrary.kColor4,
      ),
      drawer: NavDrawer(
        context: context,
        userModel: widget.userModel,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: StandardColorLibrary.kColor4,
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chatrooms')
              .where('participants.${widget.userModel.uid}', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              return Container();
            }
            if (snapshot.hasData) {
              QuerySnapshot chatroomSnapshot = snapshot.data as QuerySnapshot;
              List<ChatRoomModel> unorderedList = [];
              for (var element in chatroomSnapshot.docs) {
                ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                    element.data() as Map<String, dynamic>);
                unorderedList.add(chatRoomModel);
              }
              unorderedList.sort((a, b) => b.latest.compareTo(a.latest));
              for (var element in unorderedList) {
                log(element.latest.toString());
              }
              return ListView.builder(
                itemCount: unorderedList.length,
                itemBuilder: (context, index) {
                  ChatRoomModel chatRoomModel = unorderedList[index];
                  Map<String, dynamic> participants =
                      chatRoomModel.participants!;

                  List<String> participantKeys = participants.keys.toList();
                  participantKeys.remove(widget.userModel.uid);

                  return FutureBuilder(
                    future: FirebaseHelper.getUserModelById(participantKeys[0]),
                    builder: (context, userData) {
                      if (userData.connectionState != ConnectionState.done) {
                        return Container();
                      }

                      if (userData.data != null) {
                        UserModel targetUser = userData.data as UserModel;
                        return ListTile(
                          onTap: (() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) {
                                  return ChatRoom(
                                      targetUser: targetUser,
                                      chatRoom: chatRoomModel,
                                      userModel: widget.userModel,
                                      firebaseUser: widget.firebaseUser);
                                }),
                              ),
                            );
                          }),
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                NetworkImage(targetUser.profilePic.toString()),
                          ),
                          title: Text(
                            targetUser.fullName.toString(),
                            style: const TextStyle(
                              color: StandardColorLibrary.kColor6,
                            ),
                          ),
                          subtitle: Text(
                            (chatRoomModel.lastMessage.toString() != '')
                                ? chatRoomModel.lastMessage.toString()
                                : 'Say Hi to this person',
                            style: TextStyle(
                              color:
                                  (chatRoomModel.lastMessage.toString() != '')
                                      ? StandardColorLibrary.kColor6
                                      : StandardColorLibrary.kColor1,
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              log(snapshot.error.toString());
              return const Text(
                'An Error has occured',
                style: TextStyle(
                  color: StandardColorLibrary.kColor6,
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'Click on the search button to\nstart talking to your friends!',
                  style: TextStyle(
                    color: StandardColorLibrary.kColor6,
                  ),
                  textAlign: TextAlign.justify,
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => SearchPage(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser))));
        },
        backgroundColor: StandardColorLibrary.kColor3,
        child: const FaIcon(
          FontAwesomeIcons.magnifyingGlass,
          color: StandardColorLibrary.kColor6,
        ),
      ),
    );
  }
}
