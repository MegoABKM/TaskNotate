import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/data/model/usernotesmodel.dart';
import 'package:tasknotate/view/widget/notehome/home/animate_app_bar_note.dart';
import 'package:tasknotate/view/widget/notehome/home/card_content_note.dart';
import 'package:tasknotate/view/widget/notehome/home/categories_note_drawer.dart';
import 'package:tasknotate/view/widget/notehome/home/category_dropdown_note.dart';
import 'package:tasknotate/view/widget/notehome/home/custom_float_button_note.dart';
import 'package:tasknotate/view/widget/notehome/home/empty_note_message.dart';
import 'package:tasknotate/view/widget/notehome/home/title_note.dart';

class NotesHome extends GetView<HomeController> {
  const NotesHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NoteCategoryDrawer(
        controller: Get.find<HomeController>(),
        isNoteDrawer: true,
      ),
      floatingActionButton: CustomFloatButtonNote(),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: CustomScrollView(
          slivers: [
            const AnimateAppBarNote(),
            // Add the NoteCategoryDropdown in the middle
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.scaleConfig.scale(8),
                  horizontal: context.scaleConfig.scale(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NoteCategoryDropdown(
                      controller: controller,
                    ),
                  ],
                ),
              ),
            ),
            GetBuilder<HomeController>(
              id: 'notes-view',
              builder: (controller) {
                if (controller.isLoadingNotes) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (controller.notedata.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyNoteMessage(),
                  );
                } else {
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scaleConfig.scale(8),
                      vertical: context.scaleConfig.scale(5),
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        crossAxisSpacing: context.scaleConfig.scale(10),
                        maxCrossAxisExtent: context.scaleConfig.scale(200),
                        childAspectRatio: 0.55,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          UserNotesModel note = controller.notedata[index];
                          return Column(
                            children: [
                              Expanded(
                                flex: 4,
                                child: CardContentNote(note),
                              ),
                              Expanded(
                                flex: 1,
                                child: Titlenote(
                                  "${note.title ?? 'Untitled'}\n${DateFormat("dd/MMMM").format(DateTime.parse(note.date ?? DateTime.now().toIso8601String()))}",
                                ),
                              ),
                            ],
                          );
                        },
                        childCount: controller.notedata.length,
                      ),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
