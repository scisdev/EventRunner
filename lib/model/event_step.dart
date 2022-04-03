import 'package:event_runner/model/model.dart';

class EventStep extends Persistable {
  final int eventId;
  final String name;
  final String desc;

  EventStep({
    required int id,
    required this.eventId,
    required this.name,
    required this.desc,
  }) : super(id);

  factory EventStep.fromJson(Map<String, dynamic> json) {
    return EventStep(
      id: json['id'],
      eventId: json['eventId'],
      name: json['name'],
      desc: json['desc'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'name': name,
      'desc': desc,
    };
  }

  @override
  Persistable withId(int id) {
    return EventStep(
      id: id,
      eventId: eventId,
      name: name,
      desc: desc,
    );
  }
}
