enum QrUsage {
  everyStep,
  onlyIn,
  inAndOut,
  achievements,
  noQr,
}

extension QrUsageX on QrUsage {
  String get toDisplayString {
    if (this == QrUsage.onlyIn) {
      return 'Вход по QR-коду';
    } else if (this == QrUsage.inAndOut) {
      return 'Вход и выход по QR-коду';
    } else if (this == QrUsage.achievements) {
      return 'QR-коды для достижений';
    } else if (this == QrUsage.everyStep) {
      return 'QR-коды для каждого шага';
    } else {
      return 'Без QR-кодов';
    }
  }
}
