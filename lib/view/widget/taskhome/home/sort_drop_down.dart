import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';

class SortDropdown extends StatelessWidget {
  final HomeController controller;
  final ScaleConfig scale;

  const SortDropdown({
    required this.controller,
    required this.scale,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle? styledropdown = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: 14, // Static smaller font size
        );

    return Container(
      constraints: const BoxConstraints(
        maxWidth: 100, // Smaller static width
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6), // Static padding
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius:
            const BorderRadius.all(Radius.circular(6)), // Static radius
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4, // Static blur radius
            offset: Offset(0, 2), // Static offset
          ),
        ],
      ),
      child: DropdownButton<String>(
        elevation: 4,
        dropdownColor: Theme.of(context).colorScheme.secondary,
        hint: Text(
          "93".tr,
          style: styledropdown,
          overflow: TextOverflow.ellipsis,
        ),
        value: controller.selectedSortCriterion,
        underline: const SizedBox(),
        icon: const Icon(
          Icons.arrow_drop_down,
          color:
              Colors.white, // Assuming onSecondary is white based on screenshot
          size: 18, // Smaller static icon size
        ),
        isExpanded: true,
        items: [
          DropdownMenuItem(
            value: "priority",
            child: Text(
              "94".tr,
              style: styledropdown,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DropdownMenuItem(
            value: "status",
            child: Text(
              "95".tr,
              style: styledropdown,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DropdownMenuItem(
            value: "datecreated",
            child: Text(
              "96".tr,
              style: styledropdown,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DropdownMenuItem(
            value: "datefinish",
            child: Text(
              "97".tr,
              style: styledropdown,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DropdownMenuItem(
            value: "datestart",
            child: Text(
              "365".tr,
              style: styledropdown,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            controller.selectedSortCriterion = value;
            controller.sortTasks(value);
          }
        },
      ),
    );
  }
}
