// Archivo: lib/widgets/station_card.dart (Modificado para diseño horizontal y botón dinámico)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/station_model.dart';
import '../helpers/providers/audio_provider.dart'; // Asegúrate de que esta ruta sea correcta

class StationCard extends StatelessWidget {
  final StationModel station;
  final VoidCallback onTap;

  const StationCard({
    super.key,
    required this.station,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Escuchar el estado de audio para el icono dinámico
    final audioProv = Provider.of<AudioProvider>(context);

    // Verificar si esta estación es la que se está reproduciendo
    final isPlaying = audioProv.isPlaying && (audioProv.currentStation?.id == station.id);

    // Seleccionar el icono correcto basado en el estado
    final icon = isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill;
    final iconColor = isPlaying ? Colors.red : Colors.black; // Color diferente si está activo

    return InkWell(
      onTap: onTap, // El onTap sigue siendo el que abre el BottomSheet
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ----------------------------------------------------
              // IZQUIERDA: IMAGEN / LOGO
              // ----------------------------------------------------
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(station.image), // Asumo que el modelo tiene el path de la imagen
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // ----------------------------------------------------
              // CENTRO: TEXTO
              // ----------------------------------------------------
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      station.slogan,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey.shade600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // ----------------------------------------------------
              // DERECHA: BOTÓN DINÁMICO (Play/Pause)
              // ----------------------------------------------------
              IconButton(
                icon: Icon(
                  icon,
                  size: 32,
                  color: iconColor,
                ),
                // Aquí usamos el onTap general, ya que abrir el BottomSheet maneja la lógica de reproducción.
                // Si quieres que el botón *no* abra el BottomSheet, sino solo controle la reproducción,
                // cambiarías el `onPressed` a:
                // onPressed: () {
                //   if (isPlaying) { audioProv.pause(); } else { audioProv.setStation(station); audioProv.play(); }
                // }
                // Pero mantendré el onTap que abre el BottomSheet como lo tenías:
                onPressed: onTap, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}