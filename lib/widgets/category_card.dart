import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final int index;
  final VoidCallback onTap;

  static const List<Color> pastelPalette = [
    Color(0xFFB4D4F7), // Soft Blue
    Color(0xFFB8E6C9), // Soft Green
    Color(0xFFF5E6A3), // Soft Yellow
    Color(0xFFD9C2F0), // Soft Purple
    Color(0xFFF7C6D9), // Soft Pink
    Color(0xFFF5C99B), // Soft Orange
  ];

  const CategoryCard({
    super.key,
    required this.category,
    required this.index,
    required this.onTap,
  });

  IconData _getCategoryIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('general')) return Icons.public_rounded;
    if (lower.contains('book')) return Icons.menu_book_rounded;
    if (lower.contains('film') || lower.contains('movie')) return Icons.movie_creation_rounded;
    if (lower.contains('music')) return Icons.music_note_rounded;
    if (lower.contains('theater') || lower.contains('theatre')) return Icons.theater_comedy_rounded;
    if (lower.contains('television') || lower.contains('tv')) return Icons.tv_rounded;
    if (lower.contains('video game')) return Icons.sports_esports_rounded;
    if (lower.contains('board game')) return Icons.extension_rounded;
    if (lower.contains('science & nature') || lower.contains('nature')) return Icons.nature_people_rounded;
    if (lower.contains('computer')) return Icons.computer_rounded;
    if (lower.contains('math')) return Icons.calculate_rounded;
    if (lower.contains('mythology')) return Icons.auto_awesome_rounded;
    if (lower.contains('sport')) return Icons.sports_soccer_rounded;
    if (lower.contains('geography')) return Icons.map_rounded;
    if (lower.contains('history')) return Icons.history_edu_rounded;
    if (lower.contains('politics')) return Icons.gavel_rounded;
    if (lower.contains('art')) return Icons.palette_rounded;
    if (lower.contains('celebrity') || lower.contains('celebrities')) return Icons.star_rounded;
    if (lower.contains('animal')) return Icons.pets_rounded;
    if (lower.contains('vehicle')) return Icons.directions_car_rounded;
    if (lower.contains('comic')) return Icons.menu_book_sharp;
    if (lower.contains('gadget')) return Icons.devices_rounded;
    if (lower.contains('anime') || lower.contains('manga')) return Icons.animation_rounded;
    if (lower.contains('cartoon')) return Icons.child_care_rounded;
    return Icons.category_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = pastelPalette[index % pastelPalette.length];
    final iconData = _getCategoryIcon(category.name);

    return Semantics(
      button: true,
      label: 'Select category ${category.name}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: bgColor.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon container
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 64,
                      height: 64,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        iconData,
                        size: 36,
                        color: const Color(0xFF2C3E50),
                      ),
                    ),
                  ),

                  // Category Name
                  Text(
                    category.name.replaceAll('Entertainment: ', '').replaceAll('Science: ', ''),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
