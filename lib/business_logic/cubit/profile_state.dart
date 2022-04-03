import 'package:event_runner/model/model.dart';

class ProfileInfo {
  final List<Event> createdEvents;
  final List<Event> attendedEvents;
  final List<Achievement> achievements;

  ProfileInfo({
    required this.createdEvents,
    required this.attendedEvents,
    required this.achievements,
  });
}

enum ProfileStateStatus { init, loading, success, failure }

extension ProfileStateStatusX on ProfileStateStatus {
  bool get isLoading => this == ProfileStateStatus.loading;
  bool get isSuccess => this == ProfileStateStatus.success;
  bool get isFailure => this == ProfileStateStatus.failure;
}

class ProfileState {
  final Profile currentUser;
  final ProfileInfo? profileInfo;
  final ProfileStateStatus status;

  ProfileState({
    required this.currentUser,
    required this.profileInfo,
    required this.status,
  });

  ProfileState withInfo(ProfileInfo? info) {
    return ProfileState(
      currentUser: currentUser,
      profileInfo: info,
      status: status,
    );
  }

  ProfileState withStatus(ProfileStateStatus status) {
    return ProfileState(
      currentUser: currentUser,
      profileInfo: profileInfo,
      status: status,
    );
  }
}
