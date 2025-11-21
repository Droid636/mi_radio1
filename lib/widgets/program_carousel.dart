import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/program_model.dart';
import 'program_card.dart';

class ProgramCarousel extends StatelessWidget {
  final List<ProgramModel> programs;

  const ProgramCarousel({super.key, required this.programs});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: programs
          .map(
            (p) => ProgramCard(
              program: p,
              onTap: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(p.title),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(p.description),
                      SizedBox(height: 8),
                      Text('Horario: ${p.time}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cerrar'),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
      options: CarouselOptions(
        height: 220,
        enlargeCenterPage: true,
        autoPlay: false,
      ),
    );
  }
}
