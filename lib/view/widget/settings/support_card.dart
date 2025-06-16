import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/services/sound_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportCard extends StatelessWidget {
  final SoundService soundService;
  const SupportCard({required this.soundService, super.key});

  Future<void> _launchUrl(String url, {bool isEmail = false}) async {
    final uri = isEmail
        ? Uri(
            scheme: 'mailto',
            path: url,
            queryParameters: {
              'subject': isEmail && url.contains('feedback')
                  ? 'TaskNotate Feedback'
                  : 'TaskNotate Support'
            },
          )
        : Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          isEmail ? 'key_contact_us'.tr : 'key_rate_us'.tr,
          isEmail ? 'key_no_email_client'.tr : 'key_cannot_open_store'.tr,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        isEmail ? 'key_contact_us'.tr : 'key_rate_us'.tr,
        'key_email_error'.tr + ': $e',
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
          // Rate Us
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.scaleConfig.scale(16).clamp(12, 20),
              vertical: context.scaleConfig.scale(8).clamp(6, 10),
            ),
            leading: Icon(
              Icons.star,
              color: context.appTheme.colorScheme.primary,
              size: context.scaleConfig.scale(28).clamp(24, 32),
            ),
            title: Text(
              'key_rate_us'.tr,
              style: context.appTextTheme.bodyLarge?.copyWith(
                fontSize: context.scaleConfig.scaleText(16).clamp(14, 18),
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'key_rate_us_subtitle'.tr,
              style: context.appTextTheme.bodyMedium?.copyWith(
                fontSize: context.scaleConfig.scaleText(14).clamp(12, 16),
                color: context.appTheme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            onTap: () async {
              await soundService.playButtonClickSound();
              _launchUrl(
                  'https://play.google.com/store/apps/details?id=com.tasknotate');
            },
          ),
          Divider(height: 1),
          // Feedback
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.scaleConfig.scale(16).clamp(12, 20),
              vertical: context.scaleConfig.scale(8).clamp(6, 10),
            ),
            leading: Icon(
              Icons.feedback,
              color: context.appTheme.colorScheme.primary,
              size: context.scaleConfig.scale(28).clamp(24, 32),
            ),
            title: Text(
              'key_feedback'.tr,
              style: context.appTextTheme.bodyLarge?.copyWith(
                fontSize: context.scaleConfig.scaleText(16).clamp(14, 18),
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'key_feedback_subtitle'.tr,
              style: context.appTextTheme.bodyMedium?.copyWith(
                fontSize: context.scaleConfig.scaleText(14).clamp(12, 16),
                color: context.appTheme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            onTap: () async {
              await soundService.playButtonClickSound();
              _launchUrl('tasknotate@gmail.com', isEmail: true);
            },
          ),
          Divider(height: 1),
          // Contact Us
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.scaleConfig.scale(16).clamp(12, 20),
              vertical: context.scaleConfig.scale(8).clamp(6, 10),
            ),
            leading: Icon(
              Icons.email,
              color: context.appTheme.colorScheme.primary,
              size: context.scaleConfig.scale(28).clamp(24, 32),
            ),
            title: Text(
              'key_contact_us'.tr,
              style: context.appTextTheme.bodyLarge?.copyWith(
                fontSize: context.scaleConfig.scaleText(16).clamp(14, 18),
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'tasknotate@gmail.com',
              style: context.appTextTheme.bodyMedium?.copyWith(
                fontSize: context.scaleConfig.scaleText(14).clamp(12, 16),
                color: context.appTheme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            onTap: () async {
              await soundService.playButtonClickSound();
              _launchUrl('tasknotate@gmail.com', isEmail: true);
            },
          ),
        ],
      ),
    );
  }
}
