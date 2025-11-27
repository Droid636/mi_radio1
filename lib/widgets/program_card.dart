import 'package:flutter/material.dart';
import '../models/program_model.dart';

class ProgramCard extends StatelessWidget {
  final ProgramModel program;
  final VoidCallback onTap;

  const ProgramCard({super.key, required this.program, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            Expanded(child: Image.asset(program.image, fit: BoxFit.cover)),
            ListTile(title: Text(program.title), subtitle: Text(program.time)),
          ],
        ),
      ),
    );
  }
}
