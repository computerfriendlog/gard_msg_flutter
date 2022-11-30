import 'package:flutter/material.dart';

class Incident {
  String? id;
  String? name;
  String? incident_type;
  String? notes;
  String? logged_by;
  String? job_id;

  Incident(
      {this.id,
      this.name,
      this.incident_type,
      this.notes,
      this.job_id,
      this.logged_by});

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'] as String ?? '',
      name: json['name'] as String ?? '',
      incident_type: json['incident_type'] as String ?? '',
      notes: json['notes'] as String ?? '',
      logged_by: json['logged_by'] as String ?? '',
      job_id: json['job_id'] as String ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['incident_type'] = incident_type;
    data['notes'] = notes;
    data['logged_by'] = logged_by;
    data['job_id'] = job_id;
    return data;
  }
}
