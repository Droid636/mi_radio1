import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> programs = [
      {'image': 'assets/images/Program1.jpg'},
      {'image': 'assets/images/Program2.jpg'},
      {'image': 'assets/images/Program3.jpg'},
      {'image': 'assets/images/Program4.jpg'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding'),
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
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  program['image']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.black12,
                    child: const Center(
                      child: Icon(Icons.radio, size: 50, color: Colors.black),
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
