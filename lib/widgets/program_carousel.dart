import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/program_model.dart';
import 'program_card.dart';

class ProgramCarousel extends StatelessWidget {
  final List<ProgramModel> programs;

  const ProgramCarousel({super.key, required this.programs});

  void _showProgramDetailsModal(BuildContext context, ProgramModel p) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        insetPadding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
                child: Stack(
                  children: [
                    Image.asset(
                      p.image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Center(
                          child: Icon(
                            Icons.radio,
                            size: 50,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, size: 28),
                        color: Colors.white,
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.zoom_out_map, size: 28),
                        color: Colors.white,
                        tooltip: 'Ampliar imagen',
                        onPressed: () {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              backgroundColor: Colors.black,
                              insetPadding: const EdgeInsets.all(0),
                              child: Stack(
                                children: [
                                  InteractiveViewer(
                                    child: Image.asset(
                                      p.image,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                color: Colors.black,
                                                child: Icon(
                                                  Icons.radio,
                                                  color: Colors.white,
                                                  size: 80,
                                                ),
                                              ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 16,
                                    left: 16,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        size: 32,
                                      ),
                                      color: Colors.white,
                                      tooltip: 'Cerrar imagen',
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.black
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 20.0,
                  right: 20.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    p.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Descripción',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      p.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 20.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time, size: 20, color: Colors.black),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: p.schedule.entries.map((entry) {
                          final today = DateTime.now();
                          final diasSemana = {
                            'Lunes': 1,
                            'Martes': 2,
                            'Miércoles': 3,
                            'Jueves': 4,
                            'Viernes': 5,
                            'Sábado': 6,
                            'Domingo': 7,
                          };
                          final isToday =
                              diasSemana[entry.key] == today.weekday;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 12.0,
                            ),
                            decoration: BoxDecoration(
                              color: isToday ? Color(0xFFFFD700) : Colors.white,
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${entry.key}: ${entry.value}',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return CarouselSlider(
      items: programs
          .map(
            (p) => Container(
              width: MediaQuery.of(context).size.width,
              child: ProgramCard(
                program: p,
                onTap: () => _showProgramDetailsModal(context, p),
              ),
            ),
          )
          .toList(),
      options: CarouselOptions(
        height: screenHeight * 0.48,
        enlargeCenterPage: true,
        autoPlay: false,
        aspectRatio: 1.0,
        enableInfiniteScroll: false,
        viewportFraction: 1.0,
      ),
    );
  }
}
