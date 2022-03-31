import 'dart:convert';

import 'package:event_runner/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();

    final profiles = sp.getString('profiles');
    final events = sp.getString('events');
    final achievements = sp.getString('achs');

    if (profiles == null) {
      await sp.setString(
        'profiles',
        jsonEncode(DefaultProfileList.data.map((e) => e.toJson()).toList()),
      );
    }

    if (events == null) {
      await sp.setString(
        'events',
        jsonEncode(DefaultEventList.data.map((e) => e.toJson()).toList()),
      );
    }

    if (achievements == null) {
      await sp.setString(
        'achs',
        jsonEncode(DefaultEventList.data.map((e) => e.toJson()).toList()),
      );
    }
  }

  Future<void> _persistEvents(List<Event> events) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(
      'events',
      jsonEncode(events.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> _persistProfiles(List<Profile> profiles) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(
      'profiles',
      jsonEncode(profiles.map((e) => e.toJson()).toList()),
    );
  }

  Future<List<Event>> getEvents() async {
    final sp = await SharedPreferences.getInstance();
    return (jsonDecode(sp.getString('events')!) as List)
        .map((e) => Event.fromJson(e))
        .toList(growable: false);
  }

  Future<Event> getEventById(int id) async {
    return (await getEvents()).firstWhere((e) => e.id == id);
  }

  Future<List<Profile>> getProfiles() async {
    final sp = await SharedPreferences.getInstance();
    return (jsonDecode(sp.getString('profiles')!) as List)
        .map((e) => Profile.fromJson(e))
        .toList(growable: false);
  }

  Future<Profile> getProfileById(int id) async {
    return (await getProfiles()).firstWhere((p) => p.id == id);
  }

  Future<void> persistNewEvent(Event event) async {
    final events = await getEvents();
    await _persistEvents(
      [...events, event.withId(events[events.length].id + 1)],
    );
  }

  Future<void> persistNewProfile(Profile profile) async {
    final profiles = await getProfiles();
    await _persistProfiles(
      [...profiles, profile.withId(profiles[profiles.length].id + 1)],
    );
  }

  Future<void> updateEvent(Event event) async {
    final events = await getEvents();
    final ind = events.indexWhere((e) => e.id == event.id);
    if (ind == -1) {
      throw NoSuchElementFoundException();
    }
    events[ind] = event;
    await _persistEvents(events);
  }

  Future<void> updateProfile(Profile profile) async {
    final profiles = await getProfiles();
    final ind = profiles.indexWhere((e) => e.id == profile.id);
    if (ind == -1) {
      throw NoSuchElementFoundException();
    }
    profiles[ind] = profile;
    await _persistProfiles(profiles);
  }
}

class NoSuchElementFoundException with Exception {}

class DefaultProfileList {
  static List<Profile> get data {
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
        id: 4,
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

class DefaultEventList {
  static List<Event> get data {
    return [
      Event(
        id: 1,
        type: 'Спорт',
        name:
            'Марафон, но название очень длинное, поэтому на одну строчку не поместится',
        duration: '~ 60 минут',
        creatorId: 1,
        attendeeIds: [],
        achievementIds: [],
        desc: 'Бежим марафон',
        posterUrl:
            'https://s3-alpha-sig.figma.com/img/cae3/c133/2d065694ff000487e091d9f0383817cf?Expires=1649030400&Signature=UOVHUXWw659oxBiXz96Ha6k2f3yE~djxkOhyb-ePbJg7uC~z592uTuoe0Fx~OM3t2ISK52cBlr3qQH6eQraAyr8rzCJ06TnGy1h8-AJcDVtX2x2go1hkS35bCHBe6vKSo7P7ebCkfjO9JwdYSVIG0GBdXx-Y0iJ2d2Uma87nWIT20cWqOvfUxFOxBXH4dPVHM4mqLI75Cb5gno7ERAbuG5DCpgOecB0M1eSKhwdDZNx7dBuYFDhqC88CgfYpLTQVqsqZUBsA4ClnhmNkDEzOiXKAgcdMMc-PDGepw1vaj~-baAdOHJQOl~lPMVbK3126NL2YNdBU9l~nXr8rrvULkg__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
        qrUsage: QrUsage.onlyIn,
        startTime: DateTime(2022, 1, 10),
        state: EventState.planned,
      ),
      Event(
        id: 2,
        type: 'Квест',
        name: 'Поиск предметов',
        duration: '~ 45 минут',
        creatorId: 2,
        attendeeIds: [],
        achievementIds: [],
        desc: 'Ищем предметы',
        posterUrl:
            'https://s3-alpha-sig.figma.com/img/8712/af32/f805ed1cbcc8f92e37a47d4c4e2c38e8?Expires=1649030400&Signature=HKgVbFn76xne6pp6Y-7XwoHCLNZkY4hSc769TJEEMcYuKCG-L6YonzRn5ZSQFnpJFjit3GNa88wy5YQFKwUd785cwbPbdx3eTo4UtF0pcPQwtHViKTr6-l0fK73cpWHLnFzSYeGwlBlbOmovH543zhVMwI32m7UON-V4qsr7yvW358RDOB7Lnzdy78xZwB4TJRGHMuJxpT2Iw8Ev4Y2Dbqjno7weygkkrnnpme~Yr1JYOxMpQFSdKlMMuVnX2rZwuV5VqqvKo1JKAr7jdmTTL0qHSAKSj0G1HrOqeDBo~WRpnUa8ihNquKWa5FpBQ2Q79gGgY1mqTWNcsa6xeCUl5A__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
        qrUsage: QrUsage.onlyIn,
        startTime: DateTime(2022, 1, 10),
        state: EventState.planned,
      ),
      Event(
        id: 3,
        type: 'Музыка',
        name: 'Концерт местной панк-группы',
        duration: '> 60 минут',
        creatorId: 3,
        attendeeIds: [],
        achievementIds: [],
        desc: 'Слушаем поп-панк местного разлива и бухаем. Этож панк!',
        posterUrl: 'https://vpodryad.ru/upload/000/u1/1/6/60b57c1c.jpg',
        qrUsage: QrUsage.onlyIn,
        startTime: DateTime(2022, 1, 10),
        state: EventState.planned,
      ),
      Event(
        id: 4,
        type: 'Политика',
        name: 'Обсуждения, зачем нужна сменяемость власти',
        duration: '~45 минут',
        creatorId: 4,
        attendeeIds: [],
        achievementIds: [],
        desc:
            'Показываем на примере конкретных стран, зачем нужно менять президентов',
        posterUrl:
            'https://www.idea.int/sites/default/files/Initiatives/2018-Theme-Money-in-Politics.png',
        qrUsage: QrUsage.onlyIn,
        startTime: DateTime(2022, 1, 10),
        state: EventState.planned,
      ),
    ];
  }
}
