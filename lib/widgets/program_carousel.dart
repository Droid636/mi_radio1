import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/program_model.dart';
import 'program_card.dart'; // Importa la tarjeta estilizada

class ProgramCarousel extends StatelessWidget {
  final List<ProgramModel> programs;

  const ProgramCarousel({super.key, required this.programs});

  // Función para mostrar el modal estilizado (Diseño del Pop-up)
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
              // Imagen superior con botón de ampliar
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
                    // Gradiente sutil
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
                    // Botón 'X' de cierre
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
                    // Botón de ampliar imagen
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
                                      errorBuilder: (context, error, stackTrace) => Container(
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
                                      icon: const Icon(Icons.close_rounded, size: 32),
                                      color: Colors.white,
                                      tooltip: 'Cerrar imagen',
                                      onPressed: () => Navigator.of(context).pop(),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.black.withOpacity(0.5),
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
              // Título debajo de la imagen
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
              // Descripción
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
              // Horario en caja con borde negro (ahora al final)
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
                      Text(
                        p.time,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
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
    return CarouselSlider(
      items: programs
          .map(
            (p) => ProgramCard(
              program: p,
              onTap: () => _showProgramDetailsModal(context, p),
            ),
          )
          .toList(),
      options: CarouselOptions(
        height: 420, // Más alto para cards grandes
        enlargeCenterPage: true,
        autoPlay: false,
        aspectRatio: 1.0,
        enableInfiniteScroll: false,
        viewportFraction: 0.95, // Solo se ve un card a la vez
      ),
    );
  }
}
