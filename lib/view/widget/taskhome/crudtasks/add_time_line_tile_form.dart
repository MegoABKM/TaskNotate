// lib/view/widget/taskhome/crudtasks/add_time_line_tile_form.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class AddTimelineTileForm extends StatefulWidget {
  final dynamic controller;
  final TextEditingController titleController;
  final DateTime? initialTime;
  final int? tileIndex;
  final String? initialTitle;

  AddTimelineTileForm({
    super.key,
    this.initialTitle,
    this.initialTime,
    this.tileIndex,
    required this.controller,
  }) : titleController = TextEditingController(text: initialTitle);

  @override
  _AddTimelineTileFormState createState() => _AddTimelineTileFormState();
}

class _AddTimelineTileFormState extends State<AddTimelineTileForm> {
  DateTime? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime =
        widget.initialTime; // Initialize with initialTime if editing
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = widget.initialTime ?? now;

    // Show date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Show time picker
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: widget.initialTime != null
            ? TimeOfDay.fromDateTime(widget.initialTime!)
            : TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Check if the selected date is today and time is in the past
        if (pickedDate
            .isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
          if (pickedTime.hour < now.hour ||
              (pickedTime.hour == now.hour && pickedTime.minute < now.minute)) {
            Get.snackbar(
              "key_invalid_time".tr,
              "key_cannot_select_past_time".tr,
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }
        }

        setState(() {
          _selectedTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.scaleConfig.scale(16)),
      margin: EdgeInsets.symmetric(
        vertical: context.scaleConfig.scale(8),
        horizontal: context.scaleConfig.scale(16),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(context.scaleConfig.scale(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: context.scaleConfig.scale(6),
            offset: Offset(0, context.scaleConfig.scale(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.titleController,
            decoration: InputDecoration(
              labelText: 'Tile Title'.tr,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(context.scaleConfig.scale(12)),
              ),
            ),
          ),
          SizedBox(height: context.scaleConfig.scale(16)),
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedTime != null
                      ? DateFormat('yyyy-MM-dd h:mm a').format(_selectedTime!)
                      : 'Select Date and Time'.tr,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ElevatedButton(
                onPressed: () => _selectDateTime(context),
                child: Text('Pick Date & Time'.tr),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scaleConfig.scale(16),
                    vertical: context.scaleConfig.scale(8),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.scaleConfig.scale(16)),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                if (widget.titleController.text.isNotEmpty &&
                    _selectedTime != null) {
                  widget.controller.addTimelineTile(
                    widget.titleController.text,
                    _selectedTime!,
                    index: widget.tileIndex,
                  );
                  Get.back();
                } else {
                  Get.snackbar(
                    'Error'.tr,
                    'Please provide a title and select a date and time'.tr,
                  );
                }
              },
              child: Text(
                  widget.tileIndex != null ? 'Update Tile'.tr : 'Add Tile'.tr),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaleConfig.scale(16),
                  vertical: context.scaleConfig.scale(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
