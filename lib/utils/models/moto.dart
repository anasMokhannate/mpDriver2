// ignore_for_file: non_constant_identifier_names

class Moto {
  String? motocycle_brand;
  String? motocycle_model;
  String? motocycle_color;
  String? motocycle_type;
  String? motocycle_imm;
  String? motocycle_photo;
  bool? motocycle_status;

  Moto({
    this.motocycle_brand,
    this.motocycle_model,
    this.motocycle_color,
    this.motocycle_type,
    this.motocycle_imm,
    this.motocycle_photo,
    this.motocycle_status,
  });

  factory Moto.fromJson(Map<String, dynamic> json) {
    return Moto(
      motocycle_brand: json['motocycle_brand'],
      motocycle_model: json['motocycle_model'],
      motocycle_color: json['motocycle_color'],
      motocycle_type: json['motocycle_type'],
      motocycle_imm: json['motocycle_imm'],
      motocycle_photo: json['motocycle_photo'],
      motocycle_status: json['motocycle_status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'motocycle_brand': motocycle_brand,
        'motocycle_model': motocycle_model,
        'motocycle_color': motocycle_color,
        'motocycle_type': motocycle_type,
        'motocycle_imm': motocycle_imm,
        'motocycle_photo': motocycle_photo,
        'motocycle_status': motocycle_status,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
