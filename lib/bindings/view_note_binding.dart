// Create a new file, e.g., lib/bindings/view_note_binding.dart
import 'package:get/get.dart';
import 'package:tasknotate/controller/notes/noteview_controller.dart';

class ViewNoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoteviewController>(() => NoteviewController());
    print("[ViewNoteBinding] NoteviewController lazyPut.");
  }
}
