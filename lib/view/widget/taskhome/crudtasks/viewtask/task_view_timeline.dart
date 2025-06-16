import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/taskline_task.dart';

class TaskViewTimeline extends StatelessWidget {
  final controller;
  const TaskViewTimeline({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Timeline".tr,
          style: context.appTheme.textTheme.headlineSmall,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.decodedTimeline.length,
          itemBuilder: (context, index) {
            final tile = controller.decodedTimeline[index];
            return TimeLineTask(
              title: tile['title'],
              time: DateTime.parse(tile['time']),
              isFirst: index == 0,
              isLast: index == controller.decodedTimeline.length - 1,
            );
          },
        ),
        SizedBox(
            height:
                context.scaleConfig.scale(20)), // Added spacing after timeline
      ],
    );
  }
}
