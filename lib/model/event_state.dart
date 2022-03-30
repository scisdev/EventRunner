enum EventState { planned, ongoing, canceled, completed }

extension EventStateX on EventState {
  String get toDisplayString {
    switch (this) {
      case EventState.planned:
        {
          return 'Запланировано';
        }
      case EventState.ongoing:
        {
          return 'Сейчас проходит';
        }
      case EventState.canceled:
        {
          return 'Отменено';
        }
      case EventState.completed:
        {
          return 'Закончено';
        }
    }
  }
}

extension StringXEventState on String {
  EventState get toState {
    switch (this) {
      case 'Запланировано':
        {
          return EventState.planned;
        }
      case 'Сейчас проходит':
        {
          return EventState.ongoing;
        }
      case 'Отменено':
        {
          return EventState.canceled;
        }
      case 'Закончено':
        {
          return EventState.completed;
        }
      default:
        {
          throw Exception('Unparseable entity');
        }
    }
  }
}
