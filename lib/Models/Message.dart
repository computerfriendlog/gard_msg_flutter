import 'package:flutter/material.dart';

class Message {
  String? id;
  String? from_user_id;
  String? from_type;
  String? to_user_id;
  String? to_type;
  String? msg_text;
  String? created;
  String? job_id;
  String? team_id;
  String? voice_msg_file;
  String? read_msg;
  String? device_type;
  String? viewed;
  String? attachment;
  String? date;
  String? type;

  Message(
      {this.id,
      this.from_user_id,
      this.from_type,
      this.to_user_id,
      this.to_type,
      this.team_id,
      this.job_id,
      this.read_msg,
      this.type,
      this.device_type,
      this.msg_text,
      this.attachment,
      this.viewed,
      this.voice_msg_file,
      this.created,
      this.date});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String ?? '',
      from_user_id: json['from_user_id'] as String ?? '',
      from_type: json['from_type'] as String ?? '',
      to_type: json['to_type'] as String ?? '',
      team_id: json['team_id'] as String ?? '0.12222',
      job_id: json['job_id'] as String ?? '0.1222',
      read_msg: json['read_msg'] as String ?? '',
      type: json['type'] ?? 0,
      device_type: json['device_type'] ?? 0,
      msg_text: json['msg_text'] as String ?? '',
      attachment: json['attachment'] as String ?? '',
      viewed: json['viewed'] as String ?? '',
      voice_msg_file: json['voice_msg_file'] as String ?? '0',
      created: json['created'] as String ?? '',
      date: json['date'] as String ?? '0',
      to_user_id: json['to_user_id'] as String ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['from_user_id'] = from_user_id;
    data['from_type'] = from_type;
    data['to_type'] = to_type;
    data['team_id'] = team_id;
    data['job_id'] = job_id;
    data['read_msg'] = read_msg;
    data['type'] = type;
    data['device_type'] = device_type;
    data['msg_text'] = msg_text;
    data['job_id'] = job_id;
    data['attachment'] = attachment;
    data['viewed'] = viewed;
    data['voice_msg_file'] = voice_msg_file;
    data['created'] = created;
    data['date'] = date;
    data['to_user_id'] = to_user_id;
    return data;
  }
}
