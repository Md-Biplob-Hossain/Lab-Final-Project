import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  String? _getCategorySvgPath(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('general knowledge')) {
      return 'assets/images/categories/general_knowledge.svg';
    }
    if (lower.contains('book')) {
      return 'assets/images/categories/books.svg';
    }
    if (lower.contains('film')) {
      return 'assets/images/categories/film.svg';
    }
    if (lower.contains('music') && (lower.contains('theatre') || lower.contains('musical'))) {
      return 'assets/images/categories/musicals_theatres.svg';
    }
    if (lower.contains('music')) {
      return 'assets/images/categories/music.svg';
    }
    if (lower.contains('television')) {
      return 'assets/images/categories/television.svg';
    }
    if (lower.contains('video game')) {
      return 'assets/images/categories/video_games.svg';
    }
    if (lower.contains('board game')) {
      return 'assets/images/categories/board_games.svg';
    }
    if (lower.contains('science') && lower.contains('computer')) {
      return 'assets/images/categories/computers.svg';
    }
    if (lower.contains('science') && lower.contains('math')) {
      return 'assets/images/categories/mathematics.svg';
    }
    if (lower.contains('science') || lower.contains('nature')) {
      return 'assets/images/categories/science.svg';
    }
    if (lower.contains('mytholog')) {
      return 'assets/images/categories/mythology.svg';
    }
    if (lower.contains('sport')) {
      return 'assets/images/categories/sports.svg';
    }
    if (lower.contains('geograph')) {
      return 'assets/images/categories/geography.svg';
    }
    if (lower.contains('history')) {
      return 'assets/images/categories/history.svg';
    }
    if (lower.contains('politic')) {
      return 'assets/images/categories/politics.svg';
    }
    if (lower.contains('art')) {
      return 'assets/images/categories/art.svg';
    }
    if (lower.contains('celebrit')) {
      return 'assets/images/categories/celebrities.svg';
    }
    if (lower.contains('animal')) {
      return 'assets/images/categories/animals.svg';
    }
    if (lower.contains('vehicle')) {
      return 'assets/images/categories/vehicles.svg';
    }
    if (lower.contains('comic')) {
      return 'assets/images/categories/comics.svg';
    }
    if (lower.contains('gadget')) {
      return 'assets/images/categories/gadgets.svg';
    }
    if (lower.contains('anime') || lower.contains('manga')) {
      return 'assets/images/categories/anime_manga.svg';
    }
    if (lower.contains('cartoon') || lower.contains('animation')) {
      return 'assets/images/categories/cartoon_animations.svg';
    }
    return null;
  }

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

  Widget _buildIllustration(String name, IconData fallbackIcon) {
    final svgPath = _getCategorySvgPath(name);

    Widget buildFallbackIcon() {
      return LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxHeight * 0.6;
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              fallbackIcon,
              size: size * 0.55,
              color: const Color(0xFF2C3E50),
            ),
          );
        },
      );
    }

    if (svgPath == null) {
      return buildFallbackIcon();
    }

    return Transform.scale(
      scale: 1.3,
      child: SvgPicture.asset(
        svgPath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        placeholderBuilder: (context) => buildFallbackIcon(),
        errorBuilder: (context, error, stackTrace) => buildFallbackIcon(),
      ),
    );
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Upper 80-85% area for large edge-to-edge illustration
                  Expanded(
                    flex: 8,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                      child: _buildIllustration(category.name, iconData),
                    ),
                  ),

                  // Bottom 15-20% strip for category title
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          category.name
                              .replaceAll('Entertainment: ', '')
                              .replaceAll('Science: ', ''),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                            height: 1.1,
                          ),
                        ),
                      ),
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



