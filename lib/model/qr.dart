import 'dart:convert';

import 'package:event_runner/model/persistable.dart';

abstract class Qr extends Persistable {
  final DateTime timestamp;
  final int eventId;

  Qr({
    required int id,
    required this.timestamp,
    required this.eventId,
  }) : super(id);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'type': type,
    }..addAll(_additional());
  }

  Map<String, dynamic> _additional();

  String get type;

  factory Qr.fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'entry':
        return EntryQr.fromJson(json);
      case 'exit':
        return ExitQr.fromJson(json);
      case 'step':
        return StepQr.fromJson(json);
      case 'ach':
        return AchievementQr.fromJson(json);
      default:
        throw IllegalClassTypeException();
    }
  }
}

class EntryQr extends Qr {
  EntryQr({
    required int id,
    required int eventId,
    required DateTime timestamp,
  }) : super(id: id, timestamp: timestamp, eventId: eventId);

  @override
  Map<String, dynamic> _additional() {
    return {};
  }

  @override
  String get type {
    return 'entry';
  }

  @override
  Persistable withId(int id) {
    return EntryQr(
      id: id,
      eventId: eventId,
      timestamp: timestamp,
    );
  }

  factory EntryQr.fromJson(Map<String, dynamic> json) {
    return EntryQr(
      id: json['id'],
      timestamp: json['timestamp'],
      eventId: json['eventId'],
    );
  }
}

class ExitQr extends Qr {
  ExitQr({
    required int id,
    required int eventId,
    required DateTime timestamp,
  }) : super(
          id: id,
          timestamp: timestamp,
          eventId: eventId,
        );

  @override
  Map<String, dynamic> _additional() {
    return {};
  }

  @override
  String get type {
    return 'exit';
  }

  @override
  Persistable withId(int id) {
    return ExitQr(
      id: id,
      eventId: eventId,
      timestamp: timestamp,
    );
  }

  factory ExitQr.fromJson(Map<String, dynamic> json) {
    return ExitQr(
      id: json['id'],
      timestamp: json['timestamp'],
      eventId: json['eventId'],
    );
  }
}

class StepQr extends Qr {
  final int stepId;

  StepQr({
    required int id,
    required this.stepId,
    required int eventId,
    required DateTime timestamp,
  }) : super(
          id: id,
          timestamp: timestamp,
          eventId: eventId,
        );

  @override
  Map<String, dynamic> _additional() {
    return {'stepId': stepId};
  }

  @override
  String get type {
    return 'step';
  }

  @override
  Persistable withId(int id) {
    return StepQr(
      id: id,
      eventId: eventId,
      stepId: stepId,
      timestamp: timestamp,
    );
  }

  factory StepQr.fromJson(Map<String, dynamic> json) {
    return StepQr(
      id: json['id'],
      timestamp: json['timestamp'],
      eventId: json['eventId'],
      stepId: json['stepId'],
    );
  }
}

class AchievementQr extends Qr {
  final int achId;

  AchievementQr({
    required int id,
    required this.achId,
    required int eventId,
    required DateTime timestamp,
  }) : super(
          id: id,
          timestamp: timestamp,
          eventId: eventId,
        );

  @override
  Map<String, dynamic> _additional() {
    return {'achId': achId};
  }

  @override
  String get type {
    return 'ach';
  }

  @override
  Persistable withId(int id) {
    return AchievementQr(
      id: id,
      achId: achId,
      eventId: eventId,
      timestamp: timestamp,
    );
  }

  factory AchievementQr.fromJson(Map<String, dynamic> json) {
    return AchievementQr(
      id: json['id'],
      eventId: json['eventId'],
      timestamp: json['timestamp'],
      achId: json['achId'],
    );
  }
}

class IllegalClassTypeException with Exception {}
