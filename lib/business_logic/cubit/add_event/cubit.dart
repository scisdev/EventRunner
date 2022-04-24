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
    emit(AddEventLoading());
    await Future.delayed(const Duration(seconds: 3));
    emit(AddEventSuccess(Event(
      id: 3,
      type: 'Музыка',
      name: 'Концерт местной панк-группы',
      duration: '> 60 минут',
      creatorId: 3,
      desc: 'Слушаем поп-панк местного разлива и бухаем. Этож панк!',
      posterUrl: 'https://vpodryad.ru/upload/000/u1/1/6/60b57c1c.jpg',
      qrUsage: QrUsage.onlyIn,
      startTime: DateTime(2022, 1, 10),
      state: EventState.planned,
    )));
    /*if (state is AddEventLoading) return;
    emit(AddEventLoading());

    final res = await _api.addEvent(event, steps, achievements);
    emit(
      res.success ? AddEventSuccess(res.data) : AddEventFailure(res.error),
    );*/
  }
}
