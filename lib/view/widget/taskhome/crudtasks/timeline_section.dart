// lib/view/widget/taskhome/crudtasks/timeline_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/add_time_line_tile_form.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/taskline_task.dart';

class TimelineSection extends StatelessWidget {
  final dynamic controller;
  final bool isEditable;

  const TimelineSection({
    super.key,
    required this.controller,
    this.isEditable = true,
  });

  void _editTile(BuildContext context, Map<String, dynamic> tile) {
    if (!isEditable) return;
    Get.dialog(
      Dialog(
        child: AddTimelineTileForm(
          controller: controller,
          initialTitle: tile['title'],
          initialTime: DateTime.parse(tile['time']),
          tileIndex: tile['index'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditable)
          ElevatedButton(
            onPressed: () {
              Get.dialog(
                Dialog(
                  child: AddTimelineTileForm(
                    controller: controller,
                  ),
                ),
              );
            },
            child: Text('Add Timeline Tile'.tr),
          ),
        Obx(
          () => controller.timelineTiles.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No timeline tiles added'.tr),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.timelineTiles.length,
                  itemBuilder: (context, index) {
                    final tile = controller.timelineTiles[index];
                    return TimeLineTask(
                      title: tile['title'] ?? 'Untitled',
                      time: DateTime.parse(tile['time']),
                      isFirst: index == 0,
                      isLast: index == controller.timelineTiles.length - 1,
                      onEdit:
                          isEditable ? () => _editTile(context, tile) : null,
                      onDelete: isEditable
                          ? () {
                              print(
                                  'TimelineSection: Deleting tile with index ${tile['index']}');
                              controller.deleteTimelineTile(tile['index']);
                            }
                          : null,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
