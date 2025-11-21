import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mi_radio1/helpers/providers/audio_provider.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProv = Provider.of<AudioProvider>(context);
    final station = audioProv.currentStation;

    return Scaffold(
      appBar: AppBar(title: Text(station?.name ?? 'Reproductor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Imagen segura
            if (station?.image != null && station!.image.isNotEmpty)
              Image.asset(
                station.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else
              const SizedBox(height: 200),

            const SizedBox(height: 12),

            // Nombre de la estación
            Text(
              station?.name ?? '',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),

            // Slogan
            Text(
              station?.slogan ?? '',
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            // BOTONES DE CONTROL
            StreamBuilder<bool>(
              stream: audioProv.player.playingStream,
              builder: (context, snapshot) {
                final playing = snapshot.data ?? false;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón Play/Pause dinámico
                    IconButton(
                      iconSize: 50,
                      onPressed: () {
                        if (playing) {
                          audioProv.pause();
                        } else {
                          audioProv.play();
                        }
                      },
                      icon: Icon(
                        playing ? Icons.pause_circle : Icons.play_circle,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
