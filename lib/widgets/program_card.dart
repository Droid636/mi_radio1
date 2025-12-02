import 'package:flutter/material.dart';
import '../models/program_model.dart'; // Asume que este archivo existe

class ProgramCard extends StatelessWidget {
  final ProgramModel program;
  final VoidCallback onTap;

  const ProgramCard({super.key, required this.program, required this.onTap});

  // Estilo de sombra y bordes para la tarjeta
  static const double _cardRadius = 18.0;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 340,
        height: 400,
        child: Card(
          elevation: 0,
          color: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_cardRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_cardRadius),
            child: Stack(
              children: [
                // Imagen del Programa con sombreado abajo
                Positioned.fill(
                  child: Image.asset(
                    program.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.black,
                      child: Icon(Icons.live_tv, color: primaryColor, size: 40),
                    ),
                  ),
                ),
                // Sombreado abajo
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 80,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                        stops: [0.0, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
