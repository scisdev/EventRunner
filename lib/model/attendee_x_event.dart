import 'package:event_runner/model/model.dart';

class AttendeeXEvent extends Persistable {
  final int profileId;
  final int eventId;

  AttendeeXEvent({
    int? id,
    required this.profileId,
    required this.eventId,
  }) : super(id);

  factory AttendeeXEvent.fromJson(Map<String, dynamic> json) {
    return AttendeeXEvent(
      id: json['id'],
      profileId: json['profileId'],
      eventId: json['eventId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileId': profileId,
      'eventId': eventId,
    };
  }

  @override
  Persistable withId(int id) {
    return AttendeeXEvent(
      id: id,
      profileId: profileId,
      eventId: eventId,
    );
  }
}
