import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/providers/audio_provider.dart';

// Convertimos PlayerScreen a StatefulWidget para manejar la animación
class PlayerScreen extends StatefulWidget {
  final bool isModal;

  const PlayerScreen({super.key, this.isModal = false});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  // Mapa de enlaces ahora usando rutas de assets simuladas.
  // AJUSTE LAS RUTAS DE LOS ARCHIVOS PNG DE ACUERDO A SU ESTRUCTURA DE ASSETS
  final List<Map<String, dynamic>> linkItems = const [
    // La app no debe tener Icons.tiktok o Icons.facebook, sino rutas de assets.
    {
      'label': 'Facebook',
      'asset': 'assets/icons/Facebook.png',
      'url':
          'https://www.facebook.com/radioactivatx89.9?wtsid=rdr_01btUDnQhVaGthwGL&from_intent_redirect=1',
    },
    {
      'label': 'Instagram',
      'asset': 'assets/icons/Instagram_2.png',
      'url': 'https://www.instagram.com/radioactivatx?igsh=M2piYzc1eGNiY29v',
    },
    {
      'label': 'Twitter (X)',
      'asset': 'assets/icons/Twiter.png',
      'url': 'https://twitter.com/RadioactivaTx',
    },
    {
      'label': 'YouTube',
      'asset': 'assets/icons/Youtube.png',
      'url': 'https://youtube.com/@radioactivatx?si=AZwNbDJzsPoLlxDB',
    },
    {
      'label': 'TikTok',
      'asset': 'assets/icons/Tiktok_2.png',
      'url': 'https://www.tiktok.com/@radioactiva.tx?_r=1&_t=ZS-91jAkaMrlyP',
    },
    {
      'label': 'Llamar',
      'asset': 'assets/icons/Telefono_2.png',
      'url': 'tel:+524141199003',
    },
    {
      'label': 'Sitio Web',
      'asset': 'assets/icons/Web.png',
      'url': 'https://www.radioactivatx.org/',
    },
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  // --- FUNCIÓN DE LANZAMIENTO DE URL SEGURA ---
  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);

    if (!await canLaunchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: No se encontró una aplicación para abrir el enlace: $urlString',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al intentar abrir el enlace: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- NUEVA FUNCIÓN PARA MOSTRAR LAS OPCIONES DE ENLACE COMO SIDE-MENU ---
  void _showLinkOptions() {
    final primaryYellow = Theme.of(context).primaryColor;

    showGeneralDialog(
      context: context,
      barrierDismissible: true, // Se puede cerrar al tocar fuera
      barrierLabel: 'Side Menu',
      // Animación de deslizamiento de derecha a izquierda
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, anim, secondAnim, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        // Usa el nuevo widget LinkOptionsDrawer que simula el menú lateral
        return LinkOptionsDrawer(
          linkItems: linkItems,
          primaryColor: primaryYellow,
          onLinkTap: (String urlString) {
            _launchUrl(context, urlString);
          },
          onShareTap: () {
            // Lógica para compartir (usar paquete share_plus)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Función de Compartir activada.')),
            );
          },
        );
      },
    );
  }
  // ----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final audioProv = Provider.of<AudioProvider>(context);
    final station = audioProv.currentStation;

    final Color primaryYellow = Theme.of(context).primaryColor;

    if (station == null) {
      if (widget.isModal) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Si es modal y no hay estación, se cierra (no genera warning)
          Navigator.of(context).pop();
        });
        return const SizedBox.shrink();
      }
      return const Center(child: Text("Selecciona una estación."));
    }

    // Control de la animación simplificado:
    audioProv.isPlaying
        ? _rotationController.repeat()
        : _rotationController.stop();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Crea un fondo negro con un ligero degradado
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.black87, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // --- BARRA DE NAVEGACIÓN PERSONALIZADA ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón de Cerrar (Icono de deslizar hacia abajo)
                    widget.isModal
                        ? IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: primaryYellow,
                              size: 32,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              audioProv.showMiniPlayer();
                            },
                          )
                        : const SizedBox(width: 32),

                    // Botón de Menú/Opciones (LOS TRES PUNTOS)
                    IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: primaryYellow,
                        size: 32,
                      ),
                      onPressed:
                          _showLinkOptions, // Llama al menú lateral de íconos
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // --- IMAGEN DE LA ESTACIÓN (ROTATORIA) ---
                RotationTransition(
                  turns: _rotationController,
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryYellow.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: station.image.isNotEmpty
                          ? Image.asset(
                              station.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.black,
                                    child: Icon(
                                      Icons.radio,
                                      size: 100,
                                      color: primaryYellow,
                                    ),
                                  ),
                            )
                          : Container(
                              color: Colors.black,
                              child: Icon(
                                Icons.radio,
                                size: 100,
                                color: primaryYellow,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // --- INFORMACIÓN DE LA ESTACIÓN ---
                Text(
                  station.name,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Slogan/Ciudad
                Text(
                  station.slogan,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: primaryYellow, // Amarillo brillante
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),

                // --- CONTROLES DE REPRODUCCIÓN: ANTERIOR, PLAY/PAUSE, SIGUIENTE ---
                Consumer<AudioProvider>(
                  builder: (context, audioProv, child) {
                    final isPlaying = audioProv.isPlaying;
                    final isLoading = audioProv.isLoading;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Botón Anterior
                        IconButton(
                          iconSize: 60,
                          onPressed: isLoading
                              ? null
                              : () async {
                                  await audioProv.playPreviousStation();
                                },
                          icon: Icon(Icons.skip_previous, color: Colors.white),
                        ),
                        // Botón Play/Pause
                        IconButton(
                          iconSize: 100,
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (isPlaying) {
                                    audioProv.pause();
                                  } else {
                                    audioProv.play();
                                  }
                                },
                          icon: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryYellow,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryYellow.withOpacity(0.5),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.black,
                                    size: 45,
                                  ),
                          ),
                        ),
                        // Botón Siguiente
                        IconButton(
                          iconSize: 60,
                          onPressed: isLoading
                              ? null
                              : () async {
                                  await audioProv.playNextStation();
                                },
                          icon: Icon(Icons.skip_next, color: Colors.white),
                        ),
                      ],
                    );
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- NUEVO WIDGET: LinkOptionsDrawer (Menú Lateral de Iconos) ---
class LinkOptionsDrawer extends StatelessWidget {
  final List<Map<String, dynamic>> linkItems;
  final Color primaryColor;
  final Function(String urlString) onLinkTap;
  final VoidCallback onShareTap;

  const LinkOptionsDrawer({
    super.key,
    required this.linkItems,
    required this.primaryColor,
    required this.onLinkTap,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    // Definimos el tamaño del drawer (ajustado para contener los íconos)
    final double drawerWidth = MediaQuery.of(context).size.width * 0.25;

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent, // El fondo ya está oscuro en el PlayerScreen
        child: Container(
          width: drawerWidth,
          height:
              MediaQuery.of(context).size.height *
              0.8, // Altura que simula la imagen
          decoration: BoxDecoration(
            color: Colors.grey[900]!.withOpacity(
              0.9,
            ), // Fondo oscuro semitransparente
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10),
            ],
          ),
          child: Column(
            // El menú de iconos en la imagen parece estar centrado verticalmente
            mainAxisAlignment: MainAxisAlignment.center,
            children: linkItems.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: IconButton(
                  iconSize: 40,
                  icon: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor, // Círculo amarillo de fondo
                    ),
                    child: ClipOval(
                      // Usamos Image.asset para cargar el ícono de la red social
                      child: Image.asset(
                        item['asset'] as String,
                        width:
                            30, // Ajuste el tamaño de la imagen dentro del círculo
                        height: 30,
                        fit: BoxFit.scaleDown,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.link,
                          color: Colors.black,
                          size: 20,
                        ), // Fallback
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Cierra el drawer

                    if (item.containsKey('url')) {
                      onLinkTap(item['url'] as String);
                    } else if (item['type'] == 'share') {
                      onShareTap();
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
