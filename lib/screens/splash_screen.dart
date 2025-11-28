import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // 1. Fondo de pantalla
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Splash_fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Overlay de Oscurecimiento (30% de opacidad)
          Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.black.withOpacity(0.3),
          ),

          // 3. Logo (Sin redondeo y ahora más ancho)
          Positioned(
            top: screenHeight * 0.25,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/logo_splash.png',
                // ****** CAMBIO AQUÍ: La imagen ocupa el 70% del ancho de la pantalla ******
                width: screenWidth * 0.7,
                // La altura se ajusta automáticamente, pero definimos un valor fijo para control
                height: 150,
                fit: BoxFit
                    .contain, // Usamos contain para que se vea completa si su aspecto es diferente
              ),
            ),
          ),

          // 4. Derechos reservados (Texto inferior)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  '©2025 Radioactiva TX - Todos los derechos reservados. Desarrollado por Freepi Inc.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black54,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
