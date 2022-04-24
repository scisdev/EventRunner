import 'package:event_runner/model/model.dart';

class Event extends Persistable {
  final int creatorId;
  final String name;
  final String desc;
  final String type;
  final DateTime startTime;
  final String duration;
  final String posterUrl;
  final QrUsage qrUsage;
  final EventState state;

  Event({
    int? id,
    required this.creatorId,
    required this.name,
    required this.desc,
    required this.type,
    required this.startTime,
    required this.duration,
    required this.posterUrl,
    required this.qrUsage,
    required this.state,
  }) : super(id);

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      creatorId: json['creatorId'],
      duration: json['duration'],
      type: json['type'],
      posterUrl: json['posterUrl'],
      startTime: DateTime.parse(json['startTime']),
      qrUsage: (json['qrUsage'] as String).toQrUsage,
      state: (json['state'] as String).toState,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'creatorId': creatorId,
      'duration': duration,
      'type': type,
      'posterUrl': posterUrl,
      'startTime': startTime.toIso8601String(),
      'qrUsage': qrUsage.toDisplayString,
      'state': state.toDisplayString,
    };
  }

  @override
  Event withId(int id) {
    return Event(
      id: id,
      name: name,
      desc: desc,
      creatorId: creatorId,
      type: type,
      duration: duration,
      startTime: startTime,
      qrUsage: qrUsage,
      posterUrl: posterUrl,
      state: state,
    );
  }
}
