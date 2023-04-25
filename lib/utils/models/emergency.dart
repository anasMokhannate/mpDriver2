class Emergency {
  String user;
  double latitude;
  double longitude;
  String city;
  String phone;

  Emergency({
    required this.user,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'user': user,
        'latitude': latitude,
        'longitude': longitude,
        'city': city,
        'phone': phone,
      };
}
