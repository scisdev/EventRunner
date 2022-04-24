import 'package:bloc/bloc.dart';
import 'package:event_runner/business_logic/api/get_events_api.dart';
import 'package:event_runner/model/model.dart' hide EventState;
import 'state.dart';

class EventCubit extends Cubit<EventState> {
  final GetEventsApi _api;
  EventCubit(this._api)
      : super(EventState(
          filterCategory: null,
          events: const [],
          status: EventStateStatus.loading,
        ));

  void load() async {
    emit(state.withStatus(EventStateStatus.loading));

    try {
      emit(
        state
            .withEvents(await _getFromDatabase())
            .withStatus(EventStateStatus.success),
      );
    } catch (_) {
      emit(state.withStatus(EventStateStatus.error));
    }
  }

  void refresh() {
    emit(state.withEvents(const []));
    load();
  }

  void selectFilter(String? filter) {
    emit(state.withCategory(filter));
  }

  Future<List<Event>> _getFromDatabase() async {
    return (await _api.getEvents()).data;
  }
}
