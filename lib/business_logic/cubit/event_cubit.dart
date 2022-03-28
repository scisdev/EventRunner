import 'package:bloc/bloc.dart';
import 'package:event_runner/model/model.dart';
import 'cubit.dart';

class EventCubit extends Cubit<EventState> {
  final Database _db;
  EventCubit(this._db)
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

  void selectFilter(String? filter) {
    emit(state.withCategory(filter));
  }

  Future<List<Event>> _getFromDatabase() async {
    await Future.delayed(const Duration(seconds: 2));
    return await _db.getEvents();
  }
}
