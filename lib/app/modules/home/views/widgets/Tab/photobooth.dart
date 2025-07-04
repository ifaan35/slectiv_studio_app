import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:slectiv_studio_app/app/modules/login_screen/views/widgets/submit_button.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/image_strings.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class SlectivPhotobooth extends StatefulWidget {
  const SlectivPhotobooth({super.key});

  @override
  _SlectivPhotoboothState createState() => _SlectivPhotoboothState();
}

class _SlectivPhotoboothState extends State<SlectivPhotobooth> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(SlectivImages.saveIGVideo);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SlectivColors.lightBlueBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // Title
              Text(
                SlectivTexts.photoboothTitle,
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: SlectivColors.blackColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Video Card
              Card(
                elevation: 8,
                shadowColor: SlectivColors.blackColor.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        );
                      } else {
                        return Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              SlectivColors.primaryColor,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Description Card
              Card(
                elevation: 8,
                shadowColor: SlectivColors.blackColor.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Service Description",
                        style: GoogleFonts.spaceGrotesk(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: SlectivColors.blackColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        SlectivTexts.photoboothDescription,
                        style: GoogleFonts.spaceGrotesk(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: SlectivColors.blackColor,
                            height: 1.5,
                          ),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Features Card
              Card(
                elevation: 8,
                shadowColor: SlectivColors.blackColor.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What's Included",
                        style: GoogleFonts.spaceGrotesk(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: SlectivColors.blackColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem(SlectivTexts.photoboothFeature),
                      const SizedBox(height: 12),
                      _buildFeatureItem(SlectivTexts.widePhotoboxFeature),
                      const SizedBox(height: 12),
                      _buildFeatureItem(SlectivTexts.hightAngleFeature),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Contact Button
              SlectiveWidgetButton(
                buttonName: SlectivTexts.photoboothButtonName,
                onPressed: () async {
                  final Uri adminContactUrl = Uri.parse(
                    'https://wa.me/6281345383641?text=Halo,%20saya%20ingin%20mengajukan%20pertanyaan.',
                  );
                  launchUrl(adminContactUrl);
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: SlectivColors.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            feature,
            style: GoogleFonts.spaceGrotesk(
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: SlectivColors.blackColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
