// ignore_for_file: file_names

class UserAddressModel {
  final String address;
  final String latitude;
  final String longitude;
  final String uid;
  final String name;
  final String phoneNumber;
  UserAddressModel({
    required this.phoneNumber,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.uid
  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'phoneNumber' : phoneNumber,
      'name' : name,
      'uid' : uid,
      'address' : address,
      'longitude' : longitude,
      'latitude' : latitude
    };
  }

  // Create a UserModel instance from a JSON map
  factory UserAddressModel.fromMap(Map<String, dynamic> json) {
    return UserAddressModel(
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      uid: json['uid'],
        address: json['address'],
        latitude: json['latitude'],
        longitude: json['longitude'],
    );
  }
}