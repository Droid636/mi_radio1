// Archivo: lib/screens/splash_screen.dart

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Establece el color de fondo del Scaffold a negro
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Aquí agregamos la imagen circular
            ClipOval(
              // ClipOval recorta el widget hijo en forma de óvalo (círculo si es cuadrado)
              child: Image.asset(
                'assets/images/logo.png', // <--- RUTA DE TU IMAGEN AQUÍ
                width: 150, // Ajusta el tamaño de tu imagen
                height: 150,
                fit: BoxFit
                    .cover, // Para asegurar que la imagen cubra el círculo
              ),
            ),
            const SizedBox(height: 20), // Espacio entre la imagen y el texto
            Text(
              'Radiactiva TX',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                // Cambia el color del texto principal a blanco
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tu estación favorita', // Puedes añadir un eslogan
              style: TextStyle(
                fontSize: 16,
                // Cambia el color del eslogan a un gris claro para contraste
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
