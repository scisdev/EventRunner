import 'package:event_runner/model/model.dart';

class StepXUser extends Persistable {
  final int profileId;
  final int stepId;

  StepXUser({
    required int id,
    required this.profileId,
    required this.stepId,
  }) : super(id);

  factory StepXUser.fromJson(Map<String, dynamic> json) {
    return StepXUser(
      id: json['id'],
      profileId: json['profileId'],
      stepId: json['stepId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileId': profileId,
      'stepId': stepId,
    };
  }

  @override
  Persistable withId(int id) {
    return StepXUser(
      id: id,
      profileId: profileId,
      stepId: stepId,
    );
  }
}
