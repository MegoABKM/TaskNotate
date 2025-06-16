import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/localization/changelocal.dart';

class TimeLineTask extends StatelessWidget {
  final String title;
  final DateTime time;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onEdit; // Edit button click
  final VoidCallback? onDelete; // Delete button click

  const TimeLineTask({
    super.key,
    required this.title,
    required this.time,
    this.isFirst = false,
    this.isLast = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = Get.find<LocalController>().language.languageCode == 'ar'
        ? DateFormat('yyyy-MM-dd h:mm a')
        : DateFormat('yyyy-MM-dd h:mm a');

    // Debug print to confirm rendering
    print('Rendering TimeLineTask: title=$title, onDelete=${onDelete != null}');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline tile with time and title
        Expanded(
          child: SizedBox(
            height: context.scaleConfig.scale(100), // Scaled height
            child: TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.3,
              axis: TimelineAxis.vertical,
              isFirst: isFirst,
              isLast: isLast,
              hasIndicator: true, // Show the timeline dot
              indicatorStyle: IndicatorStyle(
                width: context.scaleConfig.scale(20),
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(
                  vertical: context.scaleConfig.scale(8),
                ),
              ),
              startChild: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaleConfig.scale(8),
                  vertical: context.scaleConfig.scale(8),
                ),
                alignment: Alignment.centerRight,
                child: Text(
                  timeFormat.format(time),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              endChild: Container(
                constraints: BoxConstraints(
                  minWidth: context.scaleConfig.scale(120),
                ),
                padding: EdgeInsets.all(context.scaleConfig.scale(16)),
                margin: EdgeInsets.symmetric(
                  vertical: context.scaleConfig.scale(8),
                  horizontal: context.scaleConfig.scale(16),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius:
                      BorderRadius.circular(context.scaleConfig.scale(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: context.scaleConfig.scale(6),
                      offset: Offset(0, context.scaleConfig.scale(2)),
                    ),
                  ],
                ),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              beforeLineStyle: LineStyle(
                color: Theme.of(context).primaryColor,
                thickness: context.scaleConfig.scale(2),
              ),
              afterLineStyle: LineStyle(
                color: Theme.of(context).primaryColor,
                thickness: context.scaleConfig.scale(2),
              ),
            ),
          ),
        ),
        // Buttons to the right
        Container(
          padding: EdgeInsets.symmetric(
            vertical: context.scaleConfig.scale(16),
            horizontal: context.scaleConfig.scale(8),
          ),
          width: context.scaleConfig.scale(48), // Scaled width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onEdit != null)
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: context.scaleConfig.scale(20),
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: onEdit,
                  tooltip: 'Edit'.tr,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (onDelete != null)
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: context.scaleConfig.scale(20),
                    color: Colors.red,
                  ),
                  onPressed: () {
                    print('Delete button pressed for title: $title');
                    onDelete?.call();
                  },
                  tooltip: 'Delete'.tr,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
