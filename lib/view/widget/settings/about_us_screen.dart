import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<void> sendEmail(String email) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'TaskNotate Support'},
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'key_contact_us'.tr,
          'key_no_email_client'.tr,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'key_contact_us'.tr,
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
    return Scaffold(
      backgroundColor: context.appTheme.colorScheme.primary,
      appBar: AppBar(
        title: Text(
          'key_about_us'.tr,
          style: context.appTextTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: context.scaleConfig.scaleText(20).clamp(18, 24),
            color: context.appTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: context.appTheme.colorScheme.primary,
        elevation: 0,
      ),
      body: Container(
        color: context.appTheme.colorScheme.primary,
        padding: EdgeInsets.all(context.scaleConfig.scale(20).clamp(16, 24)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo with Animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      context.scaleConfig.scale(20).clamp(16, 24)),
                  child: Image.asset(
                    'assets/images/logogreen.png',
                    height: context.scaleConfig.scale(140).clamp(120, 160),
                    width: context.scaleConfig.scale(140).clamp(120, 160),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: context.scaleConfig.scale(24).clamp(20, 28)),
              // App Name
              Text(
                'TaskNotate',
                style: context.appTextTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: context.scaleConfig.scaleText(28).clamp(24, 32),
                  color: context.appTheme.colorScheme.onPrimary,
                ),
              ),
              SizedBox(height: context.scaleConfig.scale(10).clamp(8, 12)),
              // App Version
              FutureBuilder<String>(
                future: _getAppVersion(),
                builder: (context, snapshot) {
                  return Text(
                    '${'key_app_version'.tr}: ${snapshot.data ?? 'Loading'}',
                    style: context.appTextTheme.bodyMedium?.copyWith(
                      fontSize: context.scaleConfig.scaleText(16).clamp(14, 18),
                      color: context.appTheme.colorScheme.onPrimary
                          .withOpacity(0.8),
                    ),
                  );
                },
              ),
              SizedBox(height: context.scaleConfig.scale(20).clamp(16, 24)),
              // Description Card
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      context.scaleConfig.scale(16).clamp(12, 20)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                      context.scaleConfig.scale(20).clamp(16, 24)),
                  child: Text(
                    'key_about_us_description'.tr,
                    textAlign: TextAlign.center,
                    style: context.appTextTheme.bodyLarge?.copyWith(
                      fontSize: context.scaleConfig.scaleText(16).clamp(14, 18),
                      color: context.appTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
