import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart'; // For initializeDateFormatting
// import 'package:intl/intl.dart'; // No longer need direct DateFormat constructor here
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/view/widget/taskhome/home/empty_task_message.dart';
import 'package:tasknotate/view/widget/taskhome/home/task_list/customtaskcard/task_dialog.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:tasknotate/core/localization/changelocal.dart';
import 'package:tasknotate/core/functions/formatdate.dart'; // YOUR FUNCTION

class TimelineHome extends StatelessWidget {
  const TimelineHome({super.key});

  @override
  Widget build(BuildContext context) {
    final LocalController localController = Get.find<LocalController>();
    final String currentLocale = localController.language?.languageCode ??
        "en"; // Get the string locale code

    // DEBUG:
    print(
        "--- TimelineHome Build --- Using Locale: $currentLocale for formatting.");

    return FutureBuilder<void>(
      key: ValueKey("timeline_init_$currentLocale"), // Key depends on locale
      future: initializeDateFormatting(currentLocale, null).catchError((e) {
        print(
            "CRITICAL: Failed to initialize date formatting for '$currentLocale': $e");
        throw e; // Propagate error to be handled by snapshot.hasError
      }),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading date formats for ${currentLocale.toUpperCase()}.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // If initialization is done, proceed to build the timeline
        return GetBuilder<HomeController>(
          id: 'timeline-view',
          builder: (controller) {
            if (controller.isLoadingTasks && controller.taskdata.isEmpty) {
              return SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              );
            }
            if (controller.taskdata.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyTaskMessage(), // Consider a specific message
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= controller.taskdata.length) {
                    return SizedBox(
                        height: 80 * context.scaleConfig.scaleHeight);
                  }

                  final task = controller.taskdata[index];
                  final bool hasSpecificStartTime =
                      task.starttime != null && task.starttime != "Not Set";

                  String dateTimeStringToFormat;
                  String prefixForMarker = "";

                  if (hasSpecificStartTime) {
                    dateTimeStringToFormat = task.starttime!;
                  } else if (task.date != null && task.date != "Not Set") {
                    dateTimeStringToFormat = task.date!;
                    // prefixForMarker = "${'362'.tr}: "; // Optional prefix
                  } else {
                    dateTimeStringToFormat = "";
                  }

                  // ** PASS currentLocale TO YOUR HELPER FUNCTION **
                  final String timelineMarker = prefixForMarker +
                      formatDateTime(dateTimeStringToFormat, currentLocale);

                  // DEBUG:
                  // print("Task: ${task.title}, Raw: $dateTimeStringToFormat, Formatted: $timelineMarker, Locale used: $currentLocale");

                  final statusColor = _getStatusColor(task.status);

                  return TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.35,
                    isFirst: index == 0,
                    isLast: index == controller.taskdata.length - 1,
                    indicatorStyle: IndicatorStyle(
                      width: context.scaleConfig.scale(20),
                      color: statusColor,
                      padding: EdgeInsets.symmetric(
                          vertical: context.scaleConfig.scale(5)),
                    ),
                    startChild: Container(
                      // Responsive padding for the date/time side
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaleConfig.scale(8),
                        vertical: context.scaleConfig
                            .scale(10), // Increased vertical padding
                      ),
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(
                        timelineMarker,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: context.scaleConfig.scaleText(
                                  13.5), // Adjusted for responsiveness
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 2, // Allow date/time to wrap if very long
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    endChild: GestureDetector(
                      onLongPress: () => TaskDialogHelper.showTaskDialog(
                          context, task, context.scaleConfig, controller),
                      onTap: () =>
                          controller.goToViewTask(task, index.toString()),
                      child: Card(
                        // Using Card for consistent elevation and shape
                        elevation: context.scaleConfig.scale(2),
                        margin: EdgeInsets.symmetric(
                          vertical: context.scaleConfig.scale(8),
                          horizontal: context.scaleConfig
                              .scale(12), // Slightly reduced horizontal margin
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              context.scaleConfig.scale(10)),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(context.scaleConfig
                              .scale(12)), // Slightly reduced padding
                          decoration: BoxDecoration(
                            // Gradient can be on Card or Container
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(0.95),
                                Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                                context.scaleConfig.scale(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title ?? "key_untitled".tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            // Adjusted for size
                                            fontSize: context.scaleConfig
                                                .scaleText(15),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.w500,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    // Add other info if needed
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: context.scaleConfig
                                    .scale(16), // Adjusted size
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    beforeLineStyle: LineStyle(
                        color: statusColor,
                        thickness: context.scaleConfig.scale(2.5)),
                    afterLineStyle: LineStyle(
                        color: statusColor,
                        thickness: context.scaleConfig.scale(2.5)),
                  );
                },
                childCount: controller.taskdata.length +
                    (controller.taskdata.isNotEmpty ? 1 : 0),
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case "Pending":
        return Colors.orangeAccent;
      case "In Progress":
        return Colors.blueAccent;
      case "Completed":
        return Colors.green;
      default:
        return Colors.grey.shade400;
    }
  }
}
