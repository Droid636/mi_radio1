import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/providers/audio_provider.dart';
import '../models/program_model.dart';

class PlayerScreen extends StatefulWidget {
  final bool isModal;

  const PlayerScreen({super.key, this.isModal = false});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  // -------------------------
  // Programación por estación
  // -------------------------
  final Map<String, Map<String, List<ProgramModel>>> stationPrograms = {
    'rtx': {
      'Lunes': [
        ProgramModel(
          id: 'p1',
          title: 'Mañana Alternativa',
          description: 'Rock alternativo y entrevistas exclusivas.',
          schedule: {'Lunes': '08:00 - 10:00'},
          image: 'assets/images/Program1.jpg',
        ),
        ProgramModel(
          id: 'p2',
          title: 'Tarde Indie',
          description: 'Indie, electrónica y tendencias underground.',
          schedule: {'Lunes': '16:00 - 18:00'},
          image: 'assets/images/Program2.jpg',
        ),
      ],
      'Martes': [
        ProgramModel(
          id: 'p3',
          title: 'Jazz Fusion',
          description: 'Jazz experimental y fusiones modernas.',
          schedule: {'Martes': '10:00 - 12:00'},
          image: 'assets/images/Program3.jpg',
        ),
        ProgramModel(
          id: 'p4',
          title: 'Noches Urbanas',
          description: 'Hip-hop, rap y cultura urbana.',
          schedule: {'Martes': '20:00 - 22:00'},
          image: 'assets/images/Program4.jpg',
        ),
      ],
      'Miércoles': [
        ProgramModel(
          id: 'p5',
          title: 'Electro Vibes',
          description: 'Electrónica y dance para mitad de semana.',
          schedule: {'Miércoles': '18:00 - 20:00'},
          image: 'assets/images/Program5.jpg',
        ),
      ],
      'Jueves': [
        ProgramModel(
          id: 'p6',
          title: 'Retro Hits',
          description: 'Clásicos de los 80s y 90s.',
          schedule: {'Jueves': '14:00 - 16:00'},
          image: 'assets/images/Program6.jpg',
        ),
      ],
      'Viernes': [
        ProgramModel(
          id: 'p7',
          title: 'Fiesta Latina',
          description: 'Reggaetón, salsa y ritmos latinos.',
          schedule: {'Viernes': '20:00 - 23:00'},
          image: 'assets/images/Program7.jpg',
        ),
      ],
      // Sábado y Domingo añadidos
      'Sábado': [
        ProgramModel(
          id: 'p14',
          title: 'Sábado Retro',
          description: 'Lo mejor de los clásicos para el fin de semana.',
          schedule: {'Sábado': '12:00 - 15:00'},
          image: 'assets/images/Program8.jpg',
        ),
        ProgramModel(
          id: 'p15',
          title: 'Noches de DJ',
          description: 'Sets de DJ y remixes para la noche sabatina.',
          schedule: {'Sábado': '22:00 - 02:00'},
          image: 'assets/images/Program9.jpg',
        ),
      ],
      'Domingo': [
        ProgramModel(
          id: 'p16',
          title: 'Domingo Chill',
          description: 'Música relajada para cerrar la semana.',
          schedule: {'Domingo': '10:00 - 13:00'},
          image: 'assets/images/Program10.jpg',
        ),
      ],
    },
    'ljr': {
      'Lunes': [
        ProgramModel(
          id: 'p8',
          title: 'Jazz Matutino',
          description: 'Clásicos y nuevos sonidos del jazz para tu mañana.',
          schedule: {'Lunes': '08:00 - 10:00'},
          image: '',
        ),
        ProgramModel(
          id: 'p9',
          title: 'Smooth Jazz',
          description: 'Jazz suave para relajarse.',
          schedule: {'Lunes': '16:00 - 18:00'},
          image: '',
        ),
      ],
      'Martes': [
        ProgramModel(
          id: 'p10',
          title: 'Jazz Latino',
          description: 'Fusión de jazz con ritmos latinos.',
          schedule: {'Martes': '10:00 - 12:00'},
          image: '',
        ),
      ],
      'Miércoles': [
        ProgramModel(
          id: 'p11',
          title: 'Jazz Instrumental',
          description: 'Instrumentistas destacados y solos.',
          schedule: {'Miércoles': '18:00 - 20:00'},
          image: '',
        ),
      ],
      'Jueves': [
        ProgramModel(
          id: 'p12',
          title: 'Jazz Fusion',
          description: 'Fusión de géneros y experimentación.',
          schedule: {'Jueves': '14:00 - 16:00'},
          image: '',
        ),
      ],
      'Viernes': [
        ProgramModel(
          id: 'p13',
          title: 'Jazz en Vivo',
          description: 'Conciertos y sesiones en vivo.',
          schedule: {'Viernes': '20:00 - 23:00'},
          image: '',
        ),
      ],
      // Sábado y Domingo añadidos
      'Sábado': [
        ProgramModel(
          id: 'p17',
          title: 'Sábado de Standards',
          description: 'Standards de jazz y covers en vivo.',
          schedule: {'Sábado': '11:00 - 14:00'},
          image: '',
        ),
      ],
      'Domingo': [
        ProgramModel(
          id: 'p18',
          title: 'Noche de Big Band',
          description: 'Selección de grandes arreglos y orquestaciones.',
          schedule: {'Domingo': '19:00 - 22:00'},
          image: '',
        ),
      ],
    },
  };

  final List<Map<String, dynamic>> linkItems = const [
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

  // Devuelve el nombre del día actual en español (Lunes..Domingo)
  String _getTodayName() {
    final now = DateTime.now();
    const days = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    return days[now.weekday - 1];
  }

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

  void _showLinkOptions() {
    final primaryYellow = Theme.of(context).primaryColor;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Side Menu',
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
        return LinkOptionsDrawer(
          linkItems: linkItems,
          primaryColor: primaryYellow,
          onLinkTap: (String urlString) {
            _launchUrl(context, urlString);
          },
          onShareTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Función de Compartir activada.')),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioProv = Provider.of<AudioProvider>(context);
    final station = audioProv.currentStation;

    final Color primaryYellow = Theme.of(context).primaryColor;

    if (station == null) {
      if (widget.isModal) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop();
        });
        return const SizedBox.shrink();
      }
      return const Center(child: Text("Selecciona una estación."));
    }

    audioProv.isPlaying
        ? _rotationController.repeat()
        : _rotationController.stop();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.black87, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: primaryYellow,
                            size: 32,
                          ),
                          onPressed: _showLinkOptions,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

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
                              ? (station.image.startsWith('http')
                                    ? Image.network(
                                        station.image,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  color: Colors.black,
                                                  child: Icon(
                                                    Icons.radio,
                                                    size: 100,
                                                    color: primaryYellow,
                                                  ),
                                                ),
                                      )
                                    : Image.asset(
                                        station.image,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  color: Colors.black,
                                                  child: Icon(
                                                    Icons.radio,
                                                    size: 100,
                                                    color: primaryYellow,
                                                  ),
                                                ),
                                      ))
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

                    Consumer<AudioProvider>(
                      builder: (context, audioProv, _) {
                        final meta = audioProv.currentMetadataTitle;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              meta ?? station.name,
                              style:
                                  Theme.of(
                                    context,
                                  ).textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 28,
                                    letterSpacing: 0.5,
                                  ) ??
                                  const TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              meta != null ? station.name : station.slogan,
                              style:
                                  Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    color: meta != null
                                        ? primaryYellow
                                        : Colors.white70,
                                    fontWeight: meta != null
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    fontSize: meta != null ? 18 : 16,
                                  ) ??
                                  const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Siempre mostrar el slogan debajo
                            if (meta != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  station.slogan,
                                  style:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      ) ??
                                      const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white70,
                                      ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const Spacer(),

                    Consumer<AudioProvider>(
                      builder: (context, audioProv, child) {
                        final isPlaying = audioProv.isPlaying;
                        final isLoading = audioProv.isLoading;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 60,
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      await audioProv.playPreviousStation();
                                    },
                              icon: Icon(
                                Icons.skip_previous,
                                color: Colors.white,
                              ),
                            ),

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
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.black,
                                              ),
                                        ),
                                      )
                                    : Icon(
                                        isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.black,
                                        size: 45,
                                      ),
                              ),
                            ),

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

                // -------------------------------
                // Programación: card-style + día actual
                // -------------------------------
                if (station.id == 'ljr')
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Text(
                        'No hay programas disponibles',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                else if (stationPrograms[station.id] != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        // Determinar día actual y elegir índice si existe
                        final stationId = station.id;
                        final days = stationPrograms[stationId]!.keys.toList();

                        // índice por defecto: día actual si existe, sino 0
                        int currentDayIdx = days.indexOf(_getTodayName());
                        if (currentDayIdx < 0) currentDayIdx = 0;

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.grey[900],
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          builder: (ctx) {
                            return StatefulBuilder(
                              builder: (context, setModalState) {
                                final Color modalYellow = Theme.of(
                                  context,
                                ).primaryColor;
                                final stationId = station.id;
                                final days = stationPrograms[stationId]!.keys
                                    .toList();

                                return DraggableScrollableSheet(
                                  initialChildSize: 0.6,
                                  minChildSize: 0.25,
                                  maxChildSize: 0.95,
                                  expand: false,
                                  builder: (context, scrollController) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 6,
                                            margin: const EdgeInsets.only(
                                              top: 12,
                                              bottom: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white24,
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.arrow_left,
                                                  color: modalYellow,
                                                  size: 32,
                                                ),
                                                onPressed: () {
                                                  if (currentDayIdx > 0) {
                                                    setModalState(() {
                                                      currentDayIdx--;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                days[currentDayIdx],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                      color: modalYellow,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.arrow_right,
                                                  color: modalYellow,
                                                  size: 32,
                                                ),
                                                onPressed: () {
                                                  if (currentDayIdx <
                                                      days.length - 1) {
                                                    setModalState(() {
                                                      currentDayIdx++;
                                                    });
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Expanded(
                                            child: ListView.builder(
                                              controller: scrollController,
                                              itemCount:
                                                  stationPrograms[stationId]![days[currentDayIdx]]!
                                                      .length,
                                              itemBuilder: (context, idx) {
                                                final p =
                                                    stationPrograms[stationId]![days[currentDayIdx]]![idx];

                                                // Card estilo -- Imagen + contenido a la derecha
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 18.0,
                                                      ),
                                                  child: Card(
                                                    color: Colors.grey[850],
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            14,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Imagen (si existe) o icono
                                                        Container(
                                                          width: 110,
                                                          height: 110,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius.only(
                                                                  topLeft:
                                                                      Radius.circular(
                                                                        14,
                                                                      ),
                                                                  bottomLeft:
                                                                      Radius.circular(
                                                                        14,
                                                                      ),
                                                                ),
                                                            color:
                                                                Colors.black26,
                                                            image:
                                                                p
                                                                    .image
                                                                    .isNotEmpty
                                                                ? DecorationImage(
                                                                    image:
                                                                        p.image.startsWith(
                                                                          'http',
                                                                        )
                                                                        ? NetworkImage(
                                                                            p.image,
                                                                          )
                                                                        : AssetImage(p.image)
                                                                              as ImageProvider,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : null,
                                                          ),
                                                          child: p.image.isEmpty
                                                              ? Icon(
                                                                  Icons
                                                                      .radio_outlined,
                                                                  size: 44,
                                                                  color:
                                                                      modalYellow,
                                                                )
                                                              : null,
                                                        ),

                                                        // Contenido
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  12.0,
                                                                ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                // Título + Ver más en la misma línea
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        p.title,
                                                                        style:
                                                                            Theme.of(
                                                                              context,
                                                                            ).textTheme.titleMedium?.copyWith(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                            ) ??
                                                                            const TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    // "Ver más" inline
                                                                    TextButton(
                                                                      style: TextButton.styleFrom(
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        minimumSize:
                                                                            const Size(
                                                                              40,
                                                                              20,
                                                                            ),
                                                                        tapTargetSize:
                                                                            MaterialTapTargetSize.shrinkWrap,
                                                                      ),
                                                                      onPressed: () {
                                                                        // Mostrar diálogo con más info
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder: (_) {
                                                                            return AlertDialog(
                                                                              backgroundColor: Colors.grey[900],
                                                                              title: Text(
                                                                                p.title,
                                                                                style: const TextStyle(
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              content: SingleChildScrollView(
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    if (p.image.isNotEmpty)
                                                                                      ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(
                                                                                          8,
                                                                                        ),
                                                                                        child:
                                                                                            p.image.startsWith(
                                                                                              'http',
                                                                                            )
                                                                                            ? Image.network(
                                                                                                p.image,
                                                                                                height: 150,
                                                                                                fit: BoxFit.cover,
                                                                                                errorBuilder:
                                                                                                    (
                                                                                                      c,
                                                                                                      e,
                                                                                                      s,
                                                                                                    ) => const SizedBox.shrink(),
                                                                                              )
                                                                                            : Image.asset(
                                                                                                p.image,
                                                                                                height: 150,
                                                                                                fit: BoxFit.cover,
                                                                                                errorBuilder:
                                                                                                    (
                                                                                                      c,
                                                                                                      e,
                                                                                                      s,
                                                                                                    ) => const SizedBox.shrink(),
                                                                                              ),
                                                                                      ),
                                                                                    const SizedBox(
                                                                                      height: 12,
                                                                                    ),
                                                                                    Text(
                                                                                      p.description,
                                                                                      style: const TextStyle(
                                                                                        color: Colors.white70,
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 12,
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: p.schedule.entries.map(
                                                                                        (
                                                                                          entry,
                                                                                        ) {
                                                                                          return Text(
                                                                                            '${entry.key}: ${entry.value}',
                                                                                            style: TextStyle(
                                                                                              color: modalYellow,
                                                                                              fontWeight: FontWeight.w600,
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      ).toList(),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              actions: [
                                                                                TextButton(
                                                                                  onPressed: () => Navigator.pop(
                                                                                    context,
                                                                                  ),
                                                                                  child: const Text(
                                                                                    'Cerrar',
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child: Text(
                                                                        'Ver más',
                                                                        style: TextStyle(
                                                                          color:
                                                                              modalYellow,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),

                                                                const SizedBox(
                                                                  height: 6,
                                                                ),

                                                                // Horarios (puede haber varios)
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: p
                                                                      .schedule
                                                                      .entries
                                                                      .map(
                                                                        (
                                                                          entry,
                                                                        ) => Text(
                                                                          '${entry.key}: ${entry.value}',
                                                                          style:
                                                                              Theme.of(
                                                                                context,
                                                                              ).textTheme.bodyMedium?.copyWith(
                                                                                color: modalYellow,
                                                                                fontWeight: FontWeight.w600,
                                                                              ) ??
                                                                              TextStyle(
                                                                                color: modalYellow,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                        ),
                                                                      )
                                                                      .toList(),
                                                                ),

                                                                const SizedBox(
                                                                  height: 8,
                                                                ),

                                                                // Descripción corta
                                                                Text(
                                                                  p.description,
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodyMedium
                                                                      ?.copyWith(
                                                                        color: Colors
                                                                            .white70,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 60,
                              height: 6,
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            Text(
                              'Programación',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: primaryYellow,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
    final double drawerWidth = MediaQuery.of(context).size.width * 0.25;

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: drawerWidth,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.grey[900]!.withOpacity(0.9),
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10),
            ],
          ),
          child: Column(
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
                      color: primaryColor,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        item['asset'] as String,
                        width: 30,
                        height: 30,
                        fit: BoxFit.scaleDown,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.link, color: Colors.black, size: 20),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);

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
