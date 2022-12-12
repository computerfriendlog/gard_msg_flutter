class GaurdRequest {
  String? user_id;
  String? from_date;
  String? to_date;
  String? start_time;
  String? end_time;
  String? bg_color;
  String? approval_status;
  String? label;

  GaurdRequest(
      {this.user_id,
      this.from_date,
      this.to_date,
      this.start_time,
      this.bg_color,
      this.end_time,
      this.approval_status,
      this.label});

  factory GaurdRequest.fromJson(Map<String, dynamic> json) {
    return GaurdRequest(
      user_id: json['user_id'] as String ?? '',
      from_date: json['from_date'] as String ?? '',
      to_date: json['to_date'] as String ?? '',
      start_time: json['start_time'] as String ?? '',
      end_time: json['end_time'] as String ?? '',
      bg_color: json['bg_color'] as String ?? '',
      approval_status: json['approval_status'] as String ?? '',
      label: json['label'] as String ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = user_id;
    data['from_date'] = from_date;
    data['to_date'] = to_date;
    data['start_time'] = start_time;
    data['end_time'] = end_time;
    data['bg_color'] = bg_color;
    data['approval_status'] = approval_status;
    data['label'] = label;
    return data;
  }
}
