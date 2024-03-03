// ignore_for_file: file_names

class UserData {
  final String uId;
  final String username;
  final String email;
  final String img;

  UserData({
    required this.img,
    required this.uId,
    required this.username,
    required this.email,
  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'username': username,
      'email': email,
      'img' : img
    };
  }

  // Create a UserModel instance from a JSON map
  factory UserData.fromMap(Map<String, dynamic> json) {
    return UserData(
        uId: json['uId'],
        username: json['username'],
        email: json['email'],
      img: json['img']
    );
  }
}