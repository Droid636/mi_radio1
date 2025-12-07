import 'package:flutter/material.dart';
import '../models/program_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Estado para el switch "separar por estación"
  bool separarPorEstacion = false;

  // Método para obtener el día de la semana actual en español
  String _diaSemanaActual() {
    final dias = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    final hoy = DateTime.now().weekday; // 1 = lunes, 7 = domingo
    return dias[hoy - 1];
  }

  @override
  Widget build(BuildContext context) {
    // 1. Definición de la lista de programas
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
      // El programa 'p4' estaba incompleto, asumo que debería ser similar a los demás.
      // Lo he añadido aquí con un título genérico para que el código compile.
      ProgramModel(
        id: 'p4',
        title: 'Noche Clásica',
        description: 'Música clásica y opera.',
        schedule: {'Jueves': '20:00 - 22:00', 'Sábado': '18:00 - 20:00'},
        image: 'assets/images/Program4.jpg',
      ),
    ];

    // 2. Comienzo del retorno del Scaffold con la estructura de la interfaz de usuario
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            // Título de la pantalla
            Expanded(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: 'Nuestros '),
                    TextSpan(
                      text: 'Programas',
                      style: TextStyle(color: Colors.yellow),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Etiqueta "Por estación"
            const Text(
              'Por estación',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // Switch para separar por estación
            Switch(
              value: separarPorEstacion,
              onChanged: (val) {
                setState(() {
                  separarPorEstacion = val;
                });
              },
            ),
          ],
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: separarPorEstacion
                ? DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        // TabBar visible cuando separarPorEstacion es true
                        Container(
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: const TabBar(
                            indicatorColor: Colors.yellow,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            tabs: [
                              Tab(text: 'Radioactiva TX'),
                              Tab(text: 'Live Jazz'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              // Contenido de la pestaña Radioactiva TX
                              _ProgramGrid(
                                programs: programs,
                                diaActual: _diaSemanaActual(),
                              ),
                              // Contenido de la pestaña Live Jazz (vacío según tu código original)
                              const Center(
                                child: Text(
                                  'No hay programas disponibles',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                // GridView simple cuando separarPorEstacion es false
                : _ProgramGrid(
                    programs: programs,
                    diaActual: _diaSemanaActual(),
                  ),
          ),
        ],
      ),
    );
  }
}

// Widget auxiliar para mostrar la cuadrícula de programas
class _ProgramGrid extends StatelessWidget {
  final List<ProgramModel> programs;
  final String diaActual;
  const _ProgramGrid({required this.programs, required this.diaActual});

  // Normaliza el nombre del día para comparar sin tildes ni mayúsculas
  String _normalizeDay(String day) {
    return day
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                            // Sección de la imagen
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
                                // Botones de Zoom y Cerrar en la esquina superior derecha
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Row(
                                    children: [
                                      // Botón de Zoom (Ampliar Imagen)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.zoom_out_map,
                                          size: 26,
                                        ),
                                        color: Colors.white,
                                        tooltip: 'Ampliar imagen',
                                        onPressed: () {
                                          Navigator.pop(
                                            context,
                                          ); // Cerrar el diálogo actual
                                          showDialog(
                                            // Mostrar nuevo diálogo con la imagen ampliada
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
                                                            color:
                                                                Colors.black12,
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
                                      // Botón de Cerrar
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close_rounded,
                                          size: 28,
                                        ),
                                        color: Colors.white,
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Título del programa
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
                            // Descripción del programa
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
                            // Horarios de emisión
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
                                  // Lista de días y horarios
                                  Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: program.schedule.entries.map((
                                      entry,
                                    ) {
                                      final bool esHoy =
                                          _normalizeDay(entry.key) ==
                                          _normalizeDay(diaActual);
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: esHoy
                                              ? Colors.yellow[700]
                                              : Colors.white,
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
            // Contenedor principal del programa en la cuadrícula
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
                  // Builder de error en caso de que la imagen no cargue
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
    );
  }
}
