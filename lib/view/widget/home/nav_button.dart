import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';
import 'package:tasknotate/core/services/sound_service.dart';

class NavButton extends StatelessWidget {
  final HomeController controller;
  final int index;
  final IconData icon;
  final ScaleConfig scaleConfig;
  final String tooltip;

  const NavButton({
    super.key,
    required this.controller,
    required this.index,
    required this.icon,
    required this.scaleConfig,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final bool isSelected = controller.currentIndex == index;
        return Tooltip(
          message: tooltip,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(color: Colors.white, fontSize: 12),
          child: InkWell(
            onTap: () {
              Get.find<SoundService>().playButtonClickSound();
              controller.onTapBottom(index);
            },
            borderRadius: BorderRadius.circular(12),
            splashColor: Colors.white.withOpacity(0.3),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              transform: Matrix4.identity()..scale(isSelected ? 1.05 : 1.0),
              padding: EdgeInsets.all(scaleConfig.scale(4)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Colors.white.withOpacity(0.1)
                    : Colors.transparent,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade400,
                size: scaleConfig.scale(22),
              ),
            ),
          ),
        );
      },
    );
  }
}
