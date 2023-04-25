// ignore_for_file: non_constant_identifier_names

class Order {
  String customer_uid;
  String driver_uid;
  int order_type;
  String order_city;
  Map order_pickup_location;
  String order_pickup_time;
  String order_arrival_time;
  Map order_arrival_location;
  String order_destinataire_phone;
  String order_comments;
  double order_purchase_amount;
  bool is_planned;
  String order_moto_type;
  String nbre_km_depart_destination;
  String nbre_km_parcourus;
  String waiting_time_before_order;
  String waiting_time_after_order;
  String comment_about_driver;
  String comment_about_customer;
  int customer_given_stars;
  int driver_given_stars;
  bool is_reported_by_customer;
  bool is_reported_by_driver;
  String report_reason_customer;
  String report_reason_driver;
  bool is_canceled_by_customer;
  bool is_canceled_by_driver;
  String customer_cancellation_reason;
  String driver_cancellation_reason;
  int nbre_tentaives;
  String majoration;

  Order({
    required this.customer_uid,
    required this.driver_uid,
    required this.order_type,
    required this.order_city,
    required this.order_pickup_location,
    required this.order_pickup_time,
    required this.order_arrival_time,
    required this.order_arrival_location,
    required this.order_destinataire_phone,
    required this.order_comments,
    required this.order_purchase_amount,
    required this.is_planned,
    required this.order_moto_type,
    required this.nbre_km_depart_destination,
    required this.nbre_km_parcourus,
    required this.waiting_time_before_order,
    required this.waiting_time_after_order,
    required this.comment_about_driver,
    required this.comment_about_customer,
    required this.customer_given_stars,
    required this.driver_given_stars,
    required this.is_reported_by_customer,
    required this.is_reported_by_driver,
    required this.report_reason_customer,
    required this.report_reason_driver,
    required this.is_canceled_by_customer,
    required this.is_canceled_by_driver,
    required this.customer_cancellation_reason,
    required this.driver_cancellation_reason,
    required this.nbre_tentaives,
    required this.majoration,
  });

  Map<String, dynamic> toJson() => {
        'customer_uid': customer_uid,
        'driver_uid': driver_uid,
        'order_type': order_type,
        'order_city': order_city,
        'order_pickup_location': order_pickup_location,
        'order_pickup_time': order_pickup_time,
        'order_arrival_time': order_arrival_time,
        'order_arrival_location': order_arrival_location,
        'order_destinataire_phone': order_destinataire_phone,
        'order_comments': order_comments,
        'order_purchase_amount': order_purchase_amount,
        'is_planned': is_planned,
        'order_moto_type': order_moto_type,
        'nbre_km_depart_destination': nbre_km_depart_destination,
        'nbre_km_parcourus': nbre_km_parcourus,
        'waiting_time_before_order': waiting_time_before_order,
        'waiting_time_after_order': waiting_time_after_order,
        'comment_about_driver': comment_about_driver,
        'comment_about_customer': comment_about_customer,
        'customer_given_stars': customer_given_stars,
        'driver_given_stars': driver_given_stars,
        'is_reported_by_customer': is_reported_by_customer,
        'is_reported_by_driver': is_reported_by_driver,
        'report_reason_customer': report_reason_customer,
        'report_reason_driver': report_reason_driver,
        'is_canceled_by_customer': is_canceled_by_customer,
        'is_canceled_by_driver': is_canceled_by_driver,
        'customer_cancellation_reason': customer_cancellation_reason,
        'driver_cancellation_reason': driver_cancellation_reason,
        'nbre_tentaives': nbre_tentaives,
        'majoration': majoration,
      };
}
