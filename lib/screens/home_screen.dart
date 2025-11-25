// Archivo: lib/screens/home_screen.dart (VERSIÓN FINAL Y LIMPIA)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/constants.dart'; // Contiene la lista 'stations'
import '../helpers/providers/audio_provider.dart';
import '../widgets/station_card.dart';
import '../widgets/program_carousel.dart';
import '../models/program_model.dart';
// import '../models/station_model.dart'; // No necesario si solo usamos 'stations'

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Lista de programas de demostración
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

  // ¡NOTA IMPORTANTE!
  // La línea "final List<StationModel> stations = kDummyStations;" ha sido ELIMINADA.
  // Ahora, la variable 'stations' se usa directamente en el ListView.builder,
  // ya que se importa desde '../helpers/constants.dart'.

  @override
  Widget build(BuildContext context) {
    final audioProv = Provider.of<AudioProvider>(context);

    return Scaffold(
      // -------------------------------------------------------------
      // 1. MENÚ LATERAL (DRAWER)
      // -------------------------------------------------------------
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Header del Drawer
            Container(
              height: 150,
              decoration: const BoxDecoration(color: Colors.red),
            ),
            // Opciones del Menú
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
      // 2. BODY: ENCABEZADO Y CONTENIDO
      // -------------------------------------------------------------
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 📣 ENCABEZADO PERSONALIZADO (FINO)
          SizedBox(
            height: 120,
            width: double.infinity,
            child: Stack(
              children: [
                // 2.1. Fondo del Header: color sólido
                Positioned.fill(child: Container(color: Colors.red)),

                // 2.2. Contenido de la barra (Solo Menú)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // ☰ BOTÓN PARA ABRIR DRAWER
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

          /// 📜 CONTENIDO PRINCIPAL DESPLAZABLE
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
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

                    // LISTA DE ESTACIONES (Usando ListView y StationCard)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),

                      // USANDO LA VARIABLE 'stations' IMPORTADA CORRECTAMENTE
                      itemCount: stations.length,

                      itemBuilder: (context, index) {
                        final s = stations[index];

                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10.0,
                          ), // Espacio entre tarjetas
                          child: StationCard(
                            station: s,
                            onTap: () async {
                              // Lógica para reproducir y mostrar el BottomSheet
                              await audioProv.setStation(s);
                              await audioProv.play();

                              // Muestra el reproductor modal
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                builder: (_) => _buildPlayerSheet(context),
                              );
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔊 BottomSheet del reproductor
  Widget _buildPlayerSheet(BuildContext context) {
    final audioProv = Provider.of<AudioProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(20),
      height: 260,
      child: Column(
        children: [
          // Barra de agarre del modal
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Nombre y eslogan (usando el currentStation)
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
          // Controles de Play/Pause
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
