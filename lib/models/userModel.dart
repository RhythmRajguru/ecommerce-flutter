class UserModel{
  final String? uId;
  final String? username;
  final String? email;
  final String? phone;
  final String? userImg;
  final String? userDeviceToken;
  final String? country;
  final String? city;
  final String? userAddress;
  final String? street;
  final bool? isAdmin;
  final bool? isActive;
  final dynamic? createdOn;

  UserModel({required this.uId,required this.username,required this.email,required this.phone,required this.userImg,
    required this.userDeviceToken,required this.country,required this.city, this.userAddress,required this.street,
    required this.isAdmin,required this.isActive,required this.createdOn});

  Map<String,dynamic> toMap(){
    return {
      "uId":uId,
      "username":username,
      "email":email,
      "phone":phone,
      "userImg":userImg,
      "userDeviceToken":userDeviceToken,
      "country":country,
      "city":city,
      "userAddress":userAddress,
      "street":street,
      "isAdmin":isAdmin,
      "isActive":isActive,
      "createdOn":createdOn,
    };
  }
  factory UserModel.fromMap(Map<String,dynamic> json){
    return UserModel(
        uId: json['uId'],
        username: json['username'],
        email: json['email'],
        phone: json['phone'],
        userImg: json['userImg'],
        userDeviceToken: json['userDeviceToken'],
        country: json['country'],
        city: json['city'],
        userAddress: json['userAddress'],
        street: json['street'],
        isAdmin: json['isAdmin'],
        isActive: json['isActive'],
        createdOn: json['createdOn'].toString());
  }

}
