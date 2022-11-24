class User {
  String? name;
  String? office;
  String? device_id;
  String? password;

  User({this.name, this.office, this.device_id, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String ?? '',
      office: json['office'] as String ?? '',
      device_id: json['device_id'] as String ?? '',
      password: json['password'] as String ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['office'] = office;
    data['device_id'] = device_id;
    data['password'] = password;
    return data;
  }
}
