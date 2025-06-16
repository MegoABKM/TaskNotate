import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';
import 'package:tasknotate/data/model/categorymodel.dart';

class NoteCategoryDropdown extends StatelessWidget {
  final HomeController controller;
  // final ScaleConfig scale; // Already removed in previous step

  const NoteCategoryDropdown({
    super.key,
    required this.controller,
    // required this.scale, // Already removed
  });

  @override
  Widget build(BuildContext context) {
    final ScaleConfig scale =
        context.scaleConfig; // Get ScaleConfig from context

    // Define a base font size, similar to SortDropdown
    const double baseFontSize = 14.0;
    // Define a base icon size
    const double baseIconSize = 16.0;

    return GetBuilder<HomeController>(
      id: 'note-category-view',
      builder: (controller) {
        String selectedCategoryValue = 'Home';
        if (controller.selectedNoteCategoryId.value != null) {
          final category = controller.noteCategories.firstWhere(
            (category) =>
                category.id == controller.selectedNoteCategoryId.value,
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
            maxWidth: scale.scale(100),
          ),
          padding: EdgeInsets.symmetric(horizontal: scale.scale(6)),
          decoration: BoxDecoration(
            color: context.appTheme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(scale.scale(6)),
            // Optionally add similar shadow
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
                FontAwesomeIcons.filter,
                color: context.appTheme.colorScheme.onSecondary,
                size: scale.scale(baseIconSize),
              ),
              style: dropdownTextStyle,
              dropdownColor: context.appTheme.colorScheme.secondary,
              isExpanded: true,
              elevation: 4, // Match SortDropdown elevation
              items: [
                DropdownMenuItem(
                  value: 'Home',
                  child: Text(
                    'key_home'.tr,
                    overflow: TextOverflow.ellipsis,
                    style: dropdownTextStyle, // Reuse for items
                  ),
                ),
                ...controller.noteCategories.map((category) => DropdownMenuItem(
                      value: category.categoryName,
                      child: Text(
                        category.categoryName,
                        overflow: TextOverflow.ellipsis,
                        style: dropdownTextStyle, // Reuse for items
                      ),
                    )),
              ],
              onChanged: (value) {
                if (value == 'Home') {
                  controller.filterNotesByCategory(null);
                } else if (value != null) {
                  final category = controller.noteCategories
                      .firstWhere((c) => c.categoryName == value);
                  controller.filterNotesByCategory(category.id);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
