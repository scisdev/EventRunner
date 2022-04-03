import 'package:event_runner/model/persistable.dart';

class Profile extends Persistable {
  final String email;
  final String passwordHash;
  final String displayName;
  final String avatarUrl;

  Profile({
    required int id,
    required this.email,
    required this.passwordHash,
    required this.displayName,
    required this.avatarUrl,
  }) : super(id);

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      avatarUrl: json['avatarUrl'],
      passwordHash: json['passwordHash'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'passwordHash': passwordHash,
    };
  }

  @override
  Profile withId(int id) {
    return Profile(
      id: id,
      email: email,
      avatarUrl: avatarUrl,
      displayName: displayName,
      passwordHash: passwordHash,
    );
  }
}
