// Archivo: lib/screens/home_screen.dart (VERSIÓN FINAL CON DISEÑO Y MODAL RESTAURADO)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/constants.dart'; // Contiene 'stations'
import '../helpers/providers/audio_provider.dart'; // Contiene AudioProvider
import '../widgets/station_card.dart';
import '../widgets/program_carousel.dart';
import '../models/program_model.dart';
import '../app_theme.dart'; // Para acceder a colores específicos (primaryYellow, accentRedOrange)

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<ProgramModel> demoPrograms = const [
    ProgramModel(
      id: 'p1',
      title: 'Mañana Jazz',
      description: 'Lo mejor del jazz matutino',
      time: '08:00 - 10:00',
      image: 'assets/images/program1.jpg',
    ),
    ProgramModel(
      id: 'p2',
      title: 'Tarde Alterna',
      description: 'Programa alternativo para la tarde',
      time: '16:00 - 18:00',
      image: 'assets/images/program2.jpg',
    ),
  ];

  // Altura para la imagen de cabecera
  final double kAppBarImageHeight = 180.0;

  @override
  Widget build(BuildContext context) {
    // Usamos listen: true aquí para que el Scaffold sepa si mostrar el BottomPlayer si decides usarlo.
    final audioProv = Provider.of<AudioProvider>(context);

    return Scaffold(
      // -----------------------------------------------------------------
      // 1. APPBAR CON IMAGEN DE CABECERA Y LOGO
      // -----------------------------------------------------------------
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kAppBarImageHeight),
        child: AppBar(
          title: null,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),

          flexibleSpace: Stack(
            children: [
              // Imagen de Fondo
              Positioned.fill(
                child: Image.asset(
                  'assets/images/header_background.jpg', // <--- RUTA DE IMAGEN ARTÍSTICA
                  fit: BoxFit.cover,
                ),
              ),
              // Logo R_TX superpuesto
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Image.asset(
                    'assets/images/logo_tx.png', // <--- RUTA DE TU LOGO (R_TX)
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // -----------------------------------------------------------------
      // 2. MENÚ LATERAL (DRAWER) - Diseño finalizado
      // -----------------------------------------------------------------
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // CABECERA DEL DRAWER
            DrawerHeader(
              decoration: const BoxDecoration(
                color: primaryYellow, // Color Amarillo
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/images/logo_tx.png',
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // ÍTEMS DEL DRAWER
            _buildDrawerItem(context, 'Compartir con un amigo', Icons.share),
            _buildDrawerItem(context, '¡Califica nuestra app!', Icons.star),
            _buildDrawerItem(context, 'Nuestra Misión', Icons.groups),
            _buildDrawerItem(context, 'Política de Privacidad', Icons.policy),
            _buildDrawerItem(context, 'Escúchanos en', Icons.radio),

            const Divider(),
            _buildDrawerItem(
              context,
              'Versión 1.1.8',
              Icons.info_outline,
              isVersion: true,
            ),
          ],
        ),
      ),

      // -----------------------------------------------------------------
      // 3. BODY: Contenido principal (Secciones y Estaciones)
      // -----------------------------------------------------------------
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---------- ESTACIONES ----------
                _buildSectionTitle(context, 'Nuestras', 'Estaciones'),
                const SizedBox(height: 10),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stations.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        1, // Una sola columna para diseño horizontal
                    childAspectRatio: 5.0, // Ajusta la altura del Card
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final s = stations[index];
                    return StationCard(
                      station: s,
                      onTap: () async {
                        // Lógica de reproducción:
                        await audioProv.setStation(s);
                        await audioProv.play();

                        // Muestra el reproductor modal (Bottom Sheet)
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors
                              .transparent, // Permite que el Container defina el color
                          builder: (_) => _buildPlayerSheet(context),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 20),

                /// ---------- PROGRAMAS ----------
                _buildSectionTitle(
                  context,
                  'Nuestros',
                  'Programas',
                  showViewAll: true,
                ),
                const SizedBox(height: 10),
                ProgramCarousel(programs: demoPrograms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------------
  // WIDGETS AUXILIARES
  // -----------------------------------------------------------------

  // WIDGET PARA LOS ÍTEMS DEL DRAWER
  Widget _buildDrawerItem(
    BuildContext context,
    String title,
    IconData icon, {
    bool isVersion = false,
  }) {
    // Usamos el color de acento definido en app_theme.dart
    final colorIcono = isVersion ? Colors.grey[600] : accentRedOrange;
    final colorTexto = isVersion ? Colors.black54 : Colors.black;

    return ListTile(
      leading: Icon(icon, color: colorIcono),
      title: Text(
        title,
        style: TextStyle(
          fontSize: isVersion ? 14 : 16,
          color: colorTexto,
          fontWeight: isVersion ? FontWeight.normal : FontWeight.w500,
        ),
      ),
      onTap: () => Navigator.pop(context),
    );
  }

  // WIDGET PARA LOS TÍTULOS DE SECCIÓN
  Widget _buildSectionTitle(
    BuildContext context,
    String part1,
    String part2, {
    bool showViewAll = false,
  }) {
    final yellowColor = Theme.of(context).primaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              part1,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              part2,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: yellowColor,
              ),
            ),
          ],
        ),
        if (showViewAll)
          TextButton(
            onPressed: () {},
            child: const Text(
              'Ver Todos',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
      ],
    );
  }

  // WIDGET DEL REPRODUCTOR MODAL (CARD PLAYER RESTAURADO)
  Widget _buildPlayerSheet(BuildContext context) {
    // Usamos listen: false ya que es un modal temporal.
    final audioProv = Provider.of<AudioProvider>(context, listen: false);
    final yellowColor = Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.all(20),
      height: 260,
      decoration: const BoxDecoration(
        color: Colors.white, // Fondo blanco para el Card Player
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Barra de arrastre (Handle)
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Título de la Estación
          Text(
            audioProv.currentStation?.name ?? "Sin estación",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          // Eslogan
          Text(
            audioProv.currentStation?.slogan ?? "",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),

          const Spacer(),

          // Controles (Botones Play/Pause)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botón de Play
              IconButton(
                iconSize: 48,
                icon: Icon(Icons.play_circle_fill, color: yellowColor),
                onPressed: () => audioProv.play(),
              ),
              const SizedBox(width: 20),
              // Botón de Pausa
              IconButton(
                iconSize: 48,
                icon: Icon(Icons.pause_circle_filled, color: yellowColor),
                onPressed: () => audioProv.pause(),
              ),
            ],
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
