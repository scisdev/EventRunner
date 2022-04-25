import 'package:event_runner/model/model.dart';
import 'package:event_runner/ui/add_event/view/view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic.dart' hide EventState;

class AddEventCubit extends Cubit<AddEventState> {
  final AddEventApi _api;

  AddEventCubit(this._api) : super(AddEventInit());

  void addEvent(
    Event event,
    List<String> steps,
    List<LocalAchievement> achievements,
  ) async {
    if (state is AddEventLoading) return;
    emit(AddEventLoading());
    await Future.delayed(const Duration(seconds: 3));
    final res = await _api.addEvent(event, steps, achievements);
    emit(
      res.success ? AddEventSuccess(res.data) : AddEventFailure(res.error),
    );
  }
}
