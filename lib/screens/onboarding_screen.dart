import 'package:flutter/material.dart';
import '../models/program_model.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ProgramModel> programs = [
      ProgramModel(
        id: 'p1',
        title: 'Mañana Alternativa',
        description: 'Rock alternativo y entrevistas exclusivas.',
        schedule: {'Lunes': '08:00 - 10:00', 'Miércoles': '09:00 - 11:00'},
        image: 'assets/images/Program1.jpg',
      ),
      ProgramModel(
        id: 'p2',
        title: 'Tarde Indie',
        description: 'Indie, electrónica y tendencias underground.',
        schedule: {'Lunes': '16:00 - 18:00', 'Jueves': '17:00 - 19:00'},
        image: 'assets/images/Program2.jpg',
      ),
      ProgramModel(
        id: 'p3',
        title: 'Jazz Fusion',
        description: 'Jazz experimental y fusiones modernas.',
        schedule: {'Martes': '10:00 - 12:00', 'Viernes': '11:00 - 13:00'},
        image: 'assets/images/Program3.jpg',
      ),
      ProgramModel(
        id: 'p4',
        title: 'Noches Urbanas',
        description: 'Hip-hop, rap y cultura urbana.',
        schedule: {'Martes': '20:00 - 22:00', 'Sábado': '21:00 - 23:00'},
        image: 'assets/images/Program4.jpg',
      ),
      ProgramModel(
        id: 'p5',
        title: 'Electro Vibes',
        description: 'Electrónica y dance para mitad de semana.',
        schedule: {'Miércoles': '18:00 - 20:00', 'Domingo': '17:00 - 19:00'},
        image: 'assets/images/Program5.jpg',
      ),
      ProgramModel(
        id: 'p6',
        title: 'Retro Hits',
        description: 'Clásicos de los 80s y 90s.',
        schedule: {'Jueves': '14:00 - 16:00', 'Viernes': '15:00 - 17:00'},
        image: 'assets/images/Program6.jpg',
      ),
      ProgramModel(
        id: 'p7',
        title: 'Fiesta Latina',
        description: 'Reggaetón, salsa y ritmos latinos.',
        schedule: {'Viernes': '20:00 - 23:00', 'Sábado': '18:00 - 21:00'},
        image: 'assets/images/Program7.jpg',
      ),
      ProgramModel(
        id: 'p8',
        title: 'Sábado Retro',
        description: 'Lo mejor de los clásicos para el fin de semana.',
        schedule: {'Sábado': '11:00 - 14:00', 'Domingo': '10:00 - 13:00'},
        image: 'assets/images/Program8.jpg',
      ),
      ProgramModel(
        id: 'p9',
        title: 'Domingo Chill',
        description: 'Música relajante para cerrar la semana.',
        schedule: {'Domingo': '19:00 - 22:00', 'Lunes': '21:00 - 23:00'},
        image: 'assets/images/Program9.jpg',
      ),
      ProgramModel(
        id: 'p10',
        title: 'Noches Urbanas 2',
        description: 'Más hip-hop y cultura urbana.',
        schedule: {'Viernes': '22:00 - 00:00', 'Sábado': '23:00 - 01:00'},
        image: 'assets/images/Program10.jpg',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuestros Programas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: programs.length,
          itemBuilder: (context, index) {
            final program = programs[index];
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      insetPadding: const EdgeInsets.all(20),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20.0),
                                    ),
                                    child: Image.asset(
                                      program.image,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                height: 200,
                                                color: Colors.black12,
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.radio,
                                                    size: 50,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.zoom_out_map,
                                            size: 26,
                                          ),
                                          color: Colors.white,
                                          tooltip: 'Ampliar imagen',
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => Dialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                  child: InteractiveViewer(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      child: Image.asset(
                                                        program.image,
                                                        fit: BoxFit.contain,
                                                        errorBuilder:
                                                            (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                            ) => Container(
                                                              color: Colors
                                                                  .black12,
                                                              child: const Center(
                                                                child: Icon(
                                                                  Icons.radio,
                                                                  size: 50,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.close_rounded,
                                            size: 28,
                                          ),
                                          color: Colors.white,
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                  left: 20,
                                  right: 20,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    program.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: Text(
                                  program.description,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 20.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Horarios de emisión',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                    ),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 16,
                                      runSpacing: 16,
                                      children: program.schedule.entries.map((
                                        entry,
                                      ) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              22,
                                            ),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                entry.key,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                entry.value,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    program.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.black12,
                      child: const Center(
                        child: Icon(Icons.radio, size: 50, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
