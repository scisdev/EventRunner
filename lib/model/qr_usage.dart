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

extension StringXQrUsage on String {
  QrUsage get toQrUsage {
    if (this == 'Вход по QR-коду') {
      return QrUsage.onlyIn;
    } else if (this == 'Вход и выход по QR-коду') {
      return QrUsage.inAndOut;
    } else if (this == 'QR-коды для достижений') {
      return QrUsage.achievements;
    } else if (this == 'QR-коды для каждого шага') {
      return QrUsage.everyStep;
    } else {
      return QrUsage.noQr;
    }
  }
}
