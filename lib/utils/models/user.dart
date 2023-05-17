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
  int? plannedDelivery;
  int? cancelledTrip;
  int? succededTrip;
  int? plannedTrip;
  double? note;
  //List<MotoType>? mototype;
  List? motos;
  String? identityCardNumber;
  String? identityCardPicture;
  String? identityCardExpirationDate;
  // String? drivingLicenceNumber;
  String? drivingLicencePicture;
  String? drivingLicenceExpirationDate;
  String? assurancePicture;
  String? assuranceExpirationDate;
  String? carteGrisePicture;
  String? carteGriseExpirationDate;
  double? orderTotalAmount;
  String? anthropometrique;
  int? totalOrders;
  int? reportedTimes;
  List? fcmList;
  String? currentOrderDriver;
  String? currentOrderCustomer;
  String? currentPageClient;
  String? currentPageDriver;
  String? authType;
  String? lastDocumentUpdateDate;
  //String? currentOrderId;

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
      this.succededTrip,
      this.plannedTrip = 0,
      this.note,
      //this.mototype,
      this.motos,
      this.identityCardNumber,
      this.identityCardPicture,
      this.identityCardExpirationDate,
      // this.drivingLicenceNumber,
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
      this.lastDocumentUpdateDate,
      this.authType,
      //this.currentOrderId
    });

  factory MpUser.fromJson(Map<String, dynamic>? json) {
    // fullName = json?['full_name'];
    // uid = json?['uid'];
    // email = json?['email'];
    // sexe = json?['sexe'];
    // dateNaissance = json?['date_naissance'];
    // phoneNumber = json?['phone_number'];
    // profilePicture = json?['profile_picture'];
    // registrationDate = json?['registration_date'];
    // lastLoginDate = json?['last_login_date'];
    // currentCity = json?['current_city'];
    // latitude = json?['latitude'];
    // longitude = json?['longitude'];
    // isDeletedAccount = json?['is_deleted_account'];
    // isActivatedAccount = json?['is_activated_account'];
    // isVerifiedAccount = json?['is_verified_account'];
    // isBlacklistedAccount = json?['is_blacklisted_account'];
    // isOnline = json?['is_online'];
    // isOnOrder = json?['is_on_order'];
    // isPasswordChange = json?['is_password_change'];
    // isDriver = json?['is_driver'];
    // cancelledDelivery = json?['cancelled_delivery'];
    // succededDelivery = json?['succeded_delivery'];
    // plannedDelivery = json?['planned_delivery'];
    // cancelledTrip = json?['cancelled_trip'];
    // succededTrip = json?['succeded_trip'];
    // plannedTrip = json?['planned_trip'];
    // note = json?['note'] ?? 0.0;
    // if (json?['mototype'] != null) {
    //   mototype = <MotoType>[];
    //   json?['mototype'].forEach((v) {
    //     mototype!.add(new MotoType.fromJson(v));
    //   });
    // }
    // identityCardNumber = json?['identity_card_number'];
    // identityCardPicture = json?['identity_card_picture'];
    // identityCardExpirationDate = json?['identity_card_expiration_date'];
    // drivingLicenceNumber = json?['driving_licence_number'];
    // drivingLicencePicture = json?['driving_licence_picture'];
    // drivingLicenceExpirationDate = json?['driving_licence_expiration_date'];
    // orderTotalAmount = json?['order_total_amount'];
    // anthropometrique = json?['anthropometrique'];
    // totalOrders = json?['total_orders'];
    // reportedTimes = json?['reported_times'];
    // fcmList = json?['fcmList'];
    // currentOrderDriver = json?['current_order_driver'];
    // currentOrderCustomer = json?['current_order_customer'];
    // currentPageClient = json?['current_page'];
    // authType = json?['auth_type'];
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
        // location: json?['location'] != null
        //     ? GeoPoint(
        //         json?['location']['latitude'],
        //         json?['location']['longitude'],
        //       )
        //     : null,
        isDeletedAccount: json?['is_deleted_account'],
        isActivatedAccount: json?['is_activated_account'],
        isVerifiedAccount: json?['is_verified_account'],
        isBlacklistedAccount: json?['is_blacklisted_account'],
        isOnline: json?['is_online'], 
        isPasswordChange: json?['is_password_change'],
        isDriver: json?['is_driver'],
        cancelledDelivery: json?['cancelled_delivery'],
        succededDelivery: json?['succeded_delivery'],
        plannedDelivery: json?['planned_delivery'],
        cancelledTrip: json?['cancelled_trip'],
        succededTrip: json?['succeded_trip'],
        plannedTrip: json?['planned_trip'],
        note: json?['note'] ?? 0.0,
        // mototype: json?['mototype'] != null
        //     ? (json?['mototype'] as List)
        //         .map((i) => MotoType.fromJson(i))
        //         .toList()
        //     : null,
        motos: json?['motos'],
        identityCardNumber: json?['identity_card_number'],
        identityCardPicture: json?['identity_card_picture'],
        identityCardExpirationDate: json?['identity_card_expiration_date'],
        // drivingLicenceNumber: json?['driving_licence_number'],
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
        lastDocumentUpdateDate: json?['last_document_update_date'],
        authType: json?['auth_type']);
        //currentOrderId: json?['current_order_id']);
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
    // if (location != null) {
    //   data['location'] = {
    //     'latitude': location!.latitude,
    //     'longitude': location!.longitude,
    //   };
    // }
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
    data['note'] = note ?? 0.0;
    // if (mototype != null) {
    //   data['mototype'] = mototype!.map((v) => v.toJson()).toList();
    // }
    data['motos'] = motos;
    data['identity_card_number'] = identityCardNumber;
    data['identity_card_picture'] = identityCardPicture;
    data['identity_card_expiration_date'] = identityCardExpirationDate;
    data['current_page_client'] = currentPageClient;
    data['current_page_driver'] = currentPageDriver;
    data['auth_type'] = authType;
    // data['driving_licence_number'] = drivingLicenceNumber;
    data['driving_licence_picture'] = drivingLicencePicture;
    data['driving_licence_expiration_date'] = drivingLicenceExpirationDate;
    data['order_total_amount'] = orderTotalAmount;
    data['anthropometrique'] = anthropometrique;
    data['total_orders'] = totalOrders;
    data['reported_times'] = reportedTimes;
    data['fcmList'] = fcmList;
    data['current_order_driver'] = currentOrderDriver;
    data['current_order_customer'] = currentOrderCustomer;
    data['identity_card_number'] = identityCardNumber;
    data['identity_card_picture'] = identityCardPicture;
    data['identity_card_expiration_date'] = identityCardExpirationDate;
    // data['driving_licence_number'] = drivingLicenceNumber;
    data['driving_licence_picture'] = drivingLicencePicture;
    data['driving_licence_expiration_date'] = drivingLicenceExpirationDate;
    data['order_total_amount'] = orderTotalAmount;
    data['anthropometrique'] = anthropometrique;
    data['total_orders'] = totalOrders;
    data['reported_times'] = reportedTimes;
    data['fcmList'] = fcmList;
    data['current_order_driver'] = currentOrderDriver;
    data['current_order_customer'] = currentOrderCustomer;
    data['last_document_update_date'] = lastDocumentUpdateDate;
    // data['current_order_id'] = currentOrderId;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
