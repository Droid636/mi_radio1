// Archivo: lib/widgets/station_card.dart (MODIFICADO para diseño horizontal)

import 'package:flutter/material.dart';
import '../models/station_model.dart';

class StationCard extends StatelessWidget {
  final StationModel station;
  final VoidCallback onTap;

  const StationCard({super.key, required this.station, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // El diseño es un contenedor rectangular con fondo blanco
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12), // Bordes redondeados
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),

        // Usamos Row para la disposición horizontal (Logo | Texto | Botón Play)
        child: Row(
          children: [
            // 1. Logo de la Estación (Izquierda)
            ClipRRect(
              borderRadius: BorderRadius.circular(
                8,
              ), // Bordes redondeados para el logo
              child: Container(
                width: 60,
                height: 60,
                color: Colors
                    .black, // Fondo negro para el logo (como en la imagen)
                child: station.image.isNotEmpty
                    ? Image.asset(station.image, fit: BoxFit.contain)
                    : const Icon(Icons.radio, color: Colors.white),
              ),
            ),

            const SizedBox(width: 15),

            // 2. Información de la Estación (Centro)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    station.slogan,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 15),

            // 3. Botón de Reproducir (Derecha)
            Icon(
              Icons.play_arrow,
              // Usamos el color negro para el botón de play, ajusta si prefieres otro color
              color: Colors.black,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
