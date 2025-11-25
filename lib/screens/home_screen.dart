import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/constants.dart'; // Contiene la lista 'stations'
import '../helpers/providers/audio_provider.dart';
import '../widgets/station_card.dart';
import '../widgets/program_carousel.dart';
import '../models/program_model.dart';
import 'player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<ProgramModel> demoPrograms = const [
    ProgramModel(
      id: 'p1',
      title: 'Mañana Jazz',
      description: 'Lo mejor del jazz matutino',
      time: '08:00 - 10:00',
      image: 'assets/images/Program1.jpg',
    ),
    ProgramModel(
      id: 'p2',
      title: 'Tarde Alterna',
      description: 'Programa alternativo para la tarde',
      time: '16:00 - 18:00',
      image: 'assets/images/Program2.jpg',
    ),
  ];

  // 🔊 FUNCIÓN CLAVE: Muestra el PlayerScreen como un Modal Full-Screen
  void _showPlayerModal(BuildContext context) {
    // Referencia al provider antes de llamar al modal
    final audioProv = Provider.of<AudioProvider>(context, listen: false);

    // Ocultamos el MiniPlayerBar inmediatamente al disparar el modal para evitar duplicidad visual
    audioProv.hideMiniPlayer();

    // Es CRUCIAL que isScrollControlled sea true para que ocupe la altura máxima
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true, // Respeta la barra de estado superior
      backgroundColor:
          Colors.transparent, // Deja que el Scaffold interno defina el color
      builder: (_) {
        return SizedBox(
          // Ocupa el 100% de la altura disponible para simular un cambio de pantalla
          height: MediaQuery.of(context).size.height,
          child: const PlayerScreen(isModal: true),
        );
      },
    ).then((_) {
      // Callback: se ejecuta cuando el modal se cierra (al arrastrar o presionar el botón)
      // Aseguramos que el mini-player vuelva a mostrarse.
      audioProv.showMiniPlayer();
    });
  }

  /// 🎵 CONSTRUYE LA BARRA DE REPRODUCCIÓN FLOTANTE (Mini-Player)
  Widget _buildMiniPlayerBar(BuildContext context, AudioProvider audioProv) {
    // Altura fija de la barra flotante
    const double miniPlayerHeight = 70.0;

    // Solo mostramos si hay una estación (se está reproduciendo o pausado) Y no está oculto
    if (audioProv.currentStation == null || audioProv.isMiniPlayerHidden) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () => _showPlayerModal(context),
        child: Container(
          height: miniPlayerHeight,
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              // 1. Imagen de la Estación
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: audioProv.currentStation!.image.isNotEmpty
                      ? Image.asset(
                          audioProv.currentStation!.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                child: Icon(
                                  Icons.radio,
                                  size: 24,
                                  color: Colors.red,
                                ),
                              ),
                        )
                      : const Center(
                          child: Icon(Icons.radio, size: 24, color: Colors.red),
                        ),
                ),
              ),
              const SizedBox(width: 12),

              // 2. Textos (Nombre y Slogan)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      audioProv.currentStation!.name,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      audioProv.currentStation!.slogan,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // 3. Botón Play/Pause (Usa Consumer para escuchar el estado de AudioProvider)
              Consumer<AudioProvider>(
                builder: (context, audio, child) {
                  return IconButton(
                    iconSize: 32,
                    icon: Icon(
                      audio.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      if (audio.isPlaying) {
                        audio.pause();
                      } else {
                        // Si está pausado, lo reanuda
                        audio.play();
                      }
                    },
                  );
                },
              ),

              // 4. Botón Cerrar
              IconButton(
                iconSize: 24,
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  audioProv.stop();
                  // Oculta el mini-player completamente al detener la reproducción
                  audioProv.hideMiniPlayer();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos Provider.of con listen: true para reconstruir el widget si cambia el estado del mini-player.
    final audioProv = Provider.of<AudioProvider>(context);

    // Determina el espacio extra que necesita el SingleChildScrollView
    // Si el mini-player está activo, sumamos un padding que lo libere.
    final bool isMiniPlayerActive =
        audioProv.currentStation != null && !audioProv.isMiniPlayerHidden;
    final double bottomPadding = isMiniPlayerActive ? 90.0 : 12.0;

    return Scaffold(
      // ... (El Drawer sigue igual) ...
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 150,
              decoration: const BoxDecoration(color: Colors.red),
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.red),
              title: const Text('Comparte con un amigo'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.red),
              title: const Text('¡Califica nuestra app!'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.red),
              title: const Text('Nuestra Misión'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Colors.red),
              title: const Text('Política de Privacidad'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.radio, color: Colors.red),
              title: const Text('Escúchanos en'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.red),
              title: const Text('Versión 1.1.8'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      // -------------------------------------------------------------
      // 2. BODY: USANDO STACK PARA EL REPRODUCTOR FLOTANTE
      // -------------------------------------------------------------
      body: Stack(
        children: [
          // --- 2.1 CONTENIDO PRINCIPAL (Encabezado y ScrollView) ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ENCABEZADO PERSONALIZADO
              SizedBox(
                height: 120,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(child: Container(color: Colors.red)),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Builder(
                              builder: (context) {
                                return IconButton(
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // CONTENIDO SCROLLABLE
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 12.0,
                    right: 12.0,
                    top: 12.0,
                    // Espacio determinado dinámicamente
                    bottom:
                        bottomPadding, // Esto libera espacio para el mini-player
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Títulos Estaciones
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.headlineMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                          children: const [
                            TextSpan(text: 'Nuestras '),
                            TextSpan(
                              text: 'Estaciones',
                              style: TextStyle(color: Colors.amber),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // LISTA DE ESTACIONES
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: stations.length,
                        itemBuilder: (context, index) {
                          final s = stations[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: StationCard(
                              station: s,
                              onTap: () async {
                                // 1. Selecciona la estación
                                await audioProv.setStation(s);
                                // 2. Reproduce
                                await audioProv.play();
                                // 3. Muestra el mini-player explícitamente (ahora debe verse)
                                audioProv.showMiniPlayer();
                                // 4. Muestra el modal/reproductor
                                _showPlayerModal(context);
                              },
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Títulos Programas
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.headlineMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                          children: const [
                            TextSpan(text: 'Nuestros '),
                            TextSpan(
                              text: 'Programas',
                              style: TextStyle(color: Colors.amber),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ProgramCarousel(programs: demoPrograms),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // --- 2.2 REPRODUCTOR FLOTANTE (Implementación directa) ---
          _buildMiniPlayerBar(context, audioProv),
        ],
      ),
    );
  }
}
