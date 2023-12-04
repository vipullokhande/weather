class UserModel {
  String name;
  String email;
  String bio;
  String createdAt;
  String phoneNumber;
  String uid;
  String profilePic;
  //
  UserModel({
    required this.name,
    required this.email,
    required this.bio,
    required this.createdAt,
    required this.phoneNumber,
    required this.uid,
    required this.profilePic,
  });
  //
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      createdAt: map['createdAt'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }
  //
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
      'createdAt': createdAt,
      'phoneNumber': phoneNumber,
      'uid': uid,
      'profilePic': profilePic
    };
  }
}
