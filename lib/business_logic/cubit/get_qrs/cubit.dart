import 'package:event_runner/business_logic/api/.api.dart';
import 'package:event_runner/model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class GetQrCubit extends Cubit<GetQrState> {
  final GetQrApi _api;

  GetQrCubit(this._api) : super(GetQrInit());

  void getQrs(Event event) async {
    if (state is GetQrLoading) return;
    emit(GetQrLoading());
    await Future.delayed(const Duration(seconds: 2));

    final res = await _api.getQrs(event);
    emit(res.success ? GetQrSuccess(res.data) : GetQrFailure(res.error));
  }
}
