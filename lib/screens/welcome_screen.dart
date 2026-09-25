import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_rounded_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const Spacer(),

              // Top Centered Decorative Illustration
              SvgPicture.asset(
                'assets/images/welcome_illustration.svg',
                height: 200,
                fit: BoxFit.contain,
                placeholderBuilder: (BuildContext context) => const Icon(Icons.quiz, size: 100),
              ),

              const SizedBox(height: 32),

              // Large Title
              const Text(
                'Quizzical',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle Text (placeholder name / welcome text matching Figma)
              const Text(
                'Your_Name',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),

              const Spacer(),

              // Bottom Button "GET STARTED"
              CustomRoundedButton(
                text: 'GET STARTED',
                color: const Color(0xFF0F4C4C),
                onPressed: () {
                  Navigator.pushNamed(context, '/categories');
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
