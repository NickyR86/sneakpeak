class UserModel {
  final String username;
  final String displayName;
  final String email;
  final String password;
  final String phone;
  final String address;
  final String gender;         
  final String imagePath;

  UserModel({
    required this.username,
     required this.displayName,
    required this.email,
    required this.password,
    required this.gender,      
    this.phone = 'Phone number not set',
    this.address = 'Address not set',
    required this.imagePath,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      displayName: json['displayName'] ?? json['username'],
      email: json['email'],
      password: json['password'],
      gender: json['gender'], 
      phone: json['phone'] ?? 'Phone number not set',
      address: json['address'] ?? 'Address not set',
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'displayName': displayName,
      'email': email,
      'password': password,
      'gender': gender,
      'phone': phone,
      'address': address,
      'imagePath': imagePath,
    };
  }
}


