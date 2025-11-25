import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/providers/audio_provider.dart';

class PlayerScreen extends StatelessWidget {
  // Nueva propiedad para saber si se usa como modal o como pantalla completa
  final bool isModal;

  const PlayerScreen({super.key, this.isModal = false});

  @override
  Widget build(BuildContext context) {
    final audioProv = Provider.of<AudioProvider>(context);
    final station = audioProv.currentStation;

    // Si la estación es nula, cerramos el modal o navegamos de vuelta
    if (station == null) {
      if (isModal) {
        // En un modal, si la estación desaparece (ej. el miniplayer se detiene), ciérralo.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop();
        });
        return const SizedBox.shrink();
      }
      return const Center(child: Text("Selecciona una estación."));
    }

    return Scaffold(
      // Si es modal, el AppBar debe ser más sutil o contener un botón de cierre.
      appBar: AppBar(
        title: Text(station.name),
        backgroundColor: Colors.white, // Color de fondo del modal
        elevation: 0,
        leading: isModal
            ? IconButton(
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                ), // Icono de deslizar hacia abajo
                onPressed: () {
                  Navigator.of(context).pop();
                  audioProv
                      .showMiniPlayer(); // Aseguramos que el mini-player se muestre al cerrarse
                },
              )
            : null, // Si no es modal, usa el botón de atrás normal de Flutter
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Imagen segura (Asegúrate de que tus assets estén en el pubspec.yaml)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: station.image.isNotEmpty
                    ? Image.asset(
                        station.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Icon(
                                Icons.radio,
                                size: 80,
                                color: Colors.red,
                              ),
                            ),
                      )
                    : const Center(
                        child: Icon(Icons.radio, size: 80, color: Colors.red),
                      ),
              ),
            ),

            const SizedBox(height: 32),

            // Nombre de la estación
            Text(
              station.name,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            // Slogan
            Text(
              station.slogan,
              style: Theme.of(
                context,
              ).textTheme.titleSmall!.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            // BOTONES DE CONTROL (Usamos Consumer para escuchar el estado de AudioProvider)
            Consumer<AudioProvider>(
              builder: (context, audioProv, child) {
                final playing = audioProv
                    .isPlaying; // Usamos el estado del Provider directamente

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón Play/Pause dinámico
                    IconButton(
                      iconSize: 80, // Icono más grande para el reproductor
                      onPressed: () {
                        if (playing) {
                          audioProv.pause();
                        } else {
                          // ** CAMBIO CLAVE: SI NO ESTÁ SONANDO, INICIAMOS LA REPRODUCCIÓN AQUÍ **
                          audioProv.play();
                        }
                      },
                      icon: Icon(
                        playing
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.red, // Color vibrante para el control
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 48), // Más espacio en la parte inferior
          ],
        ),
      ),
    );
  }
}
