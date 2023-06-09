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
  Map<String, dynamic>? location;
  bool? isDeletedAccount;
  bool? isActivatedAccount;
  bool? isVerifiedAccount;
  bool? isBlacklistedAccount;
  bool? isOnline;
  bool? isPasswordChange;
  bool? isDriver;
  int? cancelledDelivery;
  int? succededDelivery;
  int plannedDelivery;
  int? cancelledTrip;
  int? succededTrip;
  int plannedTrip;
  double? customerNote;
  List? motos;
  String? identityCardNumber;
  String? identityCardPicture;
  String? identityCardExpirationDate;
  String? drivingLicencePicture;
  String? drivingLicenceExpirationDate;
  String? assurancePicture;
  String? assuranceExpirationDate;
  String? carteGrisePicture;
  String? carteGriseExpirationDate;
  double? orderTotalAmount;
  String? anthropometrique;
  int? reportedTimes;
  String? fcm;
  String? currentOrderDriver;
  String? currentOrderCustomer;
  String? currentPageClient;
  String? currentPageDriver;
  String? authType;
  String? lastDocumentUpdateDate;
  int? customerTotalOrders;

  int? customerTotalPaid;
  int? driverTotalPaid;
  int? driverTotalOrders;

  double? driverNote;

  MpUser({
    this.fullName,
    this.uid,
    this.email,
    this.sexe,
    this.dateNaissance,
    this.phoneNumber,
    this.profilePicture,
    this.registrationDate,
    this.lastLoginDate,
    this.currentCity,
    this.location,
    this.isDeletedAccount,
    this.isActivatedAccount,
    this.isVerifiedAccount,
    this.isBlacklistedAccount,
    this.isOnline,
    this.isPasswordChange,
    this.isDriver,
    this.cancelledDelivery,
    this.succededDelivery,
    this.plannedDelivery = 0,
    this.cancelledTrip = 0,
    this.succededTrip = 0,
    this.plannedTrip = 0,
    this.customerNote = 0,
    this.motos,
    this.identityCardNumber,
    this.identityCardPicture,
    this.identityCardExpirationDate,
    this.drivingLicencePicture,
    this.drivingLicenceExpirationDate,
    this.assurancePicture,
    this.assuranceExpirationDate,
    this.carteGrisePicture,
    this.carteGriseExpirationDate,
    this.orderTotalAmount,
    this.anthropometrique,
    this.reportedTimes,
    this.fcm,
    this.currentOrderDriver,
    this.currentOrderCustomer,
    this.currentPageClient,
    this.currentPageDriver,
    this.lastDocumentUpdateDate,
    this.authType,
    this.customerTotalOrders = 0,
    this.customerTotalPaid = 0,
    this.driverTotalPaid = 0,
    this.driverTotalOrders = 0,
    this.driverNote = 0,
  });

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
      location: json?['location'],
      isDeletedAccount: json?['is_deleted_account'],
      isActivatedAccount: json?['is_activated_account'],
      isVerifiedAccount: json?['is_verified_account'],
      isBlacklistedAccount: json?['is_blacklisted_account'],
      isOnline: json?['is_online'],
      isPasswordChange: json?['is_password_change'],
      isDriver: json?['is_driver'],
      cancelledDelivery: json?['cancelled_delivery'],
      succededDelivery: json?['succeded_delivery'],
      plannedDelivery: json?['planned_delivery'] ?? 0,
      cancelledTrip: json?['cancelled_trip'],
      succededTrip: json?['succeded_trip'],
      plannedTrip: json?['planned_trip'] ?? 0,
      customerNote: json?['customer_note']?.toDouble() ?? 0.0,
      motos: json?['motos'],
      identityCardNumber: json?['identity_card_number'],
      identityCardPicture: json?['identity_card_picture'],
      identityCardExpirationDate: json?['identity_card_expiration_date'],
      drivingLicencePicture: json?['driving_licence_picture'],
      drivingLicenceExpirationDate: json?['driving_licence_expiration_date'],
      assurancePicture: json?['assurance_picture'],
      assuranceExpirationDate: json?['assurance_expiration_date'],
      carteGrisePicture: json?['carte_grise_picture'],
      carteGriseExpirationDate: json?['carte_grise_expiration_date'],
      orderTotalAmount: json?['order_total_amount'],
      anthropometrique: json?['anthropometrique'],
      reportedTimes: json?['reported_times'],
      fcm: json?['curr_fcm'],
      currentOrderDriver: json?['current_order_driver'],
      currentOrderCustomer: json?['current_order_customer'],
      currentPageClient: json?['current_page_client'],
      currentPageDriver: json?['current_page_driver'],
      lastDocumentUpdateDate: json?['last_document_update_date'],
      authType: json?['auth_type'],
      customerTotalOrders: json?['customer_total_orders'] ?? 0,
      customerTotalPaid: json?['customer_total_paid']?.toInt() ?? 0,
      driverTotalPaid: json?['driver_total_paid']?.toInt() ?? 0,
      driverTotalOrders: json?['driver_total_orders'] ?? 0,
      driverNote: json?['driver_note'],
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
    data['location'] = location;

    data['is_deleted_account'] = isDeletedAccount;
    data['is_activated_account'] = isActivatedAccount;
    data['is_verified_account'] = isVerifiedAccount;
    data['is_blacklisted_account'] = isBlacklistedAccount;
    data['is_online'] = isOnline;
    data['is_password_change'] = isPasswordChange;
    data['is_driver'] = isDriver;
    data['cancelled_delivery'] = cancelledDelivery;
    data['succeded_delivery'] = succededDelivery;
    data['planned_delivery'] = plannedDelivery;
    data['cancelled_trip'] = cancelledTrip;
    data['succeded_trip'] = succededTrip;
    data['planned_trip'] = plannedTrip;
    data['customer_note'] = customerNote ?? 0.0;

    data['motos'] = motos;
    data['identity_card_number'] = identityCardNumber;
    data['identity_card_picture'] = identityCardPicture;
    data['identity_card_expiration_date'] = identityCardExpirationDate;
    data['current_page_client'] = currentPageClient;
    data['current_page_driver'] = currentPageDriver;
    data['auth_type'] = authType;
    data['driving_licence_picture'] = drivingLicencePicture;
    data['driving_licence_expiration_date'] = drivingLicenceExpirationDate;
    data['order_total_amount'] = orderTotalAmount;
    data['anthropometrique'] = anthropometrique;
    data['reported_times'] = reportedTimes;
    data['curr_fcm'] = fcm;
    data['current_order_driver'] = currentOrderDriver;
    data['current_order_customer'] = currentOrderCustomer;
    data['identity_card_number'] = identityCardNumber;
    data['identity_card_picture'] = identityCardPicture;
    data['identity_card_expiration_date'] = identityCardExpirationDate;
    data['driving_licence_picture'] = drivingLicencePicture;
    data['driving_licence_expiration_date'] = drivingLicenceExpirationDate;
    data['assurance_picture'] = assurancePicture;
    data['assurance_expiration_date'] = assuranceExpirationDate;
    data['carte_grise_picture'] = carteGrisePicture;
    data['carte_grise_expiration_date'] = carteGriseExpirationDate;
    data['order_total_amount'] = orderTotalAmount;
    data['anthropometrique'] = anthropometrique;
    data['reported_times'] = reportedTimes;
    data['curr_fcm'] = fcm;
    data['current_order_driver'] = currentOrderDriver;
    data['current_order_customer'] = currentOrderCustomer;
    data['last_document_update_date'] = lastDocumentUpdateDate;
    data['customer_total_orders'] = customerTotalOrders ?? 0;
    data['customer_total_paid'] = customerTotalPaid;
    data['driver_total_paid'] = driverTotalPaid;
    data['driver_total_orders'] = driverTotalOrders ?? 0;
    data['driver_note'] = driverNote;

    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
