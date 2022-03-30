import 'package:event_runner/model/model.dart';

class Event {
  final int id;
  final int creatorId;
  final List<int> attendeeIds;
  final List<int> achievementIds;
  final String name;
  final String desc;
  final String type;
  final DateTime startTime;
  final String duration;
  final String posterUrl;
  final QrUsage qrUsage;
  final EventState state;

  Event({
    required this.id,
    required this.creatorId,
    required this.attendeeIds,
    required this.achievementIds,
    required this.name,
    required this.desc,
    required this.type,
    required this.startTime,
    required this.duration,
    required this.posterUrl,
    required this.qrUsage,
    required this.state,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      creatorId: json['creatorId'],
      attendeeIds: (json['attendeeIds'] as List).map((e) => e as int).toList(),
      achievementIds:
          (json['achievementIds'] as List).map((e) => e as int).toList(),
      duration: json['duration'],
      type: json['type'],
      posterUrl: json['posterUrl'],
      startTime: DateTime.parse(json['startTime']),
      qrUsage: (json['qrUsage'] as String).toQrUsage,
      state: (json['state'] as String).toState,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'creatorId': creatorId,
      'attendeeIds': attendeeIds,
      'achievementIds': achievementIds,
      'duration': duration,
      'type': type,
      'posterUrl': posterUrl,
      'startTime': startTime.toIso8601String(),
      'qrUsage': qrUsage.toDisplayString,
      'state': state.toDisplayString,
    };
  }

  Event withId(int id) {
    return Event(
      id: id,
      name: name,
      desc: desc,
      creatorId: creatorId,
      attendeeIds: attendeeIds,
      achievementIds: achievementIds,
      type: type,
      duration: duration,
      startTime: startTime,
      qrUsage: qrUsage,
      posterUrl: posterUrl,
      state: state,
    );
  }
}
