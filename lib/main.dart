import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'screens/home_screen.dart';
import 'helpers/providers/audio_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AudioProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Radiactiva Tx',
        theme: appTheme,
        home: const SplashScreenWrapper(),
      ),
    );
  }
}

class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({super.key});

  @override
  _SplashScreenWrapperState createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();
    _goHome();
  }

  Future<void> _goHome() async {
    const Duration minDuration = Duration(milliseconds: 2000);
    final startTime = DateTime.now();
    await Future.delayed(const Duration(milliseconds: 500));
    final endTime = DateTime.now();
    final timeSpent = endTime.difference(startTime);
    final remainingTime = minDuration - timeSpent;
    if (remainingTime > Duration.zero) {
      await Future.delayed(remainingTime);
    }
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) => const SplashScreen();
}
