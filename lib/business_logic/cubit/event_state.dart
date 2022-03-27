import 'package:event_runner/model/model.dart';

enum EventStateStatus {
  loading,
  error,
  success,
}

class EventState {
  final EventStateStatus status;
  final String? filterCategory;
  final List<Event> events;

  EventState({
    required this.status,
    required this.filterCategory,
    required this.events,
  });

  EventState withCategory(String? filterCategory) {
    return EventState(
      status: status,
      events: events,
      filterCategory: filterCategory,
    );
  }

  EventState withStatus(EventStateStatus status) {
    return EventState(
      status: status,
      events: events,
      filterCategory: filterCategory,
    );
  }

  EventState withEvents(List<Event> events) {
    return EventState(
      status: status,
      events: events,
      filterCategory: filterCategory,
    );
  }
}
