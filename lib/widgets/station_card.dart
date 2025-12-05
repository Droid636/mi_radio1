import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/station_model.dart';
import '../helpers/providers/audio_provider.dart';

class StationCard extends StatelessWidget {
  final StationModel station;
  final VoidCallback onTap;

  const StationCard({super.key, required this.station, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final audioProv = Provider.of<AudioProvider>(context);
    final isPlaying =
        audioProv.isPlaying && (audioProv.currentStation?.id == station.id);
    final isLoading =
        audioProv.isLoading && (audioProv.currentStation?.id == station.id);
    final icon = isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill;
    final iconColor = isPlaying ? Color(0xFFF55940) : Colors.black;

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: station.image.isNotEmpty
                      ? (station.image.startsWith('http')
                            ? Image.network(
                                station.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                      child: Icon(
                                        Icons.radio,
                                        size: 24,
                                        color: Colors.grey,
                                      ),
                                    ),
                              )
                            : Image.asset(
                                station.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                      child: Icon(
                                        Icons.radio,
                                        size: 24,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ))
                      : Center(
                          child: Icon(
                            Icons.radio,
                            size: 24,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      station.slogan,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: isLoading
                    ? SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      )
                    : Icon(icon, size: 32, color: iconColor),
                onPressed: isLoading
                    ? null
                    : () async {
                        if (isPlaying) {
                          await audioProv.pause();
                        } else {
                          try {
                            await audioProv.setStation(station);
                            await audioProv.play();
                            audioProv.showMiniPlayer();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Comprueba tu conexión a internet',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
