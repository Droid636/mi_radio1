// Archivo: lib/screens/home_screen.dart (Banner integrado en el AppBar)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/constants.dart';
import '../helpers/providers/audio_provider.dart';
import '../widgets/station_card.dart';
import '../widgets/program_carousel.dart';
import '../models/program_model.dart';

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

  final double kAppBarHeightWithBanner = 56.0 + 120.0;

  @override
  Widget build(BuildContext context) {
    final audioProv = Provider.of<AudioProvider>(context);

    return Scaffold(
      // -----------------------------------------------------------------
      // 1. APPBAR CON IMAGEN (Usando PreferredSize para altura personalizada)
      // -----------------------------------------------------------------
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kAppBarHeightWithBanner),
        child: AppBar(
          title: const Text(
            'Radioactiva TX',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,

          // El botón del menú lateral (Drawer) aparecerá automáticamente aquí.
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // El Banner se coloca DENTRO del AppBar, justo debajo del título/botones
              Image.asset(
                'assets/images/banner.png', // <--- RUTA DE TU IMAGEN HORIZONTAL
                width: double.infinity,
                height: 120, // Altura delgada del banner
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),

      // -----------------------------------------------------------------
      // 2. MENÚ LATERAL (DRAWER) - Se mantiene igual
      // -----------------------------------------------------------------
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Text(
                'Radioactiva TX',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.radio),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favoritos'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Acerca de'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      // -----------------------------------------------------------------
      // 3. BODY: El cuerpo ahora solo necesita el contenido desplazable
      // -----------------------------------------------------------------
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ya no necesitamos el banner aquí, estaba en el AppBar

                /// ---------- ESTACIONES ----------
                Text(
                  'Estaciones',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stations.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.88,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final s = stations[index];
                    return StationCard(
                      station: s,
                      onTap: () async {
                        await audioProv.setStation(s);
                        await audioProv.play();

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          builder: (_) => _buildPlayerSheet(context),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 20),

                /// ---------- PROGRAMAS ----------
                Text(
                  'Programas',
                  style: Theme.of(context).textTheme.titleLarge,
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

  // ... (El widget _buildPlayerSheet se mantiene sin cambios)
  Widget _buildPlayerSheet(BuildContext context) {
    final audioProv = Provider.of<AudioProvider>(context, listen: false);
    // ... (El contenido de _buildPlayerSheet es el mismo)
    return Container(
      padding: const EdgeInsets.all(20),
      height: 260,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Text(
            audioProv.currentStation?.name ?? "Sin estación",
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 8),

          Text(
            audioProv.currentStation?.slogan ?? "",
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 48,
                icon: const Icon(Icons.play_circle_fill),
                onPressed: () => audioProv.play(),
              ),
              const SizedBox(width: 20),
              IconButton(
                iconSize: 48,
                icon: const Icon(Icons.pause_circle_filled),
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
