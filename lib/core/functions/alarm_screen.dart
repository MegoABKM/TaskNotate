import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasknotate/core/functions/alarm.dart'; // Assuming deactivateAlarm is here
import 'package:tasknotate/core/services/alarm_display_service.dart';
import 'package:tasknotate/core/constant/routes.dart';
// Consider adding Lottie if you want a more complex alarm animation
// import 'package:lottie/lottie.dart';

class AlarmScreen extends StatefulWidget {
  final int id;
  final String title;

  const AlarmScreen({
    super.key,
    required this.id,
    required this.title,
  });

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation; // For a subtle glow effect

  @override
  void initState() {
    super.initState();
    print(
        "AlarmScreen: InitState for alarm ID ${widget.id}, title '${widget.title}'. Current route: ${Get.currentRoute}");

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Slower pulse
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Curves.elasticInOut), // Changed curve
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      // Shadow blur radius
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<AlarmDisplayStateService>()) {
        if (!AlarmDisplayStateService.to.isAlarmScreenActive.value) {
          print(
              "AlarmScreen: PostFrameCallback - Global flag was false, setting to true.");
          AlarmDisplayStateService.to.setAlarmScreenActive(true);
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _stopAlarmActions() async {
    print("AlarmScreen: Stop button pressed for alarm ID ${widget.id}");
    final taskData = {'id': widget.id.toString(), 'title': widget.title};
    await deactivateAlarm(taskData);

    if (Get.isRegistered<AlarmDisplayStateService>()) {
      await AlarmDisplayStateService.to.setAlarmScreenActive(false);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(
          AlarmDisplayStateService.prefsKeyIsAlarmScreenActive, false);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_alarm_id');
    await prefs.remove('is_alarm_triggered');

    print("AlarmScreen: Navigating to home after stopping alarm.");
    Get.offAllNamed(AppRoute.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Define colors for the "TaskNotate" text
    final List<Color> taskNotateColors = isDarkMode
        ? [Colors.tealAccent, Colors.lightBlueAccent, Colors.pinkAccent]
        : [
            theme.colorScheme.primary,
            Colors.orangeAccent,
            Colors.deepPurpleAccent
          ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDarkMode
            ? const Color(0xFF1A1A2E)
            : const Color(0xFFE0E5EC), // Dark blue/purple or Neumorphic light
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [
                        const Color(0xFF16213E),
                        const Color(0xFF0F3460)
                      ] // Darker gradient
                    : [
                        const Color(0xFFF0F2F5),
                        const Color(0xFFDDE1E7)
                      ], // Light gradient
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Top Section: TaskNotate and Reminder
                  Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: taskNotateColors,
                          tileMode: TileMode.mirror,
                        ).createShader(bounds),
                        child: Text(
                          "TaskNotate",
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.08, // Responsive font size
                            fontWeight: FontWeight.w900,
                            color: Colors
                                .white, // This color will be overridden by ShaderMask
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "key_reminder_text".tr.toUpperCase(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isDarkMode
                              ? Colors.blueGrey[200]
                              : Colors.blueGrey[700],
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),

                  // Middle Section: Alarm Icon and Task Title
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withOpacity(
                                              0.5 * _glowAnimation.value / 8.0),
                                      blurRadius: _glowAnimation.value * 2,
                                      spreadRadius: _glowAnimation.value / 2,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.notifications_active, // Changed icon
                                  size:
                                      screenWidth * 0.3, // Responsive icon size
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            fontSize:
                                screenWidth * 0.065, // Responsive font size
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Section: Stop Button
                  SizedBox(
                    width: double
                        .infinity, // Make button take full width available in padding
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.alarm_off, size: 28),
                      label: Text(
                        'key_stop_alarm_button'.tr,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: Colors.redAccent.withOpacity(0.5),
                      ),
                      onPressed: _stopAlarmActions,
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
