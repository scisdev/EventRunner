import 'package:event_runner/model/model.dart';

class AchievementXOwner extends Persistable {
  final int achId;
  final int ownerId;
  final DateTime receivedAt;

  AchievementXOwner({
    required int id,
    required this.achId,
    required this.ownerId,
    required this.receivedAt,
  }) : super(id);

  factory AchievementXOwner.fromJson(Map<String, dynamic> json) {
    return AchievementXOwner(
      id: json['id'],
      achId: json['achId'],
      ownerId: json['ownerId'],
      receivedAt: DateTime.parse(json['receivedAt']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'achId': achId,
      'ownerId': ownerId,
      'receivedAt': receivedAt,
    };
  }

  @override
  Persistable withId(int id) {
    return AchievementXOwner(
      id: id,
      achId: achId,
      ownerId: ownerId,
      receivedAt: receivedAt,
    );
  }
}
