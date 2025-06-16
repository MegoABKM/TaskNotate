import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/services/app_security_service.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart'; // For context.appTheme

class DisabledScreen extends StatefulWidget {
  const DisabledScreen({super.key});

  @override
  State<DisabledScreen> createState() => _DisabledScreenState();
}

class _DisabledScreenState extends State<DisabledScreen> {
  final RxBool _isChecking = false.obs;
  final RxBool _canRetry = true.obs;
  DateTime? _lastRetryAttemptTime;
  final Duration _retryCooldown = const Duration(minutes: 1);
  RxString _cooldownMessage = ''.obs;

  Future<String> _getDisableMessage() async {
    if (Get.isRegistered<AppSecurityService>()) {
      return Get.find<AppSecurityService>().getDisabledMessage();
    }
    print(
        "DisabledScreen: AppSecurityService not registered! Using hardcoded default message.");
    // Fallback if service not found, though AppSecurityService has its own fallback.
    return 'disabled_screen_default_message'.tr;
  }

  Future<void> _terminateApp() async {
    try {
      const platform = MethodChannel('com.example.tasknotate/alarm');
      await platform.invokeMethod('terminateApp');
      print('DisabledScreen: App termination requested.');
    } catch (e) {
      print('DisabledScreen: Error terminating app: $e');
      await SystemNavigator.pop();
    }
  }

  void _attemptRetry() async {
    final now = DateTime.now();
    if (!_canRetry.value) {
      if (_lastRetryAttemptTime != null) {
        final difference = now.difference(_lastRetryAttemptTime!);
        final timePassedSinceLastAttempt = _retryCooldown - difference;

        if (timePassedSinceLastAttempt.inSeconds > 0) {
          // Updated to use template and replace
          _cooldownMessage.value =
              'disabled_screen_cooldown_wait_message_template'.trParams(
                  {'seconds': timePassedSinceLastAttempt.inSeconds.toString()});

          if (Get.isSnackbarOpen == false) {
            Get.snackbar(
              'disabled_screen_cooldown_active_title'.tr,
              _cooldownMessage.value,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            );
          }
          return;
        }
      }
    }

    _cooldownMessage.value = '';
    _isChecking.value = true;
    _canRetry.value = false;
    _lastRetryAttemptTime = DateTime.now();

    Future.delayed(_retryCooldown, () {
      if (mounted) {
        _canRetry.value = true;
        _cooldownMessage.value = '';
        print("DisabledScreen: Retry cooldown finished.");
      }
    });

    try {
      if (!Get.isRegistered<AppSecurityService>()) {
        print("DisabledScreen: AppSecurityService not registered for retry.");
        if (mounted) {
          Get.snackbar(
            'disabled_screen_error_title'.tr,
            'disabled_screen_service_unavailable_message'.tr,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        return;
      }
      final securityService = Get.find<AppSecurityService>();
      await securityService.retryCheckAndNavigate();

      if (mounted &&
          Get.currentRoute == AppRoute.disabled &&
          !_isChecking.value) {
        if (Get.isSnackbarOpen == false) {
          Get.snackbar(
            'disabled_screen_still_unavailable_title'.tr,
            'disabled_screen_access_restricted_message'.tr,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      print('DisabledScreen: Error during retryCheckAndNavigate: $e');
      if (mounted && Get.isSnackbarOpen == false) {
        Get.snackbar(
          'disabled_screen_error_title'.tr,
          'disabled_screen_check_failed_message'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (mounted) {
        _isChecking.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.miscellaneous_services_outlined,
                    size: 60,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'disabled_screen_maintenance_title'.tr, // Updated key
                    style: context.appTheme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<String>(
                    future: _getDisableMessage(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2));
                      }
                      // AppSecurityService.getDisabledMessage() should already return a .tr key
                      // or a default .tr key if its own message isn't set.
                      return Text(
                        snapshot.data ??
                            'disabled_screen_temporarily_unavailable_message'
                                .tr,
                        style: context.appTheme.textTheme.bodyLarge
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Obx(() => ElevatedButton.icon(
                        icon: _isChecking.value
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colorScheme.onPrimary))
                            : const Icon(Icons.refresh, size: 20),
                        label: Text(
                            'disabled_screen_retry_button'.tr), // Updated key
                        onPressed: _isChecking.value || !_canRetry.value
                            ? null
                            : _attemptRetry,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            textStyle: const TextStyle(fontSize: 16)),
                      )),
                  Obx(() {
                    if (_cooldownMessage.value.isNotEmpty &&
                        !_canRetry.value &&
                        !_isChecking.value) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _cooldownMessage
                              .value, // Already translated with .trParams
                          style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _terminateApp,
                    child: Text('disabled_screen_exit_button'.tr, // Updated key
                        style: TextStyle(color: colorScheme.error)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
