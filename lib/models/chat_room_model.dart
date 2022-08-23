// ignore_for_file: non_constant_identifier_names

class ChatRoomModel {
  String? ChatRoomId;
  Map<String, dynamic>? participants;
  String? lastMessage;
 late DateTime latest;
  ChatRoomModel({this.ChatRoomId, this.participants, this.lastMessage, required this.latest});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    ChatRoomId = map['ChatRoomId'];
    participants = map['participants'];
    lastMessage = map['lastMessage'];
    latest = map['latest'].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "ChatRoomId": ChatRoomId,
      "participants": participants,
      "lastMessage": lastMessage,
      "latest": latest,
    };
  }
}
