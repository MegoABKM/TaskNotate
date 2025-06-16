import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class CustomAppBarView extends StatelessWidget {
  final TextEditingController titleController;
  final VoidCallback onBackPressed;
  final Function(String) onTitleChanged;

  const CustomAppBarView({
    required this.titleController,
    required this.onBackPressed,
    required this.onTitleChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.scaleConfig.scale(56),
      padding: EdgeInsets.symmetric(horizontal: context.scaleConfig.scale(12)),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: IconButton(
              padding: EdgeInsets.only(
                bottom: context.scaleConfig.scale(0.4),
                top: context.scaleConfig.scale(12),
              ),
              onPressed: onBackPressed,
              icon: Icon(
                Icons.arrow_back,
                color: context.appTheme.colorScheme.secondary,
                size: context.scaleConfig.scale(24),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: context.scaleConfig.scale(0.4),
                top: context.scaleConfig.scale(12),
              ),
              child: Text(
                "171".tr,
                style: TextStyle(
                  fontSize: context.scaleConfig.scaleText(24),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.topLeft,
              child: TextFormField(
                controller: titleController,
                maxLength: 30,
                style: TextStyle(fontSize: context.scaleConfig.scaleText(18)),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "173".tr,
                  counterText: "",
                  contentPadding: EdgeInsets.only(
                    bottom: context.scaleConfig.scale(0.4),
                    top: context.scaleConfig.scale(17.6),
                  ),
                ),
                onChanged: onTitleChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
