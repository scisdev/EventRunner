import 'package:bloc/bloc.dart';
import 'package:event_runner/model/model.dart';
import 'cubit.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit()
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
    return EventDatabase.events;
  }
}

class EventDatabase {
  static List<Event> get events {
    return [
      Event(
        id: 1,
        type: 'Спорт',
        name: 'Марафон',
        duration: '~ 60 минут',
        creator: Profile(
          id: 1,
          avatarUrl:
              'https://s3-alpha-sig.figma.com/img/107f/5287/e86e14365cff904eed8a8f6525d2c452?Expires=1649030400&Signature=ASgVnHNr4QGJkyIK8KXgzIwl4D2J6rdzloF-X3KNBphFNgzMD5Ryv2HocgnffUgwMAKf1TwJoVSiXwPfv7IeQYjVqxnrJQ~pn0qIOreSqUM2ixG6CHz-xMtQmP8DbyKfYEQ81SZblnThFSsq~pFjy2SB-d3k~oULsM7m5NYVM0OZjog3eOzSj-jUytI1MxDpOJNWMMihWrFhSOV3eLZ8ZgcYTKbhfUdpW-lA-HEm43TpyH8V3vYnoQCCVF1~~GeqYmc00ED~wvYL3eXkZ9HE6YmapnyUsob-bE-OhUHGXvA-MBcaEss1dehPghlslpDFAYp6qLLwcj~7ojMHWbY5fw__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
          displayName: 'Иван Гаврилов',
          email: 'ivan_gavr@gmail.com',
          passwordHash: 'hash1',
        ),
        desc: 'Бежим марафон',
        posterUrl:
            'https://s3-alpha-sig.figma.com/img/cae3/c133/2d065694ff000487e091d9f0383817cf?Expires=1649030400&Signature=UOVHUXWw659oxBiXz96Ha6k2f3yE~djxkOhyb-ePbJg7uC~z592uTuoe0Fx~OM3t2ISK52cBlr3qQH6eQraAyr8rzCJ06TnGy1h8-AJcDVtX2x2go1hkS35bCHBe6vKSo7P7ebCkfjO9JwdYSVIG0GBdXx-Y0iJ2d2Uma87nWIT20cWqOvfUxFOxBXH4dPVHM4mqLI75Cb5gno7ERAbuG5DCpgOecB0M1eSKhwdDZNx7dBuYFDhqC88CgfYpLTQVqsqZUBsA4ClnhmNkDEzOiXKAgcdMMc-PDGepw1vaj~-baAdOHJQOl~lPMVbK3126NL2YNdBU9l~nXr8rrvULkg__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
        qrUsage: QrUsage.onlyIn,
        startTime: DateTime(2022, 1, 10),
      ),
      Event(
        id: 2,
        type: 'Квест',
        name: 'Поиск предметов',
        duration: '~ 45 минут',
        creator: Profile(
          id: 2,
          avatarUrl:
              'https://s3-alpha-sig.figma.com/img/59c5/af5a/420947edd30baa36d1478d8056544550?Expires=1649030400&Signature=gTE0VMlcX-DYE6UUidMlCEG1HcTDBtGePQ5MkMjmxDx5XBbXIt0XiNA0X8utUPK3LCEZA~IaSnm7k1Y1MkxDzJZKUhCUbOMfT8Eu2FgA0dIEioQ9Hr8rBleNmol-E42UiJteg4-FkrxpT17qq2CA2RTWm1ep9ow8DFEyuZAMixBO-tuLSlRm0fzqA5QrFvoxClJ4dzp1YzIGPrMSEuBf46l7gm7ERKcD0LuyaiZ83NwYUfcGsBeSzDCdpdL7NLwMpYfNDJ49hdRRPTWqFQdwXZRfdxFIjWolcIOKkYi4Y0c8mHGuJBez7cNUaFHlzJIcIZEom9v9MzueTe7lfGu~6Q__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
          displayName: 'Лиза Сафронова',
          email: 'lisafr@gmail.com',
          passwordHash: 'hash2',
        ),
        desc: 'Ищем предметы',
        posterUrl:
            'https://s3-alpha-sig.figma.com/img/8712/af32/f805ed1cbcc8f92e37a47d4c4e2c38e8?Expires=1649030400&Signature=HKgVbFn76xne6pp6Y-7XwoHCLNZkY4hSc769TJEEMcYuKCG-L6YonzRn5ZSQFnpJFjit3GNa88wy5YQFKwUd785cwbPbdx3eTo4UtF0pcPQwtHViKTr6-l0fK73cpWHLnFzSYeGwlBlbOmovH543zhVMwI32m7UON-V4qsr7yvW358RDOB7Lnzdy78xZwB4TJRGHMuJxpT2Iw8Ev4Y2Dbqjno7weygkkrnnpme~Yr1JYOxMpQFSdKlMMuVnX2rZwuV5VqqvKo1JKAr7jdmTTL0qHSAKSj0G1HrOqeDBo~WRpnUa8ihNquKWa5FpBQ2Q79gGgY1mqTWNcsa6xeCUl5A__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
        qrUsage: QrUsage.onlyIn,
        startTime: DateTime(2022, 1, 10),
      ),
      Event(
        id: 3,
        type: 'Музыка',
        name: 'Концерт местной панк-группы',
        duration: '> 60 минут',
        creator: Profile(
          id: 3,
          avatarUrl:
              'https://s3-alpha-sig.figma.com/img/c4ff/ddcb/a7672b3682faba963ee3336b868dbbda?Expires=1649030400&Signature=SFE9WWAoGgYaKErzaPLdccEbCaN85ki31PP6VNH3z3ZbH5bA2y5yzRSDhD2bwL7sHLSafFGD-FTx15oEFCO3OR9K6hGZA8YYKFpWRBPm5gXIXBK4elJp4hYXRq3kvMUne1BnX2bclwm5qhUn3ICbBdBmFUwXrIDjNAjTfaJTDEkj0TaEPjJrQKqfsO2WLaSpdGPeDOS3uaj2FT9eJeVNforL68qtVs8VSjDZgtDnstETfA1aA1Eew8YvXZ072Dlan5rqk1ozEo~sM5u1-NVdWBK2zuCAr34tnUKwo2N8nrl1m5JsJ~GFkPbhmPrfO9vLwhFyTdk7KEEODibDvHZfEQ__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
          displayName: 'Елена Шибаева',
          email: 'shibaeva@gmail.com',
          passwordHash: 'hash2',
        ),
        desc: 'Слушаем поп-панк местного разлива и бухаем. Этож панк!',
        posterUrl: 'https://vpodryad.ru/upload/000/u1/1/6/60b57c1c.jpg',
        qrUsage: QrUsage.onlyIn,
        startTime: DateTime(2022, 1, 10),
      ),
      Event(
        id: 3,
        type: 'Политика',
        name: 'Обсуждения, зачем нужна сменяемость власти',
        duration: '~45 минут',
        creator: Profile(
          id: 3,
          avatarUrl:
              'https://s3-alpha-sig.figma.com/img/68ed/fd8f/996efc95b29e6188126e22ac66b0430a?Expires=1649030400&Signature=hB7RprX0iOjhKklYco4fhiUZxteoMwmL-~~Y0aasSvNWSlNSZkFFzOgUnO3npJTuoqWefNJFQZTsuLp61kYXMPK5BGt~D~HnNCAmssvGZhGTcxxWMqjvgavZRIZ6STEYn1JqR6h2mXBm5lYf44xYdfYwabAtkA2DGa0eMsIV7X6A0d2RVHiv7rJLypMXXrtM2vXtUb-YMZwpUaX92oR~e1djWRie5cniBIXRqRh1ahPHRKR46usqX3TDxifDLAQ7br717dC38-~jGfczd5FpGbsGobEKCTPqD5VC2yyZ7QYYWu6f-CvPNMCMcCCrf8u6sIeO8KXO8EQbvTIKd6OiUA__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
          displayName: 'Дима Ковчегов',
          email: 'shibaeva@gmail.com',
          passwordHash: 'hash2',
        ),
        desc:
            'Показываем на примере конкретных стран, зачем нужно менять президентов',
        posterUrl:
            'https://www.idea.int/sites/default/files/Initiatives/2018-Theme-Money-in-Politics.png',
        qrUsage: QrUsage.onlyIn,
        startTime: DateTime(2022, 1, 10),
      ),
    ];
  }
}
