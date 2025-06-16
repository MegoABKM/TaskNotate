// lib/view/widget/notehome/crudnotes/createnote/customnote.dart
import 'package:flutter/material.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class CustomNote extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;

  const CustomNote({
    required this.backgroundColor,
    required this.textColor,
    required this.controller,
    required this.hintText,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: context.scaleConfig.scale(390),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.scaleConfig.scale(15)),
          ),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(context.scaleConfig.scale(4)),
            child: SingleChildScrollView(
              child: TextFormField(
                onChanged: onChanged,
                controller: controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                  color: textColor,
                  fontSize: context.scaleConfig.scaleText(18),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(context.scaleConfig.scale(10)),
                  ),
                  fillColor: backgroundColor,
                  filled: true,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    fontSize: context.scaleConfig.scaleText(16),
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
