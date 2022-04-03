import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:event_runner/business_logic/cubit/cubit.dart';
import 'package:event_runner/model/model.dart';
import 'package:event_runner/ui/login/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final Database _db;

  LoginCubit(this._db) : super(LoginInitial());

  void tryLogin(String mail, String pass) async {
    emit(LoginLoading());

    try {
      emit(LoginSuccess(
        await getProfileFromDB(
          mail,
          getPasswordHash(pass),
        ),
      ));
    } on UserNotFoundException catch (_) {
      emit(LoginError(
        'Пользователь не найден! Проверьте введённые данные!',
      ));
    } catch (_) {
      emit(LoginError(
        'Ошибка при коммуникации с сервером!',
      ));
    }
  }

  String getPasswordHash(String pass) {
    final encoded = utf8.encode(pass);
    return sha256.convert(encoded).toString();
  }

  Future<Profile> getProfileFromDB(String mail, String passHash) async {
    await Future.delayed(const Duration(seconds: 2)); // emulate http

    final p = await _db.profiles.getAll();
    final i = p.indexWhere(
      (p) => p.email == mail && p.passwordHash == passHash,
    );

    if (i == -1) {
      throw UserNotFoundException();
    } else {
      return p[i];
    }
  }
}

class UserNotFoundException with Exception {}
