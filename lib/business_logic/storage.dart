import 'dart:convert';

import 'package:event_runner/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUser {
  static Future<Profile?> getLocalProfile() async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString('profile');
    if (s == null) return null;

    return Profile.fromJson(jsonDecode(s));
  }

  static Future<void> persistLocalProfile(Profile profile) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('profile', jsonEncode(profile.toJson()));
  }
}
