import 'dart:convert';

import 'package:event_runner/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DB<T extends Persistable> {
  final String tag;

  DB(this.tag);

  Future<void> _persistAll(List<T> els) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(
      tag,
      jsonEncode(els.map((e) => e.toJson()).toList()),
    );
  }

  Future<List<T>> getAll();

  Future<List<T>> getByIds(List<int> ids) async {
    return (await getAll()).where((e) => ids.contains(e.id)).toList();
  }

  Future<T> persistNew(T el) async {
    final els = await getAll();
    final newEl = el.withId(els.length + 1);
    await _persistAll([...els, newEl as T]);
    return newEl;
  }

  Future<List<T>> persistBatch(List<T> els) async {
    final existing = await getAll();
    final ret = <T>[];
    int count = 1;
    for (final el in els) {
      ret.add(el.withId(existing.length + count++) as T);
    }
    await _persistAll([...existing, ...ret]);

    return ret;
  }

  Future<void> update(T el) async {
    final els = await getAll();
    final ind = els.indexWhere((e) => e.id == el.id);
    if (ind == -1) {
      throw NoSuchElementFoundException();
    }
    els[ind] = el;
    await _persistAll(els);
  }

  Future<void> deleteByIds(List<int> ids) async {
    await _persistAll(
      List.of(await getAll())..removeWhere((e) => ids.contains(e.id)),
    );
  }
}

class Database {
  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();

    final profiles = sp.getString('profiles');
    final events = sp.getString('events');
    final qrs = sp.getString('qr');
    final achievements = sp.getString('achs');
    final steps = sp.getString('steps');

    final stepXuser = sp.getString('sxu');
    final achievementXowner = sp.getString('axo');
    final attendeeXevent = sp.getString('axe');

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

    if (qrs == null) {
      await sp.setString(
        'qr',
        jsonEncode(DefaultQrList.data.map((e) => e.toJson()).toList()),
      );
    }

    if (achievements == null) {
      await sp.setString(
        'achs',
        jsonEncode(DefaultAchievementList.data.map((e) => e.toJson()).toList()),
      );
    }

    if (steps == null) {
      await sp.setString(
        'steps',
        jsonEncode(DefaultStepList.data.map((e) => e.toJson()).toList()),
      );
    }

    if (stepXuser == null) {
      await sp.setString(
        'sxu',
        jsonEncode([]),
      );
    }

    if (achievementXowner == null) {
      await sp.setString(
        'axo',
        jsonEncode([]),
      );
    }

    if (attendeeXevent == null) {
      await sp.setString(
        'axe',
        jsonEncode([
          AttendeeXEvent(
            id: 1,
            eventId: 1,
            profileId: 1,
          ),
          AttendeeXEvent(
            id: 2,
            eventId: 1,
            profileId: 2,
          ),
          AttendeeXEvent(
            id: 3,
            eventId: 1,
            profileId: 3,
          ),
        ]),
      );
    }
  }

  final events = EventDB();
  final profiles = ProfileDB();
  final qrs = QrDB();
  final achievements = AchievementDB();
  final steps = StepDB();
  final stepXuser = StepXUserDB();
  final achievementXowner = AchievementXOwnerDB();
  final attendeeXevent = AttendeeXEventDB();
}

class EventDB extends DB<Event> {
  EventDB() : super('events');

  @override
  Future<List<Event>> getAll() async {
    final sp = await SharedPreferences.getInstance();
    return (jsonDecode(sp.getString(tag)!) as List)
        .map((e) => Event.fromJson(e))
        .toList(growable: false);
  }
}

class ProfileDB extends DB<Profile> {
  ProfileDB() : super('profiles');

  @override
  Future<List<Profile>> getAll() async {
    final sp = await SharedPreferences.getInstance();
    return (jsonDecode(sp.getString(tag)!) as List)
        .map((e) => Profile.fromJson(e))
        .toList(growable: false);
  }
}

class QrDB extends DB<Qr> {
  QrDB() : super('qr');

  @override
  Future<List<Qr>> getAll() async {
    final sp = await SharedPreferences.getInstance();
    return (jsonDecode(sp.getString(tag)!) as List)
        .map((e) => Qr.fromJson(e))
        .toList(growable: false);
  }
}

class AchievementDB extends DB<Achievement> {
  AchievementDB() : super('achs');

  @override
  Future<List<Achievement>> getAll() async {
    final sp = await SharedPreferences.getInstance();
    return (jsonDecode(sp.getString(tag)!) as List)
        .map((e) => Achievement.fromJson(e))
        .toList(growable: false);
  }
}

class StepDB extends DB<EventStep> {
  StepDB() : super('steps');

  @override
  Future<List<EventStep>> getAll() async {
    final sp = await SharedPreferences.getInstance();
    return (jsonDecode(sp.getString(tag)!) as List)
        .map((e) => EventStep.fromJson(e))
        .toList(growable: false);
  }
}

class StepXUserDB extends DB<StepXUser> {
  StepXUserDB() : super('sxu');

  @override
  Future<List<StepXUser>> getAll() async {
    final sp = await SharedPreferences.getInstance();
    return (jsonDecode(sp.getString(tag)!) as List)
        .map((e) => StepXUser.fromJson(e))
        .toList(growable: false);
  }
}

class AchievementXOwnerDB extends DB<AchievementXOwner> {
  AchievementXOwnerDB() : super('axo');

  @override
  Future<List<AchievementXOwner>> getAll() async {
    final sp = await SharedPreferences.getInstance();
    return (jsonDecode(sp.getString(tag)!) as List)
        .map((e) => AchievementXOwner.fromJson(e))
        .toList(growable: false);
  }
}

class AttendeeXEventDB extends DB<AttendeeXEvent> {
  AttendeeXEventDB() : super('axe');

  @override
  Future<List<AttendeeXEvent>> getAll() async {
    final sp = await SharedPreferences.getInstance();
    return (jsonDecode(sp.getString(tag)!) as List)
        .map((e) => AttendeeXEvent.fromJson(e))
        .toList(growable: false);
  }
}

class NoSuchElementFoundException with Exception {}

class DefaultProfileList {
  static List<Profile> get data {
    return <Profile>[
      Profile(
        id: 1,
        avatarUrl:
            'https://cdn.pixabay.com/photo/2018/06/27/07/45/student-3500990_640.jpg',
        displayName: 'Иван Гаврилов',
        email: 'ivan_gavr@gmail.com',
        passwordHash:
            'cc0781950ffebec65a7f552e099f5111dc6526384615f13801e3f0d25b38e960',
      ),
      Profile(
        id: 2,
        avatarUrl:
            'https://www.mohawkstudents.ca/wp-content/uploads/2021/09/Student-Rep.png',
        displayName: 'Лиза Сафронова',
        email: 'lisafr@gmail.com',
        passwordHash:
            '7ab7ca688b42d7edb92fda5fc6d7394e2cc4a19a441a06360183dbd2b06a5fb9',
      ),
      Profile(
        id: 3,
        avatarUrl:
            'https://img.freepik.com/free-photo/female-student-with-books-and-paperworks_1258-48204.jpg?size=626&ext=jpg&ga=GA1.1.2105003735.1643673600',
        displayName: 'Елена Шибаева',
        email: 'shibaeva@gmail.com',
        passwordHash:
            'eefc879116de9c05b9074ba6080c204fcdce03a63e51727b1f6d1764023779a1',
      ),
      Profile(
        id: 4,
        avatarUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnx6Y0YBttm9ugx38BUrbUKhK64NATYI3Sdg&usqp=CAU',
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
        desc: 'Бежим марафон',
        posterUrl: 'https://sport-marafon.ru/upload/iblock/a5c/1196-001.jpg',
        qrUsage: QrUsage.everyStep,
        startTime: DateTime(2022, 1, 10),
        state: EventState.planned,
      ),
      Event(
        id: 2,
        type: 'Квест',
        name: 'Поиск предметов',
        duration: '~ 45 минут',
        creatorId: 2,
        desc: 'Ищем предметы',
        posterUrl:
            'https://pix10.agoda.net/hotelImages/5696081/-1/ac6a005246bfebfc0e1c821a50479370.jpg?ca=9&ce=1&s=1024x768',
        qrUsage: QrUsage.achievements,
        startTime: DateTime(2022, 1, 10),
        state: EventState.planned,
      ),
      Event(
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
      ),
      Event(
        id: 4,
        type: 'Политика',
        name: 'Обсуждения, зачем нужна сменяемость власти',
        duration: '~45 минут',
        creatorId: 4,
        desc:
            'Показываем на примере конкретных стран, зачем нужно менять президентов',
        posterUrl:
            'https://www.idea.int/sites/default/files/Initiatives/2018-Theme-Money-in-Politics.png',
        qrUsage: QrUsage.inAndOut,
        startTime: DateTime(2022, 1, 10),
        state: EventState.planned,
      ),
    ];
  }
}

class DefaultStepList {
  static List<EventStep> get data {
    return [
      EventStep(
        id: 1,
        eventId: 1,
        name: 'Чекпоинт 1',
      ),
      EventStep(
        id: 2,
        eventId: 1,
        name: 'Чекпоинт 2',
      ),
      EventStep(
        id: 3,
        eventId: 1,
        name: 'Чекпоинт 3',
      ),
      EventStep(
        id: 4,
        eventId: 1,
        name: 'Чекпоинт 4',
      ),
    ];
  }
}

class DefaultQrList {
  static List<Qr> get data {
    return [
      EntryQr(id: 1, eventId: 3),
      EntryQr(id: 2, eventId: 4),
      ExitQr(id: 3, eventId: 4),
      StepQr(id: 4, stepId: 1, eventId: 1),
      StepQr(id: 5, stepId: 2, eventId: 1),
      StepQr(id: 6, stepId: 3, eventId: 1),
      StepQr(id: 7, stepId: 4, eventId: 1),
    ];
  }
}

class DefaultAchievementList {
  static List<Achievement> get data {
    return [
      Achievement(
        id: 1,
        eventId: 2,
        name: 'Белочка',
        desc: 'Вы нашли тайную белочку!',
      ),
      Achievement(
        id: 2,
        eventId: 2,
        name: 'Тайная записка',
        desc: 'Вы схватили записку!',
      ),
      Achievement(
        id: 3,
        eventId: 2,
        name: 'Доп. предмет',
        desc: 'Это поможет чуть позже...',
      ),
      Achievement(
        id: 4,
        eventId: 2,
        name: 'Шорткат',
        desc: 'У самых глазастых преимущество!',
      ),
    ];
  }
}
