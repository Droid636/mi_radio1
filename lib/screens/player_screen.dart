import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  // Controlador de Animación para la rotación del disco
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador de animación
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Velocidad de rotación
    )..repeat(); // Repite la animación indefinidamente
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioProv = Provider.of<AudioProvider>(context);
    final station = audioProv.currentStation;

    // Colores del tema para consistencia
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

    // El disco gira solo si está sonando
    if (audioProv.isPlaying) {
      _rotationController.isAnimating ? null : _rotationController.repeat();
    } else {
      _rotationController.stop();
    }

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

                    // Botón de Menú/Opciones
                    IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: primaryYellow,
                        size: 32,
                      ),
                      onPressed: () {
                        // Lógica para abrir opciones o menú
                      },
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
                // *** SE ELIMINA LA LÍNEA DE TÍTULO DE CANCIÓN ***

                // Nombre de la Estación (Radioactiva Tx)
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
                const SizedBox(height: 4),

                // Descripción o ubicación
                // Se deja el slogan como body, ahora solo en un lugar.
                /*Text(
                  station.slogan, 
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white70,
                      ),
                  textAlign: TextAlign.center,
                ),*/
                const Spacer(),

                // --- BOTÓN CENTRAL DE PLAY/PAUSE ---
                Consumer<AudioProvider>(
                  builder: (context, audioProv, child) {
                    final isPlaying = audioProv.isPlaying;

                    return IconButton(
                      iconSize: 100, // Ícono muy grande
                      onPressed: () {
                        if (isPlaying) {
                          audioProv.pause();
                        } else {
                          audioProv.play();
                        }
                        // La lógica de rotación se maneja en el build/Consumer
                      },
                      icon: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryYellow, // Fondo del botón en amarillo
                          boxShadow: [
                            BoxShadow(
                              color: primaryYellow.withOpacity(0.5),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.black, // Ícono negro sobre amarillo
                          size: 45,
                        ),
                      ),
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
