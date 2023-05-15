// // ignore_for_file: non_constant_identifier_names

// class Order {
//   String customer_uid;
//   String driver_uid;
//   int order_type;
//   String order_city;
//   Map order_pickup_location;
//   String order_pickup_time;
//   String order_arrival_time;
//   Map order_arrival_location;
//   String order_destinataire_phone;
//   String order_comments;
//   double order_purchase_amount;
//   bool is_planned;
//   String order_moto_type;
//   String nbre_km_depart_destination;
//   String nbre_km_parcourus;
//   String waiting_time_before_order;
//   String waiting_time_after_order;
//   String comment_about_driver;
//   String comment_about_customer;
//   int customer_given_stars;
//   int driver_given_stars;
//   bool is_reported_by_customer;
//   bool is_reported_by_driver;
//   String report_reason_customer;
//   String report_reason_driver;
//   bool is_canceled_by_customer;
//   bool is_canceled_by_driver;
//   String customer_cancellation_reason;
//   String driver_cancellation_reason;
//   int nbre_tentaives;
//   String majoration;

//   Order({
//     required this.customer_uid,
//     required this.driver_uid,
//     required this.order_type,
//     required this.order_city,
//     required this.order_pickup_location,
//     required this.order_pickup_time,
//     required this.order_arrival_time,
//     required this.order_arrival_location,
//     required this.order_destinataire_phone,
//     required this.order_comments,
//     required this.order_purchase_amount,
//     required this.is_planned,
//     required this.order_moto_type,
//     required this.nbre_km_depart_destination,
//     required this.nbre_km_parcourus,
//     required this.waiting_time_before_order,
//     required this.waiting_time_after_order,
//     required this.comment_about_driver,
//     required this.comment_about_customer,
//     required this.customer_given_stars,
//     required this.driver_given_stars,
//     required this.is_reported_by_customer,
//     required this.is_reported_by_driver,
//     required this.report_reason_customer,
//     required this.report_reason_driver,
//     required this.is_canceled_by_customer,
//     required this.is_canceled_by_driver,
//     required this.customer_cancellation_reason,
//     required this.driver_cancellation_reason,
//     required this.nbre_tentaives,
//     required this.majoration,
//   });

//   Map<String, dynamic> toJson() => {
//         'customer_uid': customer_uid,
//         'driver_uid': driver_uid,
//         'order_type': order_type,
//         'order_city': order_city,
//         'order_pickup_location': order_pickup_location,
//         'order_pickup_time': order_pickup_time,
//         'order_arrival_time': order_arrival_time,
//         'order_arrival_location': order_arrival_location,
//         'order_destinataire_phone': order_destinataire_phone,
//         'order_comments': order_comments,
//         'order_purchase_amount': order_purchase_amount,
//         'is_planned': is_planned,
//         'order_moto_type': order_moto_type,
//         'nbre_km_depart_destination': nbre_km_depart_destination,
//         'nbre_km_parcourus': nbre_km_parcourus,
//         'waiting_time_before_order': waiting_time_before_order,
//         'waiting_time_after_order': waiting_time_after_order,
//         'comment_about_driver': comment_about_driver,
//         'comment_about_customer': comment_about_customer,
//         'customer_given_stars': customer_given_stars,
//         'driver_given_stars': driver_given_stars,
//         'is_reported_by_customer': is_reported_by_customer,
//         'is_reported_by_driver': is_reported_by_driver,
//         'report_reason_customer': report_reason_customer,
//         'report_reason_driver': report_reason_driver,
//         'is_canceled_by_customer': is_canceled_by_customer,
//         'is_canceled_by_driver': is_canceled_by_driver,
//         'customer_cancellation_reason': customer_cancellation_reason,
//         'driver_cancellation_reason': driver_cancellation_reason,
//         'nbre_tentaives': nbre_tentaives,
//         'majoration': majoration,
//       };
// }

class Order {
  String? orderId;
  int? orderType;
  String? orderCity;
  Map<String, dynamic>? orderPickupLocation;
  String? orderPickupTime;
  String? orderArrivalTime;
  Map<String, dynamic>? orderArrivalLocation;
  String? orderComments;
  double? orderPurchaseAmount;
  bool? isPlanned;
  String? orderMotoType;
  String? nbreKmDepartDestination;
  String? nbreKmParcourus;
  String? waitingTimeBeforeOrder;
  String? waitingTimeAfterOrder;
  String? commentAboutDriver;
  String? commentAboutCustomer;
  String? addressFrom;
  String? addressTo;
  int? customerGivenStars;
  int? driverGivenStars;
  bool? isReportedByCustomer;
  bool? isReportedByDriver;
  String? reportReasonCustomer;
  String? reportReasonDriver;
  bool? isCanceledByCustomer;
  bool? isCanceledByDriver;
  String? customerCancellationReason;
  String? driverCancellationReason;
  int? nbreTentaives;
  Map<String, dynamic>? customer;
  Map<String, dynamic>? driver;
  double kmRadius;
  List<dynamic>? driversAccepted;
  List<dynamic>? driversDeclined;
  // bool? isStart;
  // bool? isHere;
  // bool? isSucceded;

  String? status;
  String? createdAt;

  Order({
    this.orderId,
    this.orderType,
    this.orderCity,
    this.orderPickupLocation,
    this.orderPickupTime,
    this.orderArrivalTime,
    this.orderArrivalLocation,
    this.orderComments,
    this.orderPurchaseAmount,
    this.isPlanned,
    this.orderMotoType,
    this.nbreKmDepartDestination,
    this.nbreKmParcourus,
    this.waitingTimeBeforeOrder,
    this.waitingTimeAfterOrder,
    this.commentAboutDriver,
    this.commentAboutCustomer,
    this.addressFrom,
    this.addressTo,
    this.customerGivenStars,
    this.driverGivenStars,
    this.isReportedByCustomer,
    this.isReportedByDriver,
    this.reportReasonCustomer,
    this.reportReasonDriver,
    this.isCanceledByCustomer,
    this.isCanceledByDriver,
    this.customerCancellationReason,
    this.driverCancellationReason,
    this.nbreTentaives,
    this.customer,
    this.driver,
    this.kmRadius = 0.0,
    
    this.driversAccepted,
    this.driversDeclined,
    // 
    this.status,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'],
      orderType: json['order_type'],
      orderCity: json['order_city'],
      orderPickupLocation: json['order_pickup_location'],
      orderPickupTime: json['order_pickup_time'],
      orderArrivalTime: json['order_arrival_time'],
      orderArrivalLocation: json['order_arrival_location'],
      orderComments: json['order_comments'],
      orderPurchaseAmount: json['order_purchase_amount'],
      isPlanned: json['is_planned'],
      orderMotoType: json['order_moto_type'],
      nbreKmDepartDestination: json['nbre_km_depart_destination'],
      nbreKmParcourus: json['nbre_km_parcourus'],
      waitingTimeBeforeOrder: json['waiting_time_before_order'],
      waitingTimeAfterOrder: json['waiting_time_after_order'],
      commentAboutDriver: json['comment_about_driver'],
      commentAboutCustomer: json['comment_about_customer'],
      addressFrom: json['address_from'],
      addressTo: json['address_to'],
      customerGivenStars: json['customer_given_stars'],
      driverGivenStars: json['driver_given_stars'],
      isReportedByCustomer: json['is_reported_by_customer'],
      isReportedByDriver: json['is_reported_by_driver'],
      reportReasonCustomer: json['report_reason_customer'],
      reportReasonDriver: json['report_reason_driver'],
      isCanceledByCustomer: json['is_canceled_by_customer'],
      isCanceledByDriver: json['is_canceled_by_driver'],
      customerCancellationReason: json['customer_cancellation_reason'],
      driverCancellationReason: json['driver_cancellation_reason'],
      nbreTentaives: json['nbre_tentaives'],
      customer: json['customer'],
      driver: json['driver'],
      kmRadius: json['km_radius'],
      status: json['status'],
      driversAccepted: json['drivers_accepted'],
      driversDeclined: json['drivers_declined'],
      //  isSucceded: json['is_succeded'],
      // isStart: json['is_start'],
      // isHere: json['is_here'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['order_type'] = orderType;
    data['order_city'] = orderCity;
    data['order_pickup_location'] = orderPickupLocation;
    data['order_pickup_time'] = orderPickupTime;
    data['order_arrival_time'] = orderArrivalTime;
    data['order_arrival_location'] = orderArrivalLocation;
    data['order_comments'] = orderComments;
    data['order_purchase_amount'] = orderPurchaseAmount;
    data['is_planned'] = isPlanned;
    data['order_moto_type'] = orderMotoType;
    data['nbre_km_depart_destination'] = nbreKmDepartDestination;
    data['nbre_km_parcourus'] = nbreKmParcourus;
    data['waiting_time_before_order'] = waitingTimeBeforeOrder;
    data['waiting_time_after_order'] = waitingTimeAfterOrder;
    data['comment_about_driver'] = commentAboutDriver;
    data['comment_about_customer'] = commentAboutCustomer;
    data['address_from'] = addressFrom;
    data['address_to'] = addressTo;
    data['customer_given_stars'] = customerGivenStars;
    data['driver_given_stars'] = driverGivenStars;
    data['is_reported_by_customer'] = isReportedByCustomer;
    data['is_reported_by_driver'] = isReportedByDriver;
    data['report_reason_customer'] = reportReasonCustomer;
    data['report_reason_driver'] = reportReasonDriver;
    data['is_canceled_by_customer'] = isCanceledByCustomer;
    data['is_canceled_by_driver'] = isCanceledByDriver;
    data['customer_cancellation_reason'] = customerCancellationReason;
    data['driver_cancellation_reason'] = driverCancellationReason;
    data['nbre_tentaives'] = nbreTentaives;
    data['customer'] = customer;
    data['driver'] = driver;
    data['km_radius'] = kmRadius;
    data['status'] = status;
    data['drivers_accepted'] = driversAccepted;
    data['drivers_declined'] = driversDeclined;
    //  data['is_succeded'] = isSucceded;
    // data['is_start'] = isStart;
    // data['is_here'] = isHere;
    data['created_at'] = createdAt;
    return data;
  }
}
