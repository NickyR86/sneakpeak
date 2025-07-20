class UserModel {
  final String username;
  final String email;
  final String password;
  final String? phone;
  final String? address;
  final String gender;         
  final String imagePath;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
    required this.gender,      
    this.phone,
    this.address,
    required this.imagePath,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      gender: json['gender'], 
      phone: json['phone'],
      address: json['address'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'gender': gender,
      'phone': phone,
      'address': address,
      'imagePath': imagePath,
    };
  }
}


