import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';

class CustomNoteView extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final TextEditingController controller;
  final Function(String)? onChanged;

  const CustomNoteView({
    required this.backgroundColor,
    required this.textColor,
    required this.controller,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ScaleConfig scaleConfig = ScaleConfig(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: scaleConfig.scale(390),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(scaleConfig.scale(15)),
          ),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(scaleConfig.scale(4)),
            child: SingleChildScrollView(
              child: TextFormField(
                onChanged: onChanged,
                controller: controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                  color: textColor,
                  fontSize: scaleConfig.scaleText(18),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(scaleConfig.scale(10)),
                  ),
                  fillColor: backgroundColor,
                  filled: true,
                  hintText: "174".tr,
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: scaleConfig.scaleText(16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
