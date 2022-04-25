import 'package:event_runner/model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic.dart' hide EventState;

class EventInfoCubit extends Cubit<EventInfo> {
  final Event event;
  final EventInfoApi _api;

  EventInfoCubit(this._api, {required this.event}) : super(EventInfoInit());

  void getAttendants() async {
    if (state is EventInfoLoading) return;
    emit(EventInfoLoading());

    final res = await _api.getAttendants(event);
    emit(
      res.success ? EventInfoSuccess(res.data) : EventInfoFailure(res.error),
    );
  }
}
