import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Splash_fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top:
                MediaQuery.of(context).size.height *
                0.25, // Adjust this value to move the image up or down
            left: 0,
            right: 0,
            child: Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo_splash.jpg',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
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
