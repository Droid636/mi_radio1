import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_service/audio_service.dart';

import 'services/radio_audio_handler.dart';
import 'app_theme.dart';
import 'screens/home_screen.dart';
import 'helpers/providers/audio_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar el handler de audio correctamente
  final audioHandler = await AudioService.init(
    builder: () => RadioAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mi_radio1.channel.audio',
      androidNotificationChannelName: 'Reproducción de radio',
      androidNotificationOngoing: true,
    ),
  );

  // Iniciar la app envuelta en providers para evitar errores
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AudioProvider()..setHandler(audioHandler),
        ),
        Provider<AudioHandler>.value(value: audioHandler),
      ],
      child: const MyAppRoot(),
    ),
  );
}

// ✅ Nuevo root que ya puede leer providers sin error
class MyAppRoot extends StatelessWidget {
  const MyAppRoot({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Radiactiva Tx',
      theme: appTheme,
      home: const SplashScreenWrapper(),
    );
  }
}

// Wrapper del splash para navegar a Home
class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({super.key});

  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
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

    // Simulas cargando recursos (puedes usar aquí inicialización extra)
    await Future.delayed(const Duration(milliseconds: 500));

    final timeSpent = DateTime.now().difference(startTime);
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
