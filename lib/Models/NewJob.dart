class NewJob {
  String? job_date;
  String? no_of_hours;
  String? fare;
  String? start_time;
  String? end_time;
  String? job_end_date;
  String? sites;
  String? latitude;
  String? longitude;
  String? job_id;
  String? restriction_check;
  String? name;
  String? customer_id;
  String? mobile;
  String? job_status;
  String? time_check;
  int? check_point_count;
  int? visitors_log_count;
  int? incidents_count;

  NewJob(
      {this.job_date,
      this.no_of_hours,
      this.fare,
      this.start_time,
      this.end_time,
      this.longitude,
      this.latitude,
      this.name,
      this.check_point_count,
      this.customer_id,
      this.incidents_count,
      this.job_end_date,
      this.job_id,
      this.job_status,
      this.mobile,
      this.restriction_check,
      this.sites,
      this.time_check,
      this.visitors_log_count});

  factory NewJob.fromJson(Map<String, dynamic> json) {
    return NewJob(
      job_date: json['job_date'] as String ?? '',
      no_of_hours: json['no_of_hours'] as String ?? '',
      fare: json['fare'] as String ?? '',
      end_time: json['end_time'] as String ?? '',
      longitude: json['longitude']  as String ?? '0.12222',
      latitude: json['latitude']  as String ?? '0.1222',
      name: json['name'] as String ?? '',
      check_point_count: json['check_point_count'] ?? 0,
      customer_id: json['customer_id'] ?? 0,
      incidents_count: json['incidents_count'] ?? 0,
      job_end_date: json['job_end_date'] as String ?? '',
      job_id: json['job_id']  as String ?? '0',
      job_status: json['job_status'] as String ?? '',
      mobile: json['mobile'] as String ?? '',
      restriction_check: json['restriction_check'] as String ?? '0',
      sites: json['sites'] as String ?? '',
      time_check: json['time_check']  as String?? '0',
      visitors_log_count: json['visitors_log_count']  ?? 0,
      start_time: json['start_time'] as String ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['job_date'] = job_date;
    data['no_of_hours'] = no_of_hours;
    data['fare'] = fare;
    data['end_time'] = end_time;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['name'] = name;
    data['check_point_count'] = check_point_count;
    data['customer_id'] = customer_id;
    data['incidents_count'] = incidents_count;
    data['job_end_date'] = job_end_date;
    data['job_id'] = job_id;
    data['job_status'] = job_status;
    data['mobile'] = mobile;
    data['restriction_check'] = restriction_check;
    data['sites'] = sites;
    data['time_check'] = time_check;
    data['start_time'] = start_time;
    data['visitors_log_count'] = visitors_log_count;
    return data;
  }
}
