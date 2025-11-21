// Archivo: lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'screens/home_screen.dart';
import 'helpers/providers/audio_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  // Asegura que los bindings de Flutter estén inicializados antes de runApp
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Provee el AudioProvider a toda la aplicación
      providers: [ChangeNotifierProvider(create: (_) => AudioProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Radio Clone',
        theme: appTheme,
        // Muestra el Splash Screen al inicio
        home: const SplashScreenWrapper(),
      ),
    );
  }
}

class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenWrapperState createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();
    _goHome(); // Inicia la lógica de espera y navegación
  }

  Future<void> _goHome() async {
    // 1. Definir una duración mínima de visualización (2 segundos)
    const Duration minDuration = Duration(milliseconds: 2000);
    final startTime = DateTime.now();

    // --- AQUÍ VA LA LÓGICA DE INICIALIZACIÓN ---
    // Puedes inicializar servicios, cargar configuraciones, etc.
    // await context.read<AudioProvider>().loadInitialData(); // Ejemplo

    // Simulación de carga (si no hay una carga real que medir)
    await Future.delayed(const Duration(milliseconds: 500));
    // ------------------------------------------

    // 2. Calcular el tiempo transcurrido y el tiempo restante
    final endTime = DateTime.now();
    final timeSpent = endTime.difference(startTime);
    final remainingTime = minDuration - timeSpent;

    // 3. Esperar el tiempo restante si es necesario para cumplir la duración mínima
    if (remainingTime > Duration.zero) {
      await Future.delayed(remainingTime);
    }

    // 4. Navegar a HomeScreen, verificando si el widget sigue montado
    if (mounted) {
      // Usa pushReplacement para que el usuario no pueda volver al Splash Screen con el botón de atrás
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) => const SplashScreen();
}
