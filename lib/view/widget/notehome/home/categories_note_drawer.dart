import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/data/model/categorymodel.dart';
import 'package:tasknotate/data/datasource/local/sqldb.dart';

class NoteCategoryDrawer extends StatelessWidget {
  final HomeController controller;
  final bool
      isNoteDrawer; // This flag seems to determine if note titles are shown

  const NoteCategoryDrawer({
    super.key,
    required this.controller,
    required this.isNoteDrawer,
  });

  Future<List<String>> _fetchNoteTitles(
      BuildContext context, CategoryModel category) async {
    final SqlDb sqlDb = SqlDb();
    List<Map<String, dynamic>> notesResponse;
    // For "Home" category, category.id will be null
    if (category.id == null) {
      notesResponse = await sqlDb.readData(
        'SELECT title FROM notes WHERE categoryId IS NULL',
      );
    } else {
      notesResponse = await sqlDb.readData(
        'SELECT title FROM notes WHERE categoryId = ?',
        [category.id],
      );
    }
    return notesResponse.map((note) => note['title'] as String).toList();
  }

  Future<void> _addNoteCategory(String name) async {
    try {
      await controller.addNoteCategory(name);
    } catch (e) {
      Get.snackbar('key_error'.tr, 'key_failed_to_add_category'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // This local helper already prevents updating "Home"
  Future<void> _updateNoteCategory(int? id, String name) async {
    if (id == null) {
      // This correctly identifies the "Home" category
      Get.snackbar('key_error'.tr, 'key_cannot_update_home'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      await controller.updateNoteCategory(id, name);
    } catch (e) {
      Get.snackbar('key_error'.tr, 'key_failed_to_update_category'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // This local helper already prevents deleting "Home"
  Future<void> _deleteNoteCategory(int? id, RxBool isDeletingController) async {
    if (id == null) {
      // This correctly identifies the "Home" category
      Get.snackbar('key_error'.tr, 'key_cannot_delete_home'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      // Pass the RxBool to the controller if it needs to manage its state,
      // or manage it locally if the controller's delete method is synchronous
      // For simplicity, assuming controller.deleteNoteCategory handles its own feedback
      // or the existing isDeleting logic is sufficient.
      await controller.deleteNoteCategory(id);
    } catch (e) {
      Get.snackbar('key_error'.tr, 'key_failed_to_delete_category'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final RxBool showAddField = false.obs;
    // isDeleting is used to provide feedback during the delete operation.
    // It's a single bool for all categories in this drawer instance.
    final RxBool isDeleting = false.obs;

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
                              await _addNoteCategory(nameController.text);
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
              id: 'note-category-view', // Updates when controller.noteCategories changes
              builder: (controller) {
                // Start with the "Home" category
                final List<CategoryModel> displayCategories = [
                  CategoryModel(id: null, categoryName: "key_home".tr)
                ];
                // Add all other categories from the database
                displayCategories.addAll(controller.noteCategories);

                // No need for this anymore, "Home" is always there.
                // if (categories.isEmpty) {
                //   return Center(child: Text('key_no_categories'.tr));
                // }

                return ListView.builder(
                  itemCount: displayCategories.length,
                  itemBuilder: (context, index) {
                    final category = displayCategories[index];
                    final bool isHomeCategory = category.id == null;

                    return ExpansionTile(
                      // Use a key if items can be reordered, but here order is fixed.
                      // key: ValueKey(category.id ?? 'home_category'),
                      leading: Icon(
                        isHomeCategory
                            ? FontAwesomeIcons.houseChimney
                            : FontAwesomeIcons
                                .folder, // Differentiate Home icon
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
                      // Keep tile expanded if it's the currently selected filter
                      initiallyExpanded:
                          controller.selectedNoteCategoryId.value ==
                              category.id,
                      onExpansionChanged: (expanded) {
                        if (isNoteDrawer) {
                          if (expanded) {
                            // When expanded, filter by this category
                            controller.filterNotesByCategory(category.id);
                          } else {
                            // When collapsed, if it was the selected one, clear filter (select "Home"/All)
                            if (controller.selectedNoteCategoryId.value ==
                                category.id) {
                              controller.filterNotesByCategory(null);
                            }
                          }
                        }
                      },
                      children: [
                        if (isNoteDrawer) // If this drawer is for notes, show note titles
                          FutureBuilder<List<String>>(
                            future: _fetchNoteTitles(context, category),
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
                                  child: Text('key_error_fetching_notes'
                                      .tr), // More specific error key
                                );
                              }
                              final noteTitles = snapshot.data ?? [];
                              if (noteTitles.isEmpty && !isHomeCategory) {
                                // Don't hide for home if it's empty
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.scaleConfig
                                        .scale(16 + 8), // Indent
                                    vertical: context.scaleConfig.scale(8),
                                  ),
                                  child: Text('key_no_notes_in_category'.tr,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic)),
                                );
                              }
                              if (noteTitles.isEmpty && isHomeCategory) {
                                return const SizedBox
                                    .shrink(); // Or a message like "No notes in Home"
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
                                      'key_notes'.tr, // Sub-header "Notes"
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
                                    ...noteTitles.map((title) => Padding(
                                          padding: EdgeInsets.only(
                                            left: context.scaleConfig
                                                .scale(8), // Indent note titles
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Or MainAxisAlignment.end for buttons on one side
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
                                            context, controller, category);
                                      },
                              ),
                              Obx(
                                // Use Obx for the delete button if its state depends on isDeleting
                                () => TextButton.icon(
                                  icon: isDeleting.value &&
                                          controller.selectedNoteCategoryId
                                                  .value ==
                                              category
                                                  .id // Example: Show spinner only for the one being deleted
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
                                  onPressed: isHomeCategory ||
                                          isDeleting
                                              .value // Disable Delete for "Home" or if any delete is in progress
                                      ? null
                                      : () {
                                          _confirmDeleteCategory(context,
                                              controller, category, isDeleting);
                                        },
                                ),
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

  void _showEditCategoryDialog(
      BuildContext context, HomeController controller, CategoryModel category) {
    // This check is redundant if button is disabled, but good for safety
    if (category.id == null) {
      _updateNoteCategory(
          null, ''); // This will show the 'key_cannot_update_home' snackbar
      return;
    }
    print('Opening edit note category dialog for ${category.categoryName}');
    final TextEditingController nameController =
        TextEditingController(text: category.categoryName);
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
              print('Cancel button pressed for edit note dialog');
              Navigator.of(dialogContext).pop();
            },
            child: Text('key_cancel'.tr),
          ),
          TextButton(
            onPressed: () async {
              print('Update button pressed for edit note dialog');
              if (nameController.text.isNotEmpty) {
                // _updateNoteCategory handles the id == null case internally,
                // but here category.id is guaranteed not to be null.
                await _updateNoteCategory(category.id, nameController.text);
                print('Closing edit note dialog after update');
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

  void _confirmDeleteCategory(BuildContext context, HomeController controller,
      CategoryModel category, RxBool isDeletingController) {
    // This check is redundant if button is disabled, but good for safety
    if (category.id == null) {
      _deleteNoteCategory(null,
          isDeletingController); // This will show 'key_cannot_delete_home'
      return;
    }
    print('Opening delete note category dialog for ${category.categoryName}');
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        title: Text('key_delete_category'.tr),
        content: Text('key_confirm_delete_category'
            .tr
            .replaceFirst('{}', category.categoryName)),
        actions: [
          TextButton(
            onPressed: () {
              print('Cancel button pressed for delete note dialog');
              Navigator.of(dialogContext).pop();
            },
            child: Text('key_cancel'.tr),
          ),
          TextButton(
            onPressed: () async {
              print('Delete button pressed for delete note dialog');
              isDeletingController.value = true; // Start loading
              // _deleteNoteCategory handles id == null internally,
              // but here category.id is guaranteed not to be null.
              await _deleteNoteCategory(category.id, isDeletingController);
              isDeletingController.value = false; // Stop loading
              print('Closing delete note dialog after deletion attempt');
              Navigator.of(dialogContext).pop();
            },
            child: Text('key_delete'.tr),
          ),
        ],
      ),
    );
  }
}
