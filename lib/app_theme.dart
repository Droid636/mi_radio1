import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Definimos nuestros colores específicos del diseño
// Amarillo Primario: #FFFFCC00 (usado en la cabecera, textos resaltados)
const Color primaryYellow = Color(0xFFFFCC00);

// Rojo/Naranja de Acento: #FFF55940 (usado para los íconos y el fondo de la cabecera)
const Color accentRedOrange = Color(0xFFF55940);

final ThemeData appTheme = ThemeData(
  // 1. Color Primario: Usamos el amarillo como color principal
  primaryColor: primaryYellow,

  // 2. Colores del esquema (para widgets como AppBar, etc.)
  colorScheme:
      ColorScheme.fromSwatch(
        primarySwatch: const MaterialColor(
          0xFFFFCC00, // Valor del amarillo
          <int, Color>{
            50: Color(0xFFFFFBE6),
            100: Color(0xFFFFECC4),
            200: Color(0xFFFFDD80),
            300: Color(0xFFFFCC00), // Usamos este como el color principal
            400: Color(0xFFFFBF00),
            500: Color(0xFFFFB200),
            600: Color(0xFFA67100),
            700: Color(0xFF6B4700),
            800: Color(0xFF352400),
            900: Color(0xFF000000), // Usar negro o un color muy oscuro
          },
        ),
        // IMPORTANTE: El color de acento se define como 'secondary'
        accentColor: accentRedOrange,
        backgroundColor: Colors.white,
      ).copyWith(
        // Aseguramos que 'accentRedOrange' esté disponible como 'secondary'
        secondary: accentRedOrange,
        // También establecemos el color de fondo de las tarjetas del mini-player
        surface: Colors.white,
      ),

  // 3. Estilos de texto (se mantienen)
  textTheme: TextTheme(
    titleLarge: GoogleFonts.inter(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ), // Lo ajustamos a 22px para el título de sección
    titleMedium: GoogleFonts.inter(fontSize: 16),
    bodySmall: GoogleFonts.inter(fontSize: 12),
    // Establecemos el color principal del bodyLarge para que el MiniPlayer lo use
    bodyLarge: GoogleFonts.inter(color: Colors.black),
  ),

  // 4. Estilo del AppBar (para asegurar que el fondo sea transparente y los íconos negros)
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
  ),

  // 5. Estilo de los iconos (usa el color de acento)
  iconTheme: const IconThemeData(color: accentRedOrange),

  // 6. Color de la tarjeta (Mini-Player)
  cardColor: Colors.white,
);
