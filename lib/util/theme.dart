import 'package:flutter/material.dart';

class ERTheme {}

class ThemeFonts {
  static const h1 = TextStyle(
    fontWeight: FontWeight.w700,
    color: ThemeColors.mainText,
    fontSize: 22,
    height: 1.45,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const h2 = TextStyle(
    fontWeight: FontWeight.w700,
    color: ThemeColors.mainText,
    fontSize: 17,
    height: 1.58,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const h3 = TextStyle(
    fontSize: 15,
    height: 1.66,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const p1 = TextStyle(
    fontSize: 17,
    color: ThemeColors.secondaryText,
    fontWeight: FontWeight.w500,
    leadingDistribution: TextLeadingDistribution.even,
    height: 1.58,
  );

  static const p2 = TextStyle(
    fontSize: 15,
    height: 1.66,
    fontWeight: FontWeight.w500,
    color: ThemeColors.secondaryText,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const s = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.2,
    color: ThemeColors.mainText,
  );
}

class ThemeColors {
  static const background = Color.fromARGB(255, 255, 255, 255);
  static const form = Color.fromARGB(255, 244, 245, 247);
  static const primary = Color.fromARGB(255, 31, 204, 121);
  static const primaryRed = Color.fromARGB(255, 255, 100, 100);

  static const mainText = Color.fromARGB(255, 46, 62, 92);
  static const secondaryText = Color.fromARGB(255, 159, 165, 192);
  static const accentText = Color.fromARGB(255, 62, 84, 129);

  static const outline = Color.fromARGB(255, 208, 219, 234);
}

class ThemeDrawable {
  static const onBoard = 'assets/onboard.png';
  static const happyFace = 'assets/happy_face.png';
  static const googleIcon = 'assets/google_icon.svg';
  static const emailIcon = 'assets/email_icon.svg';
  static const passwordIcon = 'assets/password_icon.svg';
  static const obscuringIcon = 'assets/obscuring_icon.svg';

  static const home = 'assets/icon_home.svg';
  static const edit = 'assets/icon_edit.svg';
  static const qrScan = 'assets/icon_qr_scan.svg';
  static const notifications = 'assets/icon_notifications.svg';
  static const profile = 'assets/icon_profile.svg';

  static const chevronLeft = 'assets/icon_chevron_left.svg';

  static const addPhoto = 'assets/add_photo.svg';
  static const stepIcon = 'assets/step_icon.svg';
  static const closeIcon = 'assets/close_icon.svg';
}
