// ignore_for_file: file_names, non_constant_identifier_names

class UserBase {
  String driver_uid;
  String driver_full_name;
  String driver_email;
  String driver_sexe;
  String driver_type_auth;
  String driver_date_naissance;
  String driver_phone_number;
  String driver_profile_picture;
  String driver_registration_date;
  String driver_last_login_date;
  String driver_current_city;
  double driver_latitude;
  double driver_longitude;
  bool is_deleted_account;
  bool is_activated_account;
  bool is_verified_account;
  bool is_blacklisted_account;
  bool is_online;
  bool is_on_order;
  bool is_password_change;
  int is_driver;
  int driver_cancelled_delivery;
  int driver_succeded_delivery;
  int driver_planned_delivery;
  int driver_cancelled_trip;
  int driver_succeded_trip;
  int driver_planned_trip; 
  double driver_note;
  List driver_motocylces;
  String driver_identity_card_number;
  String driver_identity_card_picture;
  String driver_identity_card_expiration_date;
  String driver_driving_licence_number;
  String driver_driving_licence_picture;
  String driver_driving_licence_expiration_date;
  String driver_order_total_amount;
  String? driver_anthropometrique;
  String? driver_anthropometrique_expiration_date;
  double driver_total_paid;
  String? driver_fcm;
  int driver_total_orders;
  int driver_reported_times;
  String? last_document_update_date;
  String? driver_assurance_picture;
  String? driver_assurance_expiration_date;
  String?driver_grise_picture;
  String?driver_grise_expiration_date;
  UserBase(
      {required this.driver_uid,
      required this.driver_full_name,
      required this.driver_email,
      required this.driver_sexe,
      required this.driver_type_auth,
      required this.driver_date_naissance,
      required this.driver_phone_number,
      required this.driver_profile_picture,
      required this.driver_registration_date,
      required this.driver_last_login_date,
      required this.driver_current_city,
      required this.driver_latitude,
      required this.driver_longitude,
      required this.is_deleted_account,
      required this.is_activated_account,
      required this.is_verified_account,
      required this.is_blacklisted_account,
      required this.is_online,
      required this.is_on_order,
      required this.is_driver,
      required this.is_password_change,
      required this.driver_cancelled_delivery,
      required this.driver_succeded_delivery,
      required this.driver_planned_delivery,
      required this.driver_cancelled_trip,
      required this.driver_succeded_trip,
      required this.driver_planned_trip, 
      required this.driver_note,
      required this.driver_motocylces,
      required this.driver_identity_card_number,
      required this.driver_identity_card_picture,
      required this.driver_identity_card_expiration_date,
      required this.driver_driving_licence_number,
      required this.driver_driving_licence_picture,
      required this.driver_driving_licence_expiration_date,
      required this.driver_order_total_amount,
       this.driver_anthropometrique,
      this.driver_anthropometrique_expiration_date,
      required this.driver_total_paid,
      this.driver_fcm,
      required this.driver_total_orders,
      required this.driver_reported_times,
      this.last_document_update_date,
      this.driver_assurance_expiration_date,
      this.driver_assurance_picture,
      this.driver_grise_expiration_date,
      this.driver_grise_picture
      });

  factory UserBase.fromJson(Map<String, dynamic> json) {
    return UserBase(
      driver_uid: json['driver_uid'],
      driver_full_name: json['driver_full_name'],
      driver_email: json['driver_email'],
      driver_sexe: json['driver_sexe'],
      driver_type_auth: json['driver_type_auth'],
      driver_date_naissance: json['driver_date_naissance'],
      driver_phone_number: json['driver_phone_number'],
      driver_profile_picture: json['driver_profile_picture'],
      driver_registration_date: json['driver_registration_date'],
      driver_last_login_date: json['driver_last_login_date'],
      driver_current_city: json['driver_current_city'],
      driver_latitude: json['driver_latitude'],
      driver_longitude: json['driver_longitude'],
      is_deleted_account: json['is_deleted_account'],
      is_activated_account: json['is_activated_account'],
      is_verified_account: json['is_verified_account'],
      is_blacklisted_account: json['is_blacklisted_account'],
      is_online: json['is_online'],
      is_on_order: json['is_on_order'],
      is_password_change: json['is_password_change'],
      is_driver: json['is_driver'],
      driver_cancelled_delivery: json['driver_cancelled_delivery'],
      driver_succeded_delivery: json['driver_succeded_delivery'],
      driver_planned_delivery: json['driver_planned_delivery'],
      driver_cancelled_trip: json['driver_cancelled_trip'],
      driver_succeded_trip: json['driver_succeded_trip'],
      driver_planned_trip: json['driver_planned_trip'], 
      driver_note: json['driver_note'].toDouble(),
      driver_motocylces: json['driver_motocylces'],
      driver_identity_card_number: json['driver_identity_card_number'],
      driver_identity_card_picture: json['driver_identity_card_picture'],
      driver_identity_card_expiration_date:
          json['driver_identity_card_expiration_date'],
      driver_driving_licence_number: json['driver_driving_licence_number'],
      driver_driving_licence_picture: json['driver_driving_licence_picture'],
      driver_driving_licence_expiration_date:
          json['driver_driving_licence_expiration_date'],
      driver_order_total_amount: json['driver_order_total_amount'],
      driver_anthropometrique: json['driver_anthropometrique'],
      driver_anthropometrique_expiration_date:
          json['driver_anthropometrique_expiration_date'],
      driver_fcm: json['driver_fcm'],
      driver_total_orders: json['driver_total_orders'] ?? 0,
      driver_total_paid: json['driver_total_paid'].toDouble() ?? 0.0,
      driver_reported_times: json['driver_reported_times'] ?? 0,
      last_document_update_date: json['last_document_update_date'] ?? null,
      driver_assurance_expiration_date:
          json['driver_assurance_expiration_date'] ?? null,
      driver_assurance_picture: json['driver_assurance_picture'] ?? null,
      driver_grise_expiration_date: json['driver_grise_expiration_date'] ?? null,
      driver_grise_picture: json['driver_grise_picture'] ?? null,
    );
  }

  Map<String, dynamic> toJson() => {
        'driver_uid': driver_uid,
        'driver_full_name': driver_full_name,
        'driver_email': driver_email,
        'driver_sexe': driver_sexe,
        'driver_type_auth': driver_type_auth,
        'driver_date_naissance': driver_date_naissance,
        'driver_phone_number': driver_phone_number,
        'driver_profile_picture': driver_profile_picture,
        'driver_registration_date': driver_registration_date,
        'driver_last_login_date': driver_last_login_date,
        'driver_current_city': driver_current_city,
        'driver_latitude': driver_latitude,
        'driver_longitude': driver_longitude,
        'is_deleted_account': is_deleted_account,
        'is_activated_account': is_activated_account,
        'is_verified_account': is_verified_account,
        'is_blacklisted_account': is_blacklisted_account,
        'is_online': is_online,
        'is_on_order': is_on_order,
        'is_driver': is_driver,
        'is_password_change': is_password_change,
        'driver_cancelled_delivery': driver_cancelled_delivery,
        'driver_succeded_delivery': driver_succeded_delivery,
        'driver_planned_delivery': driver_planned_delivery,
        'driver_cancelled_trip': driver_cancelled_trip,
        'driver_succeded_trip': driver_succeded_trip,
        'driver_planned_trip': driver_planned_trip, 
        'driver_note': driver_note,
        'driver_motocylces': driver_motocylces,
        'driver_identity_card_number': driver_identity_card_number,
        'driver_identity_card_picture': driver_identity_card_picture,
        'driver_identity_card_expiration_date':
            driver_identity_card_expiration_date,
        'driver_driving_licence_number': driver_driving_licence_number,
        'driver_driving_licence_picture': driver_driving_licence_picture,
        'driver_driving_licence_expiration_date':
            driver_driving_licence_expiration_date,
        'driver_order_total_amount': driver_order_total_amount,
        'driver_anthropometrique': driver_anthropometrique,
        'driver_anthropometrique_expiration_date':
            driver_anthropometrique_expiration_date,
        'driver_fcm': driver_fcm,
        'driver_total_orders': driver_total_orders,
        'driver_total_paid': driver_total_paid,
        'driver_reported_times': driver_reported_times,
        'last_document_update_date': last_document_update_date,
        'driver_assurance_expiration_date': driver_assurance_expiration_date,
        'driver_assurance_picture': driver_assurance_picture,
        'driver_grise_expiration_date': driver_grise_expiration_date,
        'driver_grise_picture': driver_grise_picture,

      };
}
