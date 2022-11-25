class CheckPoint {
  String? check_point_id;
  String? job_id;
  String? guard_id;
  String? name;
  String? time;
  String? status;
  String? barcode;

  CheckPoint(
      {this.check_point_id,
      this.job_id,
      this.guard_id,
      this.name,
      this.barcode,
      this.status,
      this.time});

  factory CheckPoint.fromJson(Map<String, dynamic> json) {
    return CheckPoint(
      check_point_id: json['check_point_id'] as String ?? '',
      job_id: json['job_id'] as String ?? '',
      guard_id: json['guard_id'] as String ?? '',
      name: json['name'] as String ?? '',
      time: json['time'] as String ?? '',
      status: json['status'] as String ?? '',
      barcode: json['barcode'] as String ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['check_point_id'] = check_point_id;
    data['job_id'] = job_id;
    data['guard_id'] = guard_id;
    data['name'] = name;

    data['time'] = time;
    data['status'] = status;
    data['barcode'] = barcode;
    return data;
  }
}
