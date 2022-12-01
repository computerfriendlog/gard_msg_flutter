class Visitor {
  String? company;
  String? name;
  String? vehicle_reg;
  String? visit_purpose;
  String? time_in;
  String? time_out;
  String? log_date;

  Visitor(
      {this.company,
      this.name,
      this.vehicle_reg,
      this.visit_purpose,
      this.time_out,
      this.time_in,
      this.log_date});

  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      company: json['company'] as String ?? '',
      name: json['name'] as String ?? '',
      vehicle_reg: json['vehicle_reg'] as String ?? '',
      visit_purpose: json['visit_purpose'] as String ?? '',
      time_in: json['time_in'] as String ?? '',
      time_out: json['time_out'] as String ?? '',
      log_date: json['log_date'] as String ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company'] = company;
    data['name'] = name;
    data['vehicle_reg'] = vehicle_reg;
    data['visit_purpose'] = visit_purpose;
    data['time_in'] = time_in;
    data['time_out'] = time_out;
    data['log_date'] = log_date;
    return data;
  }
}
