import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/constants.dart';
import '../helpers/providers/audio_provider.dart';
import '../widgets/station_card.dart';
import '../widgets/program_carousel.dart';
import '../models/program_model.dart';
import 'player_screen.dart';

// --- FUNCIÓN GLOBAL: LANZADOR DE URLS EXTERNAS ---
/// Gestiona la apertura de enlaces web, WhatsApp, llamadas, etc.
Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Usamos debugPrint para manejar errores suavemente en lugar de throw.
      debugPrint('ERROR: No se pudo lanzar la URL: $url');
    }
  } catch (e) {
    debugPrint('Excepción al lanzar URL $url: $e');
  }
}

// --- WIDGET AUXILIAR: BOTONES DE REDES SOCIALES ---
/// Muestra botones estilizados (como tarjetas) para las redes sociales de la radio,
/// usando íconos/imágenes de activos locales.
class SocialMediaButtons extends StatelessWidget {
  const SocialMediaButtons({super.key});

  // Define los enlaces y las rutas de los iconos de activos locales.
  // IMPORTANTE: Debes tener estos archivos en tu carpeta 'assets/icons/'
  final List<Map<String, dynamic>> socialLinks = const [
    {
      'name': 'Instagram',
      'assetPath': 'assets/icons/Instagram.png',
      'color': Color(0xFFC13584),
      'url': 'https://www.instagram.com/radioactivatx?igsh=M2piYzc1eGNiY29v',
    },
    {
      'name': 'Facebook',
      'assetPath': 'assets/icons/Facebook.png',
      'color': Color(0xFF3B5998),
      'url':
          'https://www.facebook.com/radioactivatx89.9?wtsid=rdr_01btUDnQhVaGthwGL&from_intent_redirect=1',
    },
    {
      'name': 'X (Twitter)',
      'assetPath': 'assets/icons/Twiter.png',
      'color': Colors.black,
      'url': 'https://x.com/mi_radio',
    },
    {
      'name': 'YouTube',
      'assetPath': 'assets/icons/Youtube.png',
      'color': Color(0xFFFF0000),
      'url': 'https://youtube.com/@radioactivatx?si=AZwNbDJzsPoLlxDB',
    },
    {
      'name': 'Tik Tok',
      'assetPath': 'assets/icons/Tiktok.png',
      'color': Color.fromARGB(255, 10, 10, 10),
      'url': 'https://www.tiktok.com/@radioactiva.tx?_r=1&_t=ZS-91jAkaMrlyP',
    },
    {
      'name': 'Teléfono',
      'assetPath': 'assets/icons/Telefono.png',
      'color': Colors.lightBlue,
      'url': 'tel:+524141199003',
    },
    {
      'name': 'Web',
      'assetPath': 'assets/icons/Web.png',
      'color': Color.fromARGB(255, 11, 11, 11),
      'url': 'https://www.radioactivatx.org/',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
        child: Wrap(
          spacing: 15.0, // Espacio entre íconos
          runSpacing: 15.0,
          alignment: WrapAlignment.center, // Centra los botones si hay pocos
          children: socialLinks.map((link) {
            final color = link['color'] as Color;
            final assetPath = link['assetPath'] as String;
            final name = link['name'] as String;

            return InkWell(
              onTap: () => _launchURL(link['url'] as String), // Lanza la URL
              borderRadius: BorderRadius.circular(15.0),
              child: Card(
                // Usamos Card para el efecto de tarjeta
                elevation: 6, // Elevación para dar profundidad
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  width: 100, // Ancho de la tarjeta
                  height: 100, // Alto de la tarjeta
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor, // Fondo de la tarjeta
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ícono/Imagen local de la red social
                      Image.asset(
                        assetPath,
                        width: 40,
                        height: 40,
                        // El color se puede usar para tintear la imagen si es monocromática
                        // color: color,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.link, // Fallback si la imagen no se encuentra
                          size: 40,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Nombre de la red social
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ---------------------------------------------------
// --- WIDGET PRINCIPAL: HOME SCREEN -----------------
// ---------------------------------------------------

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

  // 🔊 Muestra el PlayerScreen como un Modal Full-Screen
  void _showPlayerModal(BuildContext context) {
    final audioProv = Provider.of<AudioProvider>(context, listen: false);
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
      audioProv.showMiniPlayer();
    });
  }

  /// 🎵 CONSTRUYE LA BARRA DE REPRODUCCIÓN FLOTANTE (Mini-Player)
  Widget _buildMiniPlayerBar(BuildContext context, AudioProvider audioProv) {
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
      child: GestureDetector(
        onTap: () => _showPlayerModal(context), // Abre el modal al tocar
        child: Container(
          height: miniPlayerHeight,
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
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

              // 4. Botón Cerrar/Detener
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
    ).primaryColor; // Tu color amarillo

    final bool isMiniPlayerActive =
        audioProv.currentStation != null && !audioProv.isMiniPlayerHidden;
    // Ajusta el padding del contenido para que no se oculte detrás del Mini-Player
    final double bottomPadding = isMiniPlayerActive ? 90.0 : 12.0;

    return Scaffold(
      // --- DRAWER (MENÚ LATERAL) CON ENLACES EXTERNOS ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // CABECERA DEL DRAWER (usa el color de acento principal)
            Container(
              height: 150,
              decoration: BoxDecoration(color: accentRedOrangeColor),
              child: SafeArea(
                child: Center(
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
            ),

            // Items del Drawer que usan `_launchURL`
            ListTile(
              leading: Icon(Icons.share, color: secondaryAccentColor),
              title: const Text('Comparte con un amigo'),
              onTap: () {
                Navigator.pop(context);
                // Enlace de ejemplo para compartir
                _launchURL(
                  'whatsapp://send?text=¡Escucha nuestra app de radio! [Link a la Store]',
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.star, color: secondaryAccentColor),
              title: const Text('¡Califica nuestra app!'),
              onTap: () {
                Navigator.pop(context);
                // Enlace de ejemplo a la Play Store o App Store
                _launchURL('market://details?id=your.package.name');
              },
            ),
            ListTile(
              leading: Icon(Icons.people, color: secondaryAccentColor),
              title: const Text('Nuestra Misión'),
              onTap: () {
                Navigator.pop(context);
                _launchURL('https://tudominio.com/mision');
              },
            ),
            ListTile(
              leading: Icon(Icons.description, color: secondaryAccentColor),
              title: const Text('Política de Privacidad'),
              onTap: () {
                Navigator.pop(context);
                _launchURL('https://tudominio.com/privacidad');
              },
            ),
            ListTile(
              leading: Icon(Icons.radio, color: secondaryAccentColor),
              title: const Text('Escúchanos en'),
              onTap: () {
                Navigator.pop(context);
                _launchURL('https://tudominio.com/plataformas');
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: secondaryAccentColor),
              title: const Text('Versión 1.1.8'),
              onTap: () {
                Navigator.pop(context);
                // No hace nada, solo informativo
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
              // ENCABEZADO PERSONALIZADO (Cubre la función de AppBar)
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
                    // Sombra para mejor contraste del menú
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

              // CONTENIDO SCROLLABLE PRINCIPAL
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: Center(
                    // Agregamos Center para centrar el contenido principal
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth:
                            600, // Limita el ancho en pantallas grandes para el efecto de "tarjeta central"
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ), // Padding a los lados
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            // Título: Nuestras Estaciones
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                                children: [
                                  const TextSpan(text: 'Nuestras '),
                                  TextSpan(
                                    text: 'Estaciones',
                                    style: TextStyle(
                                      color: secondaryAccentColor,
                                    ),
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
                                      await audioProv.setStation(s);
                                      await audioProv.play();
                                      audioProv.showMiniPlayer();
                                    },
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 20),

                            // Título: Nuestros Programas
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                                children: [
                                  const TextSpan(text: 'Nuestros '),
                                  TextSpan(
                                    text: 'Programas',
                                    style: TextStyle(
                                      color: secondaryAccentColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            ProgramCarousel(programs: demoPrograms),
                            const SizedBox(height: 20),

                            // Título: Síguenos en Redes
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                children: [
                                  const TextSpan(text: 'Síguenos en '),
                                  TextSpan(
                                    text: 'Redes',
                                    style: TextStyle(
                                      color: accentRedOrangeColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),

                            // BOTONES DE REDES SOCIALES
                            const SocialMediaButtons(),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // --- REPRODUCTOR FLOTANTE (Mini-Player) ---
          _buildMiniPlayerBar(context, audioProv),
        ],
      ),
    );
  }
}
