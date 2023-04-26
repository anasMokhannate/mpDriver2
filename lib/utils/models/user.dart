import 'config-params.dart';
import 'moto.dart';

class MpUser {
  String? fullName;
  String? uid;
  String? email;
  String? sexe;
  String? dateNaissance;
  String? phoneNumber;
  String? profilePicture;
  String? registrationDate;
  String? lastLoginDate;
  String? currentCity;
  double? latitude;
  double? longitude;
  bool? isDeletedAccount;
  bool? isActivatedAccount;
  bool? isVerifiedAccount;
  bool? isBlacklistedAccount;
  bool? isOnline;
  bool? isOnOrder;
  bool? isPasswordChange;
  bool? isDriver;
  int? cancelledDelivery;
  int? succededDelivery;
  int? plannedDelivery;
  int? cancelledTrip;
  int? succededTrip;
  int? plannedTrip;
  double? note;
  List? motos;
  String? identityCardNumber;
  String? identityCardPicture;
  String? identityCardExpirationDate;
  String? drivingLicenceNumber;
  String? drivingLicencePicture;
  String? drivingLicenceExpirationDate;
  String? orderTotalAmount;
  String? anthropometrique;
  int? totalOrders;
  int? reportedTimes;
  List<String>? fcmList;
  String? currentOrderDriver;
  String? currentOrderCustomer;
  String? currentPageClient;
  String? currentPageDriver;
  String? authType;

  MpUser(
      {this.fullName,
      this.uid,
      this.email,
      this.sexe,
      this.dateNaissance,
      this.phoneNumber,
      this.profilePicture,
      this.registrationDate,
      this.lastLoginDate,
      this.currentCity,
      this.latitude,
      this.longitude,
      this.isDeletedAccount,
      this.isActivatedAccount,
      this.isVerifiedAccount,
      this.isBlacklistedAccount,
      this.isOnline,
      this.isOnOrder,
      this.isPasswordChange,
      this.isDriver,
      this.cancelledDelivery,
      this.succededDelivery,
      this.plannedDelivery,
      this.cancelledTrip,
      this.succededTrip,
      this.plannedTrip,
      this.note,
      this.motos,
      this.identityCardNumber,
      this.identityCardPicture,
      this.identityCardExpirationDate,
      this.drivingLicenceNumber,
      this.drivingLicencePicture,
      this.drivingLicenceExpirationDate,
      this.orderTotalAmount,
      this.anthropometrique,
      this.totalOrders,
      this.reportedTimes,
      this.fcmList,
      this.currentOrderDriver,
      this.currentOrderCustomer,
      this.currentPageClient,
      this.currentPageDriver,
      this.authType});

  factory MpUser.fromJson(Map<String, dynamic>? json) {
    return MpUser(
      fullName: json?['full_name'],
      uid: json?['uid'],
      email: json?['email'],
      sexe: json?['sexe'],
      dateNaissance: json?['date_naissance'],
      phoneNumber: json?['phone_number'],
      profilePicture: json?['profile_picture'],
      registrationDate: json?['registration_date'],
      lastLoginDate: json?['last_login_date'],
      currentCity: json?['current_city'],
      latitude: json?['latitude'],
      longitude: json?['longitude'],
      isDeletedAccount: json?['is_deleted_account'],
      isActivatedAccount: json?['is_activated_account'],
      isVerifiedAccount: json?['is_verified_account'],
      isBlacklistedAccount: json?['is_blacklisted_account'],
      isOnline: json?['is_online'],
      isOnOrder: json?['is_on_order'],
      isPasswordChange: json?['is_password_change'],
      isDriver: json?['is_driver'],
      cancelledDelivery: json?['cancelled_delivery'],
      succededDelivery: json?['succeded_delivery'],
      plannedDelivery: json?['planned_delivery'],
      cancelledTrip: json?['cancelled_trip'],
      succededTrip: json?['succeded_trip'],
      plannedTrip: json?['planned_trip'],
      note: json?['note'] ?? 0.0,
      motos: json?['motos'],
      identityCardNumber: json?['identity_card_number'],
      identityCardPicture: json?['identity_card_picture'],
      identityCardExpirationDate: json?['identity_card_expiration_date'],
      drivingLicenceNumber: json?['driving_licence_number'],
      drivingLicencePicture: json?['driving_licence_picture'],
      drivingLicenceExpirationDate: json?['driving_licence_expiration_date'],
      orderTotalAmount: json?['order_total_amount'],
      anthropometrique: json?['anthropometrique'],
      totalOrders: json?['total_orders'],
      reportedTimes: json?['reported_times'],
      fcmList: json?['fcmList'],
      currentOrderDriver: json?['current_order_driver'],
      currentOrderCustomer: json?['current_order_customer'],
      currentPageClient: json?['current_page_client'],
      currentPageDriver: json?['current_page_driver'],
      authType: json?['auth_type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['uid'] = uid;
    data['email'] = email;
    data['sexe'] = sexe;
    data['date_naissance'] = dateNaissance;
    data['phone_number'] = phoneNumber;
    data['profile_picture'] = profilePicture;
    data['registration_date'] = registrationDate;
    data['last_login_date'] = lastLoginDate;
    data['current_city'] = currentCity;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['is_deleted_account'] = isDeletedAccount;
    data['is_activated_account'] = isActivatedAccount;
    data['is_verified_account'] = isVerifiedAccount;
    data['is_blacklisted_account'] = isBlacklistedAccount;
    data['is_online'] = isOnline;
    data['is_on_order'] = isOnOrder;
    data['is_password_change'] = isPasswordChange;
    data['is_driver'] = isDriver;
    data['cancelled_delivery'] = cancelledDelivery;
    data['succeded_delivery'] = succededDelivery;
    data['planned_delivery'] = plannedDelivery;
    data['cancelled_trip'] = cancelledTrip;
    data['succeded_trip'] = succededTrip;
    data['planned_trip'] = plannedTrip;
    data['note'] = note ?? 0.0;
    data['motos'] = motos;
    data['identity_card_number'] = identityCardNumber;
    data['identity_card_picture'] = identityCardPicture;
    data['identity_card_expiration_date'] = identityCardExpirationDate;
    data['driving_licence_number'] = drivingLicenceNumber;
    data['driving_licence_picture'] = drivingLicencePicture;
    data['driving_licence_expiration_date'] = drivingLicenceExpirationDate;
    data['order_total_amount'] = orderTotalAmount;
    data['anthropometrique'] = anthropometrique;
    data['total_orders'] = totalOrders;
    data['reported_times'] = reportedTimes;
    data['fcmList'] = fcmList;
    data['current_order_driver'] = currentOrderDriver;
    data['current_order_customer'] = currentOrderCustomer;
    data['current_page_client'] = currentPageClient;
    data['current_page_driver'] = currentPageDriver;
    data['auth_type'] = authType;
    return data;
  }
  
  @override
  String toString() {
    return toJson.toString();
  }
}
