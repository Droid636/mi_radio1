import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/constants.dart';
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
    final audioProv = Provider.of<AudioProvider>(context, listen: false);

    // 1. Ocultamos la barra flotante al abrir el modal completo
    audioProv.hideMiniPlayer();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const PlayerScreen(isModal: true),
        );
      },
    ).then((_) {
      // 2. Cuando el modal se cierra, volvemos a mostrar la barra flotante
      audioProv.showMiniPlayer();
    });
  }

  /// 🎵 CONSTRUYE LA BARRA DE REPRODUCCIÓN FLOTANTE (Mini-Player)
  Widget _buildMiniPlayerBar(BuildContext context, AudioProvider audioProv) {
    // Usamos los colores definidos en tu tema
    final accentRedOrangeColor = Theme.of(context).colorScheme.secondary;
    final onCardColor = Theme.of(context).textTheme.bodyLarge!.color;

    const double miniPlayerHeight = 70.0;

    if (audioProv.currentStation == null || audioProv.isMiniPlayerHidden) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      // Al tocar la barra, abrimos el modal full-screen
      child: GestureDetector(
        onTap: () => _showPlayerModal(context),
        child: Container(
          height: miniPlayerHeight,
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).cardColor, // Asume que la tarjeta es blanca
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
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
                  // Fondo sutil con el color de acento
                  color: accentRedOrangeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: audioProv.currentStation!.image.isNotEmpty
                      ? Image.asset(
                          audioProv.currentStation!.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.radio,
                              size: 24,
                              color: accentRedOrangeColor,
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.radio,
                            size: 24,
                            color: accentRedOrangeColor,
                          ),
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
                        color: onCardColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      audioProv.currentStation!.slogan,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: onCardColor!.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // 3. Botón Play/Pause
              Consumer<AudioProvider>(
                builder: (context, audio, child) {
                  return IconButton(
                    iconSize: 32,
                    icon: Icon(
                      audio.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: accentRedOrangeColor,
                    ),
                    onPressed: () {
                      if (audio.isPlaying) {
                        audio.pause();
                      } else {
                        audio.play();
                      }
                    },
                  );
                },
              ),

              // 4. Botón Cerrar
              IconButton(
                iconSize: 24,
                icon: Icon(Icons.close, color: onCardColor.withOpacity(0.5)),
                onPressed: () {
                  audioProv.stop();
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
    final audioProv = Provider.of<AudioProvider>(context);

    // Colores obtenidos del tema
    final accentRedOrangeColor = Theme.of(context).colorScheme.secondary;
    final secondaryAccentColor = Theme.of(
      context,
    ).primaryColor; // Tu amarillo (#FFFFCC00)

    final bool isMiniPlayerActive =
        audioProv.currentStation != null && !audioProv.isMiniPlayerHidden;
    final double bottomPadding = isMiniPlayerActive ? 90.0 : 12.0;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // CABECERA DEL DRAWER
            Container(
              height: 150,
              decoration: BoxDecoration(
                // Usamos el color de acento para la cabecera
                color: accentRedOrangeColor,
              ),
              // --- INICIO DE CORRECCIÓN ---
              // Removido el 'const' de SafeArea y Center para que errorBuilder (una función dinámica) funcione
              child: SafeArea(
                // YA NO ES CONST
                child: Center(
                  // YA NO ES CONST
                  // Asumimos que esta imagen existe, o usamos un texto si no.
                  child: Image(
                    image: const AssetImage('assets/images/Navbar.png'),
                    width: 100,
                    height: 100,
                    color: Colors.white,
                    errorBuilder: (context, error, stackTrace) => const Text(
                      'Menú',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // --- FIN DE CORRECCIÓN ---
            ),

            // Items del Drawer usando el color de acento del tema (secondary/Rojo-Naranja)
            ListTile(
              leading: Icon(Icons.share, color: accentRedOrangeColor),
              title: const Text('Comparte con un amigo'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.star, color: accentRedOrangeColor),
              title: const Text('¡Califica nuestra app!'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.people, color: accentRedOrangeColor),
              title: const Text('Nuestra Misión'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.description, color: accentRedOrangeColor),
              title: const Text('Política de Privacidad'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.radio, color: accentRedOrangeColor),
              title: const Text('Escúchanos en'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: accentRedOrangeColor),
              title: const Text('Versión 1.1.8'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ENCABEZADO PERSONALIZADO
              SizedBox(
                height: 120,
                width: double.infinity,
                child: Stack(
                  children: [
                    // Fondo con imagen o color de acento
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/header_bg.jpg',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: accentRedOrangeColor,
                        ), // Color de Fallback
                      ),
                    ),
                    // Opcional: Sombra (para mejorar la visibilidad de los iconos blancos)
                    Positioned.fill(
                      child: Container(color: Colors.black.withOpacity(0.2)),
                    ),
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
                                  // El color del ícono es blanco sobre la imagen oscura
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
                    bottom: bottomPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Títulos Estaciones (Resaltado Amarillo del Tema)
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.headlineMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                          children: [
                            const TextSpan(text: 'Nuestras '),
                            TextSpan(
                              text: 'Estaciones',
                              style: TextStyle(color: secondaryAccentColor),
                            ), // Usa primaryColor (amarillo)
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
                                // 1. Establecer la estación
                                await audioProv.setStation(s);
                                // 2. Iniciar la reproducción
                                await audioProv.play();
                                // 3. Mostrar el Mini-Player flotante
                                audioProv.showMiniPlayer();

                                // El modal de pantalla completa ahora SOLO se abre tocando el Mini-Player.
                              },
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Títulos Programas (Resaltado Amarillo del Tema)
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.headlineMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                          children: [
                            const TextSpan(text: 'Nuestros '),
                            TextSpan(
                              text: 'Programas',
                              style: TextStyle(color: secondaryAccentColor),
                            ), // Usa primaryColor (amarillo)
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

          // --- 2.2 REPRODUCTOR FLOTANTE ---
          _buildMiniPlayerBar(context, audioProv),
        ],
      ),
    );
  }
}
