class UserModel {
  String? uid;
  String? email;
  String? fullName;
  String? profilePic;

  UserModel({this.email, this.fullName, this.profilePic, this.uid});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    fullName = map['fullName'];
    email = map['email'];
    profilePic = map['profilePic'];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullName": fullName,
      "email": email,
      "profilePic": profilePic,
    };
  }
}
