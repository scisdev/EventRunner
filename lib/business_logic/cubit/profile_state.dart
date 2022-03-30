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

enum ProfileStateStatus { loading, done }

extension ProfileStateStatusX on ProfileStateStatus {
  bool get isLoading => this == ProfileStateStatus.loading;
  bool get isDone => this == ProfileStateStatus.done;
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
}
