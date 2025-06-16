import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:tasknotate/data/datasource/local/sqldb.dart';
import 'package:tasknotate/data/model/usernotesmodel.dart';
import 'package:tasknotate/controller/home_controller.dart';

class NotecreateController extends GetxController {
  TextEditingController? titleController;
  TextEditingController? insideTextField;
  int? selectedCategoryId;
  SqlDb sqlDb = SqlDb();

  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  bool isDrawingMode = false;
  UserNotesModel? currentNote;
  int? lastInsertedId;

  Timer? _debounceTimer;

  void toggleDrawingMode() {
    isDrawingMode = !isDrawingMode;
    update();
  }

  Future<String?> getDrawingAsBase64() async {
    if (signatureController.isNotEmpty) {
      final bytes = await signatureController.toPngBytes();
      return bytes != null ? base64Encode(bytes) : null;
    }
    return currentNote?.drawing;
  }

  void saveTitle(String value) {
    currentNote = UserNotesModel(
      id: lastInsertedId?.toString(),
      title: value, // Store what the user types, even if empty
      content: currentNote?.content ?? '',
      date: currentNote?.date ?? DateTime.now().toIso8601String(),
      drawing: currentNote?.drawing ?? '',
      categoryId: selectedCategoryId?.toString(),
    );
    _debounceUpload();
  }

  void saveContent(String value) {
    currentNote = UserNotesModel(
      id: lastInsertedId?.toString(),
      title: currentNote?.title ??
          titleController?.text ??
          '', // Use existing or text field
      content: value,
      date: currentNote?.date ?? DateTime.now().toIso8601String(),
      drawing: currentNote?.drawing ?? '',
      categoryId: selectedCategoryId?.toString(),
    );
    _debounceUpload();
  }

  void updateNoteCategory() {
    currentNote = UserNotesModel(
      id: lastInsertedId?.toString(),
      title: currentNote?.title ?? titleController?.text ?? '',
      content: currentNote?.content ?? '',
      date: currentNote?.date ?? DateTime.now().toIso8601String(),
      drawing: currentNote?.drawing ?? '',
      categoryId: selectedCategoryId?.toString(),
    );
    uploadData(); // Immediate upload for category change
  }

  void _debounceUpload() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      uploadData();
    });
  }

  Future<void> uploadData() async {
    if (currentNote == null) {
      print("Error: currentNote is null in uploadData");
      update(); // Notify listeners if any depend on this state
      return;
    }

    // Prepare title: if user left it empty, store as empty.
    // The UI will handle displaying "key_untitled".tr
    String titleToSave = currentNote!.title ?? '';
    String contentToSave = currentNote!.content ?? '';
    String? drawingToSave = currentNote!.drawing;

    // Get drawing if in drawing mode
    if (isDrawingMode && signatureController.isNotEmpty) {
      drawingToSave = await getDrawingAsBase64();
    }

    // Prevent saving truly empty notes (no title, no content, no drawing)
    if (titleToSave.isEmpty &&
        contentToSave.isEmpty &&
        (drawingToSave == null || drawingToSave.isEmpty)) {
      print("Skipping upload: Note is effectively empty");
      // If it was an existing note that became empty, consider deleting it or handling it
      // For a new note, just don't create it.
      if (lastInsertedId != null) {
        // Potentially delete if an existing note is made completely empty
        // await sqlDb.deleteData("DELETE FROM notes WHERE id = ?", [lastInsertedId]);
        // lastInsertedId = null; // Reset since it's deleted
        // Get.find<HomeController>().getNoteData();
        // print("Empty existing note, potentially deleted.");
      }
      return;
    }

    // Update currentNote model with final values before DB operation
    currentNote = UserNotesModel(
      id: lastInsertedId?.toString(),
      title: titleToSave, // Store potentially empty title
      content: contentToSave,
      date: currentNote!.date, // Keep original creation date
      drawing: drawingToSave,
      categoryId: selectedCategoryId?.toString(),
    );

    try {
      if (lastInsertedId == null) {
        // Creating a new note
        final response = await sqlDb.insertData(
          "INSERT INTO notes (title, content, date, drawing, categoryId) VALUES (?, ?, ?, ?, ?)",
          [
            currentNote!.title, // Can be empty
            currentNote!.content,
            currentNote!.date,
            currentNote!.drawing,
            currentNote!.categoryId,
          ],
        );

        if (response > 0) {
          lastInsertedId = response;
          // Update the currentNote object with the new ID for subsequent updates
          currentNote = currentNote!.copyWith(id: lastInsertedId.toString());
          Get.find<HomeController>().getNoteData();
          print("Note created successfully with ID: $lastInsertedId");
        } else {
          print("Failed to create note");
        }
      } else {
        // Updating an existing note
        final response = await sqlDb.updateData(
          "UPDATE notes SET title = ?, content = ?, drawing = ?, categoryId = ? WHERE id = ?",
          [
            currentNote!.title, // Can be empty
            currentNote!.content,
            currentNote!.drawing,
            currentNote!.categoryId,
            lastInsertedId,
          ],
        );

        if (response > 0) {
          Get.find<HomeController>().getNoteData();
          print("Note updated successfully with ID: $lastInsertedId");
        } else {
          print("Failed to update note with ID: $lastInsertedId");
        }
      }
    } catch (e) {
      print("Error uploading note: $e");
    }
    update(); // Update UI if necessary
  }

  @override
  void onInit() {
    titleController = TextEditingController();
    insideTextField = TextEditingController();
    // Initialize currentNote with empty strings and current date
    currentNote = UserNotesModel(
      title: '',
      content: '',
      date: DateTime.now().toIso8601String(),
      drawing: '',
      categoryId: null, // Explicitly null
    );
    super.onInit();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    // Important: Final save attempt if there's pending data and it's a valid note
    if (currentNote != null &&
        !((currentNote!.title?.isEmpty ?? true) &&
            (currentNote!.content?.isEmpty ?? true) &&
            (currentNote!.drawing?.isEmpty ?? true))) {
      uploadData(); // Ensure any debounced changes are saved
    }
    titleController?.dispose();
    insideTextField?.dispose();
    signatureController.dispose();
    super.onClose();
  }
}
