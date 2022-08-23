class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  bool? isPhoto;
  late DateTime createdOn;

  MessageModel(
      {this.messageId,
      required this.createdOn,
      this.isPhoto,
      this.seen,
      this.sender,
      this.text});

  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map['sender'];
    text = map['text'];
    seen = map['seen'];
    createdOn = map['createdOn'].toDate();
    messageId = map['messageId'];
    isPhoto = map['isPhoto'];
  }
  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "text": text,
      "createdOn": createdOn,
      "seen": seen,
      "messageId": messageId,
      "isPhoto": isPhoto,
    };
  }
}
