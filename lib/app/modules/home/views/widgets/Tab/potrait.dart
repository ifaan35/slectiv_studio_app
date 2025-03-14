import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slectiv_studio_app/app/modules/login_screen/views/widgets/submit_button.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/image_strings.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';
import 'package:url_launcher/url_launcher.dart';

class SlectivPortrait extends StatelessWidget {
  const SlectivPortrait({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SlectivColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24,),
              Text(SlectivTexts.potraitTitle, style: GoogleFonts.spaceGrotesk(textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: SlectivColors.blackColor)),),
              const SizedBox(height: 10,),
              const Center(child: Image(image: AssetImage(SlectivImages.potraitImages))),
              const SizedBox(height: 10,),
              Text(SlectivTexts.potraitDescription, style: GoogleFonts.spaceGrotesk(textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: SlectivColors.blackColor)), textAlign: TextAlign.justify,),
              const SizedBox(height: 20,),
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                // First Feature
                Container(
                  width: 200,
                  height: 25,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: SlectivColors.blackColor.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(SlectivTexts.hours1SessionFeature, 
                    style: GoogleFonts.spaceGrotesk(
                      textStyle:const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400, color: SlectivColors.blackColor
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5,),
              
                // Second Feature
                Container(
                  width: 200,
                  height: 25,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: SlectivColors.blackColor.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(SlectivTexts.allSoftliteFeature, 
                    style: GoogleFonts.spaceGrotesk(
                      textStyle:const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400, color: SlectivColors.blackColor
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5,),
              
                // Third Feature
                Container(
                  width: 200,
                  height: 25,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: SlectivColors.blackColor.withOpacity(0.1)
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(SlectivTexts.printed4RPhotoFeature, 
                    style: GoogleFonts.spaceGrotesk(
                      textStyle:const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400, color: SlectivColors.blackColor
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5,),
              
                // Four Feature
                Container(
                  width: 200,
                  height: 25,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: SlectivColors.blackColor.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(SlectivTexts.includePhotographerFeature, 
                    style: GoogleFonts.spaceGrotesk(
                      textStyle:const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400, color: SlectivColors.blackColor
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30,),
            SlectiveWidgetButton(
                buttonName: SlectivTexts.photoboothButtonName,
                onPressed: () async {
                    final Uri adminContactUrl = Uri.parse('https://wa.me/6281345383641?text=Halo,%20saya%20ingin%20mengajukan%20pertanyaan.');
                  launchUrl(adminContactUrl);
                }, 
                backgroundColor: SlectivColors.submitButtonColor
              ),
            const SizedBox(height: 5,),
          ],
        ),
      ),
    ),
  );
}
}