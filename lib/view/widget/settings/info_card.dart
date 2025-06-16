import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/services/sound_service.dart';
import 'package:tasknotate/view/widget/settings/about_us_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoCard extends StatelessWidget {
  final SoundService soundService;
  const InfoCard({required this.soundService, super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'key_error'.tr,
          'key_cannot_open_link'.tr + ' $url',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'key_error'.tr,
        'key_cannot_open_link'.tr + ': $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(context.scaleConfig.scale(16).clamp(12, 20)),
      ),
      child: Column(
        children: [
          // Privacy Policy
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.scaleConfig.scale(16).clamp(12, 20),
              vertical: context.scaleConfig.scale(8).clamp(6, 10),
            ),
            leading: Icon(
              Icons.privacy_tip,
              color: context.appTheme.colorScheme.primary,
              size: context.scaleConfig.scale(28).clamp(24, 32),
            ),
            title: Text(
              'key_privacy_policy'.tr,
              style: context.appTextTheme.bodyLarge?.copyWith(
                fontSize: context.scaleConfig.scaleText(16).clamp(14, 18),
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {
              await soundService.playButtonClickSound();
              _launchUrl(
                  'https://doc-hosting.flycricket.io/tasknotate-privacy-policy/2ad4ba24-c15d-40d0-9b73-83b603ffa073/privacy');
            },
          ),
          Divider(height: 1),
          // Terms & Conditions
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.scaleConfig.scale(16).clamp(12, 20),
              vertical: context.scaleConfig.scale(8).clamp(6, 10),
            ),
            leading: Icon(
              Icons.description,
              color: context.appTheme.colorScheme.primary,
              size: context.scaleConfig.scale(28).clamp(24, 32),
            ),
            title: Text(
              'key_terms_conditions'.tr,
              style: context.appTextTheme.bodyLarge?.copyWith(
                fontSize: context.scaleConfig.scaleText(16).clamp(14, 18),
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {
              await soundService.playButtonClickSound();
              _launchUrl(
                  'https://doc-hosting.flycricket.io/tasknotate-terms-of-use/7dbbcb71-3adb-45c9-b519-740e552f49ba/terms');
            },
          ),
          Divider(height: 1),
          // About Us
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.scaleConfig.scale(16).clamp(12, 20),
              vertical: context.scaleConfig.scale(8).clamp(6, 10),
            ),
            leading: Icon(
              Icons.info,
              color: context.appTheme.colorScheme.primary,
              size: context.scaleConfig.scale(28).clamp(24, 32),
            ),
            title: Text(
              'key_about_us'.tr,
              style: context.appTextTheme.bodyLarge?.copyWith(
                fontSize: context.scaleConfig.scaleText(16).clamp(14, 18),
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {
              await soundService.playButtonClickSound();
              Get.to(() => const AboutUsScreen());
            },
          ),
        ],
      ),
    );
  }
}
