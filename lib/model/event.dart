import 'package:event_runner/model/model.dart';
import 'package:event_runner/util/theme.dart';

class Event {
  final int id;
  final Profile creator;
  final String name;
  final String desc;
  final String type;
  final DateTime startTime;
  final String duration;
  final String posterUrl;
  final QrUsage qrUsage;

  Event({
    required this.id,
    required this.creator,
    required this.name,
    required this.desc,
    required this.type,
    required this.startTime,
    required this.duration,
    required this.posterUrl,
    required this.qrUsage,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      creator: Profile.fromJson(json['creator']),
      duration: json['duration'],
      type: json['type'],
      posterUrl: json['posterUrl'],
      startTime: DateTime.parse(json['startTime']),
      qrUsage: (json['qrUsage'] as String).toQrUsage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'creator': creator.toJson(),
      'duration': duration,
      'type': type,
      'posterUrl': posterUrl,
      'startTime': startTime.toIso8601String(),
      'qrUsage': qrUsage.toDisplayString,
    };
  }

  Event withId(int id) {
    return Event(
      id: id,
      name: name,
      desc: desc,
      creator: creator,
      type: type,
      duration: duration,
      startTime: startTime,
      qrUsage: qrUsage,
      posterUrl: posterUrl,
    );
  }
}
