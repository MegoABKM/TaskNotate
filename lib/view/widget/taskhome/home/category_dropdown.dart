import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';
import 'package:tasknotate/data/model/categorymodel.dart';

class CategoryDropdown extends StatelessWidget {
  final HomeController controller;

  const CategoryDropdown({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final ScaleConfig scale =
        context.scaleConfig; // Get ScaleConfig from context

    // Define a base font size, similar to SortDropdown
    const double baseFontSize = 14.0;
    // Define a base icon size, you can adjust this if FontAwesomeIcons.filter looks better smaller
    const double baseIconSize =
        16.0; // Slightly smaller than SortDropdown's 18 for FontAwesome

    return GetBuilder<HomeController>(
      id: 'task-category-view',
      builder: (controller) {
        String selectedCategoryValue = 'Home';
        if (controller.selectedTaskCategoryId.value != null) {
          final category = controller.taskCategories.firstWhere(
            (category) =>
                category.id == controller.selectedTaskCategoryId.value,
            orElse: () => CategoryModel(id: null, categoryName: "Home"),
          );
          selectedCategoryValue = category.categoryName;
        }

        // Define the TextStyle to be reused, applying responsive scaling
        final TextStyle dropdownTextStyle = TextStyle(
          color: context.appTheme.colorScheme.onSecondary,
          fontSize: scale.scaleText(baseFontSize), // Scale the base font size
        );

        return Container(
          constraints: BoxConstraints(
            maxWidth: scale.scale(100), // Keep responsive width
          ),
          padding: EdgeInsets.symmetric(
              horizontal: scale.scale(6)), // Keep responsive padding
          decoration: BoxDecoration(
            color: context.appTheme.colorScheme.secondary,
            borderRadius:
                BorderRadius.circular(scale.scale(6)), // Keep responsive radius
            // Optionally add similar shadow if desired to match SortDropdown
            // boxShadow: const [
            //   BoxShadow(
            //     color: Colors.black26,
            //     blurRadius: 4,
            //     offset: Offset(0, 2),
            //   ),
            // ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategoryValue,
              icon: Icon(
                FontAwesomeIcons.filter, // Using FontAwesome icon
                color: context.appTheme.colorScheme.onSecondary,
                size: scale.scale(baseIconSize), // Scale the base icon size
              ),
              style:
                  dropdownTextStyle, // Apply the defined responsive text style
              dropdownColor: context.appTheme.colorScheme.secondary,
              isExpanded: true,
              elevation: 4, // Match SortDropdown elevation
              items: [
                DropdownMenuItem(
                  value: 'Home',
                  child: Text(
                    'key_home'.tr,
                    overflow: TextOverflow.ellipsis,
                    style: dropdownTextStyle, // Reuse the style for items
                  ),
                ),
                ...controller.taskCategories.map((category) => DropdownMenuItem(
                      value: category.categoryName,
                      child: Text(
                        category.categoryName,
                        overflow: TextOverflow.ellipsis,
                        style: dropdownTextStyle, // Reuse the style for items
                      ),
                    )),
              ],
              onChanged: (value) {
                if (value == 'Home') {
                  controller.filterTasksByCategory(null);
                } else if (value != null) {
                  final category = controller.taskCategories
                      .firstWhere((c) => c.categoryName == value);
                  controller.filterTasksByCategory(category.id);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
