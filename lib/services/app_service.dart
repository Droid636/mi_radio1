import 'package:shared_preferences/shared_preferences.dart';

class AppService {
  Future<void> saveLastStation(String id) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('last_station', id);
  }

  Future<String?> getLastStation() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('last_station');
  }

  Future<void> clearLastStation() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('last_station');
  }
}
