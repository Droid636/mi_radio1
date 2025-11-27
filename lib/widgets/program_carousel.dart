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
        // Diálogo con esquinas redondeadas y padding ajustado
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        insetPadding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Cabecera con Imagen, Título y Botón 'X'
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
                child: Stack(
                  children: [
                    // Imagen del Programa (Ocupa la parte superior del modal)
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
                    // Título del programa superpuesto
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Text(
                        p.title,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                const Shadow(
                                  blurRadius: 5,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                      ),
                    ),

                    // *** Botón 'X' de Cierre en la Esquina Superior Derecha ***
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, size: 28),
                        color: Colors
                            .white, // Color blanco para destacar sobre la imagen
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          // Pequeño fondo para asegurar la visibilidad del 'X'
                          backgroundColor: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Contenido y Descripción
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hora del programa con estilo de acento
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          p.time,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const Divider(height: 30),

                    // Descripción del programa
                    Text(
                      'Acerca de este programa:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      p.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                    // Eliminamos el SizedBox de 30 y el botón de cierre inferior
                    const SizedBox(height: 10), // Pequeño espacio al final
                  ],
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
              // Usamos la función del modal estilizado aquí
              onTap: () => _showProgramDetailsModal(context, p),
            ),
          )
          .toList(),
      options: CarouselOptions(
        // Ajustamos la altura para la ProgramCard estilizada
        height: 370,
        enlargeCenterPage: true,
        autoPlay: false,
        aspectRatio: 1.0,
        enableInfiniteScroll: false,
        viewportFraction: 0.75,
      ),
    );
  }
}
