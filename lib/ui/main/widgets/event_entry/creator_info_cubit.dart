import 'package:event_runner/business_logic/cubit/cubit.dart';
import 'package:event_runner/model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CreatorInfoState {}

class CILoading extends CreatorInfoState {}

class CISuccess extends CreatorInfoState {
  final Profile profile;

  CISuccess(this.profile);
}

class CIFailure extends CreatorInfoState {}

class CICubit extends Cubit<CreatorInfoState> {
  final int creatorId;
  final Database _db;

  CICubit(this._db, {required this.creatorId}) : super(CILoading()) {
    getInfo();
  }

  void getInfo() async {
    try {
      emit(CISuccess(await _db.getProfileById(creatorId)));
    } catch (_) {
      emit(CIFailure());
    }
  }
}
