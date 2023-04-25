// ignore_for_file: non_constant_identifier_names, file_names

class MotoType {
  double facteur;
  int valeur_applicable;
  String name;
  double price_par_km;
  double price_par_min;

  MotoType({
    required this.facteur,
    required this.valeur_applicable,
    required this.name,
    required this.price_par_km,
    required this.price_par_min,
  });

  factory MotoType.fromJson(Map<String, dynamic> json) {
    return MotoType(
      facteur: double.parse(json['Facteur']),
      valeur_applicable: json['Valeur_applicable'],
      name: json['name'],
      price_par_km: double.parse(json['price_par_km']),
      price_par_min: double.parse(json['price_par_min']),
    );
  }

  Map<String, dynamic> toJson() => {
        'facteur': facteur,
        'value_applicable': valeur_applicable,
        'name': name,
        'price_par_km': price_par_km,
        'price_par_min': price_par_min,
      };
}
