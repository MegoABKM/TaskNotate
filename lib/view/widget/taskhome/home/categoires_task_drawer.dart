import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/data/model/categorymodel.dart';
import 'package:tasknotate/data/datasource/local/sqldb.dart';

class CategoryDrawerTask extends StatelessWidget {
  final HomeController controller;
  final bool
      isTaskDrawer; // Controls if task titles are shown inside expansion tile

  const CategoryDrawerTask({
    super.key,
    required this.controller,
    required this.isTaskDrawer,
  });

  Future<List<String>> _fetchTaskTitles(
      BuildContext context, CategoryModel category) async {
    final SqlDb sqlDb = SqlDb();
    List<Map<String, dynamic>> tasksResponse;
    // For "Home" category, category.id will be null
    if (category.id == null) {
      tasksResponse = await sqlDb.readData(
        'SELECT title FROM tasks WHERE categoryId IS NULL',
      );
    } else {
      tasksResponse = await sqlDb.readData(
        'SELECT title FROM tasks WHERE categoryId = ?',
        [category.id],
      );
    }
    return tasksResponse.map((task) => task['title'] as String).toList();
  }

  Future<void> _addCategory(String name) async {
    try {
      await controller.addTaskCategory(name);
    } catch (e) {
      Get.snackbar('key_error'.tr, 'key_failed_to_add_category'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _updateCategory(int? id, String name) async {
    if (id == null) {
      // Handles "Home" category
      Get.snackbar('key_error'.tr, 'key_cannot_update_home'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      await controller.updateTaskCategory(id, name);
    } catch (e) {
      Get.snackbar('key_error'.tr, 'key_failed_to_update_category'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _deleteCategory(int? id, RxBool isDeletingController) async {
    if (id == null) {
      // Handles "Home" category
      Get.snackbar('key_error'.tr, 'key_cannot_delete_home'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      await controller.deleteTaskCategory(id);
    } catch (e) {
      Get.snackbar('key_error'.tr, 'key_failed_to_delete_category'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _setTasksToPending(int? categoryId) async {
    try {
      // controller.setTasksToPending already handles null categoryId for "Home"
      await controller.setTasksToPending(categoryId);
    } catch (e) {
      Get.snackbar('key_error'.tr, 'key_failed_to_set_pending'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final RxBool showAddField = false.obs;
    final RxBool isDeleting = false.obs; // For delete operation feedback

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.appTheme.colorScheme.secondary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'key_categories'.tr,
                  style: TextStyle(
                    color: context.appTheme.colorScheme.onSecondary,
                    fontSize: context.scaleConfig.scaleText(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => IconButton(
                    icon: Icon(
                      showAddField.value ? Icons.close : Icons.add,
                      color: context.appTheme.colorScheme.onSecondary,
                    ),
                    onPressed: () {
                      showAddField.value = !showAddField.value;
                      if (!showAddField.value) {
                        nameController.clear();
                      }
                    },
                    tooltip: showAddField.value
                        ? 'key_cancel'.tr
                        : 'key_add_category'.tr,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => showAddField.value
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scaleConfig.scale(16),
                      vertical: context.scaleConfig.scale(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'key_category_name'.tr,
                              border: const OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: context.scaleConfig.scale(12),
                                vertical: context.scaleConfig.scale(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: context.scaleConfig.scale(8)),
                        ElevatedButton(
                          onPressed: () async {
                            if (nameController.text.isNotEmpty) {
                              await _addCategory(nameController.text);
                              nameController.clear();
                              showAddField.value = false;
                            } else {
                              Get.snackbar(
                                'key_error'.tr,
                                'key_category_name_empty'.tr,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                context.appTheme.colorScheme.secondary,
                            foregroundColor:
                                context.appTheme.colorScheme.onSecondary,
                            padding: EdgeInsets.symmetric(
                              horizontal: context.scaleConfig.scale(16),
                              vertical: context.scaleConfig.scale(8),
                            ),
                          ),
                          child: Text('key_add'.tr),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: GetBuilder<HomeController>(
              id: 'task-category-view', // Updates when controller.taskCategories changes
              builder: (controller) {
                // Start with the "Home" category
                final List<CategoryModel> displayCategories = [
                  CategoryModel(id: null, categoryName: "key_home".tr)
                ];
                // Add all other task categories from the database
                displayCategories.addAll(controller.taskCategories);

                return ListView.builder(
                  itemCount: displayCategories.length,
                  itemBuilder: (context, index) {
                    final category = displayCategories[index];
                    final bool isHomeCategory = category.id == null;

                    return ExpansionTile(
                      leading: Icon(
                        isHomeCategory
                            ? FontAwesomeIcons.houseChimney
                            : FontAwesomeIcons.folder,
                        color: context.appTheme.colorScheme.primary,
                        size: context.scaleConfig.scale(20),
                      ),
                      title: Text(
                        category
                            .categoryName, // This will be "key_home".tr for the Home category
                        style: TextStyle(
                          fontSize: context.scaleConfig.scaleText(16),
                        ),
                      ),
                      initiallyExpanded:
                          controller.selectedTaskCategoryId.value ==
                              category.id,
                      onExpansionChanged: (expanded) {
                        // No direct check for isTaskDrawer here, as filtering should always work
                        if (expanded) {
                          controller.filterTasksByCategory(category.id);
                        } else {
                          if (controller.selectedTaskCategoryId.value ==
                              category.id) {
                            controller.filterTasksByCategory(
                                null); // Filter by "Home" (all unassigned)
                          }
                        }
                      },
                      children: [
                        if (isTaskDrawer) // Only show task titles if isTaskDrawer is true
                          FutureBuilder<List<String>>(
                            future: _fetchTaskTitles(context, category),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('key_error_fetching_tasks'.tr),
                                );
                              }
                              final taskTitles = snapshot.data ?? [];
                              if (taskTitles.isEmpty && !isHomeCategory) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.scaleConfig
                                        .scale(16 + 8), // Indent
                                    vertical: context.scaleConfig.scale(8),
                                  ),
                                  child: Text('key_no_tasks_in_category'.tr,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic)),
                                );
                              }
                              if (taskTitles.isEmpty && isHomeCategory) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.scaleConfig.scale(16),
                                  vertical: context.scaleConfig.scale(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'key_tasks'.tr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            context.scaleConfig.scaleText(14),
                                        color: context
                                            .appTheme.colorScheme.primary,
                                      ),
                                    ),
                                    SizedBox(
                                        height: context.scaleConfig.scale(4)),
                                    ...taskTitles.map((title) => Padding(
                                          padding: EdgeInsets.only(
                                            left: context.scaleConfig.scale(8),
                                            bottom:
                                                context.scaleConfig.scale(4),
                                          ),
                                          child: Text(
                                            "- $title",
                                            style: TextStyle(
                                              fontSize: context.scaleConfig
                                                  .scaleText(14),
                                              color: context.appTheme
                                                  .colorScheme.onSurface,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )),
                                  ],
                                ),
                              );
                            },
                          ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleConfig.scale(16),
                            vertical: context.scaleConfig.scale(8),
                          ),
                          child: Wrap(
                            // Use Wrap for better layout on small screens
                            spacing: context.scaleConfig.scale(8),
                            alignment: WrapAlignment
                                .spaceBetween, // Distribute space for fewer items
                            runSpacing: context.scaleConfig.scale(4),
                            children: [
                              TextButton.icon(
                                icon: Icon(
                                  Icons.edit,
                                  color: isHomeCategory
                                      ? Colors.grey
                                      : context.appTheme.colorScheme.primary,
                                  size: context.scaleConfig.scale(18),
                                ),
                                label: Text('key_edit'.tr,
                                    style: TextStyle(
                                        color: isHomeCategory
                                            ? Colors.grey
                                            : null)),
                                onPressed: isHomeCategory
                                    ? null // Disable Edit for "Home"
                                    : () {
                                        _showEditCategoryDialog(
                                            context, category);
                                      },
                              ),
                              Obx(
                                () => TextButton.icon(
                                  icon: isDeleting.value &&
                                          controller.selectedTaskCategoryId
                                                  .value ==
                                              category.id
                                      ? SizedBox(
                                          width: context.scaleConfig.scale(18),
                                          height: context.scaleConfig.scale(18),
                                          child: CircularProgressIndicator(
                                            strokeWidth:
                                                context.scaleConfig.scale(2),
                                            color: Colors.redAccent,
                                          ),
                                        )
                                      : Icon(
                                          Icons.delete,
                                          color: isHomeCategory
                                              ? Colors.grey
                                              : Colors.redAccent,
                                          size: context.scaleConfig.scale(18),
                                        ),
                                  label: Text('key_delete'.tr,
                                      style: TextStyle(
                                          color: isHomeCategory
                                              ? Colors.grey
                                              : null)),
                                  onPressed: isHomeCategory || isDeleting.value
                                      ? null // Disable Delete for "Home" or if any delete is in progress
                                      : () {
                                          _confirmDeleteCategory(
                                              context, category, isDeleting);
                                        },
                                ),
                              ),
                              // "Set to Pending" button is always enabled
                              TextButton.icon(
                                icon: Icon(
                                  Icons.refresh,
                                  color: context.appTheme.colorScheme.primary,
                                  size: context.scaleConfig.scale(18),
                                ),
                                label: Text('key_set_pending'.tr),
                                onPressed: () {
                                  _confirmSetTasksToPending(context, category);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(BuildContext context, CategoryModel category) {
    if (category.id == null) {
      _updateCategory(null, ''); // Will show 'key_cannot_update_home'
      return;
    }
    print('Opening edit task category dialog for ${category.categoryName}');
    final TextEditingController nameController = TextEditingController(
        text: category.categoryName == "key_home".tr
            ? category.categoryName.tr
            : category.categoryName); // Display translated name if it's the key

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        title: Text('key_edit_category'.tr),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'key_category_name'.tr,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text('key_cancel'.tr),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await _updateCategory(category.id, nameController.text);
                Navigator.of(dialogContext).pop();
              } else {
                Get.snackbar(
                  'key_error'.tr,
                  'key_category_name_empty'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: Text('key_update'.tr),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCategory(BuildContext context, CategoryModel category,
      RxBool isDeletingController) {
    if (category.id == null) {
      _deleteCategory(
          null, isDeletingController); // Will show 'key_cannot_delete_home'
      return;
    }
    print('Opening delete task category dialog for ${category.categoryName}');
    // Get the translated name for the dialog message
    // String displayCategoryName = category.categoryName.tr;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        title: Text('key_delete_category'.tr), // Title can remain the same
        content: Text(
            'key_confirm_delete_selected_category'.tr // Use the new generic key
            ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text('key_cancel'.tr),
          ),
          TextButton(
            onPressed: () async {
              isDeletingController.value = true;
              await _deleteCategory(category.id, isDeletingController);
              isDeletingController.value = false;
              Navigator.of(dialogContext).pop();
            },
            child: Text('key_delete'.tr),
          ),
        ],
      ),
    );
  }

  void _confirmSetTasksToPending(BuildContext context, CategoryModel category) {
    print('Opening set tasks pending dialog for ${category.categoryName}');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        title: Text('key_set_tasks_pending'.tr),
        content: Text(
          'key_confirm_set_all_tasks_in_selected_category_pending'.tr,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text('key_cancel'.tr),
          ),
          TextButton(
            onPressed: () async {
              await _setTasksToPending(
                  category.id); // Pass original id (null for Home)
              Navigator.of(dialogContext).pop();
            },
            child: Text('key_confirm'.tr),
          ),
        ],
      ),
    );
  }
}
