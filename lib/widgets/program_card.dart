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
    // Usamos el color primario del tema para acentuar el diseño
    final Color primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      // Define un tamaño fijo para hacerla "más grande" y consistente
      child: SizedBox(
        width: 340, // Más ancho
        height: 400, // Más alto
        child: Card(
          // Eliminamos la elevación por defecto de Card si vamos a usar BoxShadow
          elevation: 0,
          color: Colors.grey[900], // Fondo oscuro para contraste
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_cardRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_cardRadius),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Área de la Imagen con Sombreado
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Imagen del Programa
                        Image.asset(
                          program.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.black,
                                child: Icon(
                                  Icons.live_tv,
                                  color: primaryColor,
                                  size: 40,
                                ),
                              ),
                        ),
                        // Gradiente Overlay para asegurar que el texto sea visible
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black54],
                              stops: [0.6, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Área del Título y Hora (Listado más compacto)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Título del Programa (Más grande y audaz)
                        Text(
                          program.title,
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Hora del Programa (Acento en color primario)
                        Text(
                          program.time,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
