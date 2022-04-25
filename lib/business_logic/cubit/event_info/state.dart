import 'package:event_runner/model/model.dart';

abstract class EventInfo {}

class EventInfoInit extends EventInfo {}

class EventInfoLoading extends EventInfo {}

class EventInfoSuccess extends EventInfo {
  final List<Profile> attendants;

  EventInfoSuccess(this.attendants);
}

class EventInfoFailure extends EventInfo {
  final String desc;

  EventInfoFailure(this.desc);
}
