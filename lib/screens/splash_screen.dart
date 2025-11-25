// Archivo: lib/screens/splash_screen.dart

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ya no necesitamos 'backgroundColor' aquí, el Stack se encargará del fondo.
      body: Stack(
        // El widget Stack permite apilar widgets uno encima del otro.
        children: <Widget>[
          // --- 1. Imagen de Fondo (La capa de abajo) ---
          Container(
            // Usa 'MediaQuery.of(context).size' para que el Container
            // ocupe todo el espacio de la pantalla.
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                // <--- RUTA DE TU IMAGEN DE FONDO AQUÍ
                image: AssetImage('assets/images/Splash.png'),
                fit: BoxFit.cover, // Asegura que la imagen cubra todo el fondo
              ),
            ),
          ),

          // --- 2. Contenido Central (La capa de arriba) ---
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Aquí agregamos la imagen circular
                ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png', // <--- RUTA DE TU LOGO AQUÍ
                    width: 150, // Ajusta el tamaño de tu imagen
                    height: 150,
                    fit: BoxFit
                        .cover, // Para asegurar que la imagen cubra el círculo
                  ),
                ),
                const SizedBox(
                  height: 20,
                ), // Espacio entre la imagen y el texto
                Text(
                  'Radiactiva TX',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    // Asegúrate de usar un color que contraste con tu imagen de fondo
                    color: Colors.white,
                    // Opcional: añade una sombra al texto para que resalte más
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Tu estación favorita', // Puedes añadir un eslogan
                  style: TextStyle(
                    fontSize: 16,
                    // Asegúrate de usar un color que contraste con tu imagen de fondo
                    color: Colors.white,
                    // Opcional: añade una sombra al texto para que resalte más
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
