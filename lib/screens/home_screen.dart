import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/constants.dart';
import '../helpers/providers/audio_provider.dart';
import '../widgets/station_card.dart';
import '../widgets/program_carousel.dart';
import '../models/program_model.dart';
import 'package:share_plus/share_plus.dart';
import 'player_screen.dart';

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('ERROR: No se pudo lanzar la URL: $url');
    }
  } catch (e) {
    debugPrint('Excepción al lanzar URL $url: $e');
  }
}

class SocialMediaButtons extends StatelessWidget {
  const SocialMediaButtons({super.key});

  final List<Map<String, dynamic>> socialLinks = const [
    {
      'name': 'Instagram',
      'assetPath': 'assets/icons/Instagram.png',
      'color': Color(0xFFC13584),
      'backgroundColor': Color(0xFFC13584),
      'url': 'https://www.instagram.com/radioactivatx?igsh=M2piYzc1eGNiY29v',
    },
    {
      'name': 'Facebook',
      'assetPath': 'assets/icons/Facebook.png',
      'color': Color(0xFF3B5998),
      'backgroundColor': Color(0xFF3B5998),
      'url':
          'https://www.facebook.com/radioactivatx89.9?wtsid=rdr_01btUDnQhVaGthwGL&from_intent_redirect=1',
    },
    {
      'name': 'X (Twitter)',
      'assetPath': 'assets/icons/Twiter.png',
      'color': Colors.black,
      'backgroundColor': Colors.black,
      'url': 'https://twitter.com/RadioactivaTx',
    },
    {
      'name': 'YouTube',
      'assetPath': 'assets/icons/Youtube.png',
      'color': Color(0xFFFF0000),
      'backgroundColor': Color(0xFFFF0000),
      'url': 'https://youtube.com/@radioactivatx?si=AZwNbDJzsPoLlxDB',
    },
    {
      'name': 'Tik Tok',
      'assetPath': 'assets/icons/Tiktok.png',
      'color': Color.fromARGB(255, 10, 10, 10),
      'backgroundColor': Color.fromARGB(255, 10, 10, 10),
      'url': 'https://www.tiktok.com/@radioactiva.tx?_r=1&_t=ZS-91jAkaMrlyP',
    },
    {
      'name': 'Teléfono',
      'assetPath': 'assets/icons/Telefono.png',
      'color': Colors.lightBlue,
      'backgroundColor': Colors.lightBlue,
      'url': 'tel:+524141199003',
    },
    {
      'name': 'Web',
      'assetPath': 'assets/icons/Web.png',
      'color': Color.fromARGB(255, 11, 11, 11),
      'backgroundColor': Color.fromARGB(255, 11, 11, 11),
      'url': 'https://www.radioactivatx.org/',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
        child: Wrap(
          spacing: 15.0,
          runSpacing: 15.0,
          alignment: WrapAlignment.center,
          children: socialLinks.map((link) {
            final color = link['color'] as Color;
            final assetPath = link['assetPath'] as String;
            final name = link['name'] as String;

            return InkWell(
              onTap: () => _launchURL(link['url'] as String), // Lanza la URL
              borderRadius: BorderRadius.circular(15.0),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        assetPath,
                        width: 40,
                        height: 40,

                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.link, size: 40, color: color),
                      ),
                      const SizedBox(height: 5),

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<ProgramModel> demoPrograms = const [
    ProgramModel(
      id: 'p1',
      title: 'Mañana Jazz',
      description:
          'Lo mejor del jazz matutino y el smooth jazz para empezar el día con calma y sofisticación. Una selección curada de clásicos atemporales, desde Miles Davis hasta Ella Fitzgerald, mezclados con las propuestas más frescas del jazz contemporáneo. Perfecta para el café, el trayecto al trabajo, o simplemente para disfrutar de un despertar melódico.',
      time: '08:00 - 10:00',
      image: 'assets/images/Program1.jpg',
    ),
    ProgramModel(
      id: 'p2',
      title: 'Tarde Alterna',
      description:
          'Tu dosis diaria de música que desafía lo convencional. En este programa exploramos las fronteras del rock alternativo, el indie más vanguardista, la electrónica experimental y los géneros que están marcando tendencia en la escena underground. Prepárate para descubrir nuevas bandas, escuchar entrevistas exclusivas y sumergirte en sonidos que no escucharás en ninguna otra parte.',
      time: '16:00 - 18:00',
      image: 'assets/images/Program2.jpg',
    ),
    ProgramModel(
      id: 'p3',
      title: 'Al Compás del Mundo',
      description:
          'Un viaje sonoro por los ritmos globales, desde la música africana hasta el folk europeo. Descubre nuevas culturas a través de sus melodías.',
      time: '19:00 - 20:30',
      image: 'assets/images/Program3.png',
    ),
  ];

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

  Widget _buildMiniPlayerBar(BuildContext context, AudioProvider audioProv) {
    // Usamos el color de acento amarillo en lugar del color del tema
    const Color yellowAccent = Color(0xFFFFD700);
    final accentColor = yellowAccent;

    final onCardColor = Theme.of(context).textTheme.bodyLarge!.color;

    const double miniPlayerHeight = 70.0;

    // El mini reproductor siempre aparece, aunque no haya estación
    // Si no hay estación, muestra un contenedor vacío con mensaje o icono
    if (audioProv.currentStation == null) {
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.radio, size: 32, color: accentColor),
              const SizedBox(width: 12),
              Text(
                'Selecciona una estación para escuchar',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }
    if (audioProv.isMiniPlayerHidden) {
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
            color: Theme.of(context).cardColor, // Color original (blanco)
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
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(
                    0xFFF55940,
                  ).withOpacity(0.1), // Fondo con opacidad anaranjado
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
                              color: accentColor, // Icono de radio
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.radio,
                            size: 24,
                            color: accentColor, // Icono de radio
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
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
              Consumer<AudioProvider>(
                builder: (context, audio, child) {
                  return IconButton(
                    iconSize: 32,
                    icon: Icon(
                      audio.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: Color(0xFFF55940), // Anaranjado
                    ),
                    onPressed: () async {
                      try {
                        if (audio.isPlaying) {
                          await audio.pause();
                        } else {
                          await audio.play();
                          audio.showMiniPlayer();
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Comprueba tu conexión a internet'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
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

    // --- CAMBIO DE COLOR A AMARILLO (Gold Yellow) ---
    const Color yellowAccent = Color(0xFFFFD700);

    // Reemplazamos la lógica del tema para forzar el amarillo en todos los acentos principales
    final Color accentRedOrangeColor = yellowAccent;
    final Color drawerIconColor = Color(
      0xFFF55940,
    ); // Naranja solo para íconos del Drawer
    final Color secondaryAccentColor = yellowAccent; // Amarillo para títulos
    // ------------------------------------------------

    final bool isMiniPlayerActive =
        audioProv.currentStation != null && !audioProv.isMiniPlayerHidden;

    final double bottomPadding = isMiniPlayerActive ? 90.0 : 12.0;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: accentRedOrangeColor,
              ), // Fondo del Drawer (Ahora Amarillo)
              child: SafeArea(
                child: Center(
                  child: Image(
                    image: const AssetImage('assets/images/Navbar_logo.png'),
                    width: 300,
                    height: 300,
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
            // ... (Resto de ListTiles del Drawer) ...
            ListTile(
              leading: Icon(Icons.share, color: drawerIconColor),
              title: const Text('Comparte con un amigo'),
              onTap: () async {
                Navigator.pop(context);
                // Usar el diálogo nativo de compartir
                await Share.share(
                  '¡Escucha nuestra app de radio! Descárgala aquí: https://play.google.com/store/apps/details?id=com.radioactivatx.radio',
                  subject: 'Recomendación de app',
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.star, color: drawerIconColor),
              title: const Text('¡Califica nuestra app!'),
              onTap: () {
                Navigator.pop(context);
                // Enlace de ejemplo a la Play Store o App Store
                _launchURL('market://details?id=com.radioactivatx.radio');
              },
            ),
            ListTile(
              leading: Icon(Icons.people, color: drawerIconColor),
              title: const Text('Nuestra Misión'),
              onTap: () {
                Navigator.pop(context);
                _launchURL('https://www.radioactivatx.org/acerca-de/');
              },
            ),
            ListTile(
              leading: Icon(Icons.description, color: drawerIconColor),
              title: const Text('Política de Privacidad'),
              onTap: () {
                Navigator.pop(context);
                _launchURL(
                  'https://www.radioactivatx.org/politica-privacidad/',
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.radio, color: drawerIconColor),
              title: const Text('Escúchanos en'),
              onTap: () {
                Navigator.pop(context);
                _launchURL('https://www.radioactivatx.org/streaming/');
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: drawerIconColor),
              title: const Text('Versión 1.1.8'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      // ... (Resto de la estructura del Scaffold) ...
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/banner.jpg',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: accentRedOrangeColor,
                        ), // Fondo de banner (Ahora Amarillo)
                      ),
                    ),
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
                                      color:
                                          secondaryAccentColor, // Texto acentuado (Ahora Amarillo)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

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
                                      color:
                                          secondaryAccentColor, // Texto acentuado (Ahora Amarillo)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            ProgramCarousel(programs: demoPrograms),
                            const SizedBox(height: 30),

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
                                      color:
                                          accentRedOrangeColor, // Texto acentuado (Ahora Amarillo)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),

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
          _buildMiniPlayerBar(context, audioProv),
        ],
      ),
    );
  }
}
