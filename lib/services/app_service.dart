import 'package:shared_preferences/shared_preferences.dart';

class AppService {
  /// Guarda la última estación escuchada
  Future<void> saveLastStation(String id) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('last_station', id);
  }

  /// Recupera la última estación escuchada
  Future<String?> getLastStation() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('last_station');
  }

  /// Limpia la estación guardada (opcional)
  Future<void> clearLastStation() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('last_station');
  }
}
