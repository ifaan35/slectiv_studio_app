import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/splash_screen/views/widgets/center_logo.dart';
import 'package:slectiv_studio_app/utils/constants/image_strings.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';

class SlectivSplashDisplay extends StatefulWidget {
  const SlectivSplashDisplay({super.key});

  @override
  State<SlectivSplashDisplay> createState() => _SlectivSplashDisplayState();
}

class _SlectivSplashDisplayState extends State<SlectivSplashDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              // Top section with decorative elements
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(
                        top: size.height * 0.05,
                        right: size.width * 0.1,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: SlectivColors.secondaryBlue.withOpacity(
                                0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.12,
                        left: size.width * 0.15,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: SlectivColors.primaryBlue.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Center section with logo and text
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with scale animation
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [],
                          ),
                          child: const CenterLogo(
                            logo: SlectivImages.applogo,
                            width: 280,
                            height: 90,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tagline with fade animation
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          SlectivTexts.splashTextDesc,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.spaceGrotesk(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: SlectivColors.textGray,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Subtitle
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        "Professional Photo Studio",
                        style: GoogleFonts.spaceGrotesk(
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: SlectivColors.textGray.withOpacity(0.8),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom section with loading indicator
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Loading indicator
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 40),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  SlectivColors.primaryBlue,
                                ),
                                backgroundColor: SlectivColors.secondaryBlue
                                    .withOpacity(0.3),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Loading...",
                              style: GoogleFonts.spaceGrotesk(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: SlectivColors.textGray.withOpacity(
                                    0.7,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom decorative element
                    Container(
                      height: 4,
                      width: size.width * 0.6,
                      margin: const EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          colors: [
                            SlectivColors.primaryBlue.withOpacity(0.3),
                            SlectivColors.secondaryBlue,
                            SlectivColors.primaryBlue.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
