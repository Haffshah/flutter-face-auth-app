import 'package:face_match/framework/controller/splash/splash_controller.dart';
import 'package:face_match/framework/dependency_injection/inject.dart';
import 'package:face_match/ui/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:face_match/framework/utils/extension/string_extension.dart';
import 'package:face_match/ui/utils/theme/app_strings.g.dart';


final splashControllerProvider = ChangeNotifierProvider.autoDispose<SplashController>(
  (ref) => getIt<SplashController>(),
);

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _animationController.forward();

    // Trigger logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashControllerProvider).init(ref);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo - Clean and simple
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(color: AppColors.backgroundCard, shape: BoxShape.circle),
                child: Icon(Icons.face_retouching_natural_rounded, size: 80, color: AppColors.primary),
              ),
              const SizedBox(height: 32),

              // Title - Clean typography
              Text(
                LocaleKeys.keyFaceMatch.localized,
                style: GoogleFonts.outfit(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle - Subtle
              Text(
                LocaleKeys.keySecureFastReliable.localized,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 80),

              // Loader - Simple and clean
              LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primary, size: 40),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.keyInitializing.localized,
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary, letterSpacing: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
