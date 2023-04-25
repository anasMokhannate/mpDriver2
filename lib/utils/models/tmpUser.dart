// ignore_for_file: file_names, non_constant_identifier_names

class TmpUser {
  String email;
  String phoneNo;
  String password;
  String type_account;

  TmpUser({
    required this.email,
    required this.phoneNo,
    required this.password,
    required this.type_account,
  });

  factory TmpUser.fromJson(Map<String, dynamic> json) {
    return TmpUser(
      email: json['email'],
      phoneNo: json['phoneNo'],
      password: json['password'],
      type_account: json['type_account'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'phoneNo': phoneNo,
        'password': password,
        'type_account': type_account,
      };
}
