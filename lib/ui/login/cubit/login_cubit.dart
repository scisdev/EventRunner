import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:event_runner/model/model.dart';
import 'package:event_runner/ui/login/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

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

    final p = ProfileDatabase.profiles;
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

class ProfileDatabase {
  static List<Profile> get profiles {
    return <Profile>[
      Profile(
        id: 1,
        avatarUrl:
            'https://s3-alpha-sig.figma.com/img/107f/5287/e86e14365cff904eed8a8f6525d2c452?Expires=1649030400&Signature=ASgVnHNr4QGJkyIK8KXgzIwl4D2J6rdzloF-X3KNBphFNgzMD5Ryv2HocgnffUgwMAKf1TwJoVSiXwPfv7IeQYjVqxnrJQ~pn0qIOreSqUM2ixG6CHz-xMtQmP8DbyKfYEQ81SZblnThFSsq~pFjy2SB-d3k~oULsM7m5NYVM0OZjog3eOzSj-jUytI1MxDpOJNWMMihWrFhSOV3eLZ8ZgcYTKbhfUdpW-lA-HEm43TpyH8V3vYnoQCCVF1~~GeqYmc00ED~wvYL3eXkZ9HE6YmapnyUsob-bE-OhUHGXvA-MBcaEss1dehPghlslpDFAYp6qLLwcj~7ojMHWbY5fw__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
        displayName: 'Иван Гаврилов',
        email: 'ivan_gavr@gmail.com',
        passwordHash:
            'cc0781950ffebec65a7f552e099f5111dc6526384615f13801e3f0d25b38e960',
      ),
      Profile(
        id: 2,
        avatarUrl:
            'https://s3-alpha-sig.figma.com/img/59c5/af5a/420947edd30baa36d1478d8056544550?Expires=1649030400&Signature=gTE0VMlcX-DYE6UUidMlCEG1HcTDBtGePQ5MkMjmxDx5XBbXIt0XiNA0X8utUPK3LCEZA~IaSnm7k1Y1MkxDzJZKUhCUbOMfT8Eu2FgA0dIEioQ9Hr8rBleNmol-E42UiJteg4-FkrxpT17qq2CA2RTWm1ep9ow8DFEyuZAMixBO-tuLSlRm0fzqA5QrFvoxClJ4dzp1YzIGPrMSEuBf46l7gm7ERKcD0LuyaiZ83NwYUfcGsBeSzDCdpdL7NLwMpYfNDJ49hdRRPTWqFQdwXZRfdxFIjWolcIOKkYi4Y0c8mHGuJBez7cNUaFHlzJIcIZEom9v9MzueTe7lfGu~6Q__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
        displayName: 'Лиза Сафронова',
        email: 'lisafr@gmail.com',
        passwordHash:
            '7ab7ca688b42d7edb92fda5fc6d7394e2cc4a19a441a06360183dbd2b06a5fb9',
      ),
      Profile(
        id: 3,
        avatarUrl:
            'https://s3-alpha-sig.figma.com/img/c4ff/ddcb/a7672b3682faba963ee3336b868dbbda?Expires=1649030400&Signature=SFE9WWAoGgYaKErzaPLdccEbCaN85ki31PP6VNH3z3ZbH5bA2y5yzRSDhD2bwL7sHLSafFGD-FTx15oEFCO3OR9K6hGZA8YYKFpWRBPm5gXIXBK4elJp4hYXRq3kvMUne1BnX2bclwm5qhUn3ICbBdBmFUwXrIDjNAjTfaJTDEkj0TaEPjJrQKqfsO2WLaSpdGPeDOS3uaj2FT9eJeVNforL68qtVs8VSjDZgtDnstETfA1aA1Eew8YvXZ072Dlan5rqk1ozEo~sM5u1-NVdWBK2zuCAr34tnUKwo2N8nrl1m5JsJ~GFkPbhmPrfO9vLwhFyTdk7KEEODibDvHZfEQ__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
        displayName: 'Елена Шибаева',
        email: 'shibaeva@gmail.com',
        passwordHash:
            'eefc879116de9c05b9074ba6080c204fcdce03a63e51727b1f6d1764023779a1',
      ),
      Profile(
        id: 3,
        avatarUrl:
            'https://s3-alpha-sig.figma.com/img/68ed/fd8f/996efc95b29e6188126e22ac66b0430a?Expires=1649030400&Signature=hB7RprX0iOjhKklYco4fhiUZxteoMwmL-~~Y0aasSvNWSlNSZkFFzOgUnO3npJTuoqWefNJFQZTsuLp61kYXMPK5BGt~D~HnNCAmssvGZhGTcxxWMqjvgavZRIZ6STEYn1JqR6h2mXBm5lYf44xYdfYwabAtkA2DGa0eMsIV7X6A0d2RVHiv7rJLypMXXrtM2vXtUb-YMZwpUaX92oR~e1djWRie5cniBIXRqRh1ahPHRKR46usqX3TDxifDLAQ7br717dC38-~jGfczd5FpGbsGobEKCTPqD5VC2yyZ7QYYWu6f-CvPNMCMcCCrf8u6sIeO8KXO8EQbvTIKd6OiUA__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
        displayName: 'Дима Ковчегов',
        email: 'shibaeva@gmail.com',
        passwordHash:
            'f70f501efb87d20ada0214119ebfe3931c025f41b2c41a26a8bd4b252fb68852',
      ),
    ];
  }
}

class UserNotFoundException with Exception {}
