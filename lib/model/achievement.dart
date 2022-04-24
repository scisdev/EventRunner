import 'package:event_runner/model/model.dart';

class Achievement extends Persistable {
  final int eventId;
  final String name;
  final String desc;

  Achievement({
    int? id,
    required this.eventId,
    required this.name,
    required this.desc,
  }) : super(id);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'name': name,
      'desc': desc,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      eventId: json['eventId'],
      name: json['name'],
      desc: json['desc'],
    );
  }

  @override
  Persistable withId(int id) {
    return Achievement(
      id: id,
      eventId: eventId,
      name: name,
      desc: desc,
    );
  }
}
