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
      builder: (_) {
        bool showMore = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
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
                            errorBuilder: (context, error, stackTrace) =>
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
                                                    const Icon(
                                                      Icons.radio,
                                                      size: 80,
                                                      color: Colors.white,
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

                    /// ------------------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 20,
                        right: 20,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          p.title,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),

                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: showMore
                                      ? p.description
                                      : (p.description.length > 160
                                            ? p.description.substring(0, 160) +
                                                  "… "
                                            : p.description),
                                ),

                                if (p.description.length > 160)
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.baseline,
                                    baseline: TextBaseline.alphabetic,
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => showMore = !showMore),
                                      child: Text(
                                        showMore ? "Ver menos" : "Ver más",
                                        style: const TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Horarios de emisión',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                          ),
                          const SizedBox(height: 16),

                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
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

                              final bool isToday =
                                  diasSemana[entry.key] == today.weekday;

                              return Container(
                                width: MediaQuery.of(context).size.width * 0.38,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? const Color(0xFFFFD700)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
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
                                    const SizedBox(height: 10),
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
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return CarouselSlider(
      items: programs
          .map(
            (p) => SizedBox(
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
