import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/data/datasource/local/sqldb.dart';
import 'package:tasknotate/data/model/usernotesmodel.dart';

class NoteviewController extends GetxController {
  UserNotesModel? note;
  TextEditingController? insideTextField;
  TextEditingController? insideTitleField;
  Uint8List? drawingBytes;

  SqlDb sqlDb = SqlDb();

  int? selectedCategoryId;
  SignatureController? signatureController;

  bool isDrawingMode = false;
  Timer? _debounceTimer;
  bool _isClosing = false; // Internal flag to manage state during disposal

  bool isLoadingNoteFromArgs =
      true; // Flag to indicate if note is being loaded from arguments

  // Getter to check if text/signature controllers are initialized
  bool get areControllersInitialized =>
      insideTextField != null &&
      insideTitleField != null &&
      signatureController != null;

  @override
  void onInit() {
    super.onInit();
    print(
        "NoteviewController (${this.hashCode}): onInit. isLoadingNoteFromArgs = true.");
    _isClosing = false; // Reset internal closing state
    isLoadingNoteFromArgs = true; // We are about to process arguments

    // Initialize controllers
    insideTextField = TextEditingController();
    insideTitleField = TextEditingController();
    signatureController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
    print(
        "NoteviewController: onInit. Controllers initialized. isLoadingNoteFromArgs = true.");

    // Process arguments. This should happen reliably in onInit for GetX.
    _processArguments();
  }

  void _processArguments() {
    final arguments = Get.arguments;
    print(
        "[NoteviewController] _processArguments: Received arguments: $arguments");

    if (!_isClosing) {
      print(
          "[NoteviewController (${this.hashCode})] Argument processing finished. isLoadingNoteFromArgs: $isLoadingNoteFromArgs. Calling update().");
      update();
    }
    if (arguments != null &&
        arguments is Map &&
        arguments.containsKey('note')) {
      note = arguments['note'] as UserNotesModel?;
      if (note != null) {
        print(
            "NoteviewController: Note found in arguments: ID=${note!.id}, Title='${note!.title}'");
        loadNoteData(); // Populate fields from the note
      } else {
        print("NoteView: Note object from arguments is null!");
        note = null; // Ensure note is null if argument was invalid
      }
    } else {
      print(
          "NoteView: Note argument key 'note' not found or arguments are invalid.");
      note = null; // Ensure note is null if no valid arguments
    }
    isLoadingNoteFromArgs = false; // Argument processing is now complete

    // Update the UI after arguments are processed (or determined to be missing)
    // This is crucial for the UI to switch from loading state.
    if (!_isClosing) {
      print(
          "NoteviewController: Argument processing finished. isLoadingNoteFromArgs: $isLoadingNoteFromArgs. Calling update().");
      update();
    } else {
      print(
          "NoteviewController: Argument processing finished but controller is closing. Skipping update().");
    }
  }

  void loadNoteData() {
    // This method populates UI-related fields from `this.note`.
    // It assumes `this.note` is already populated and controllers are initialized.
    if (note == null || _isClosing || !areControllersInitialized) {
      print(
          "loadNoteData: Skipped - note is null, or closing, or controllers not init.");
      return;
    }
    print("loadNoteData: Loading data into fields for note ID: ${note!.id}");

    insideTitleField!.text = note!.title ?? "";
    insideTextField!.text = note!.content ?? "";

    if (note!.drawing != null && note!.drawing!.isNotEmpty) {
      try {
        drawingBytes = base64Decode(note!.drawing!);
      } catch (e) {
        print("Error decoding drawing in loadNoteData: $e");
        drawingBytes = null;
      }
    } else {
      drawingBytes = null;
    }
    signatureController!.clear(); // Clear canvas for any new drawing session
    selectedCategoryId =
        note!.categoryId != null ? int.tryParse(note!.categoryId!) : null;

    print("loadNoteData: Finished setting up fields.");
    // No update() call here; the initial update is handled by _processArguments.
    // Subsequent calls to loadNoteData (if any) would need their own update logic if they change UI state.
  }

  void toggleDrawingMode() {
    if (_isClosing || !areControllersInitialized) return;
    isDrawingMode = !isDrawingMode;
    if (isDrawingMode) {
      signatureController!.clear();
      print("Entering drawing mode. Canvas cleared.");
    }
    if (!_isClosing) update(); // Update UI only if not closing
  }

  void saveContent(String value) {
    if (note == null || _isClosing || !areControllersInitialized) return;
    note = note!
        .copyWith(content: value, title: insideTitleField?.text ?? note!.title);
    _debounceUpdate();
  }

  void saveTitle(String value) {
    if (note == null || _isClosing || !areControllersInitialized) return;
    note = note!.copyWith(
        title: value, content: insideTextField?.text ?? note!.content);
    _debounceUpdate();
  }

  void _debounceUpdate() {
    if (_isClosing) return; // Don't schedule if closing
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (!_isClosing) {
        // Check again before executing
        updateData();
      }
    });
  }

  Future<void> updateData() async {
    if (_isClosing || !areControllersInitialized) {
      print(
          "NoteviewController: updateData skipped, _isClosing: $_isClosing or controllers not init.");
      return;
    }

    if (note == null || note!.id == null) {
      print("Error: Note or note ID is null in updateData (View)");
      if (!_isClosing)
        update(); // Update UI to reflect this state if not closing
      return;
    }

    String titleToSave = insideTitleField!.text;
    String contentToSave = insideTextField!.text;
    String? drawingToSave = note!.drawing; // Start with current drawing

    if (isDrawingMode && signatureController!.isNotEmpty) {
      drawingToSave = await getDrawingAsBase64();
    } else if (isDrawingMode &&
        signatureController!.isEmpty &&
        drawingBytes != null) {
      // User was in drawing mode, cleared canvas, and there was an old drawing
      drawingToSave = null; // Means the drawing was intentionally cleared
    }
    // If not in drawing mode, drawingToSave remains note!.drawing (or whatever it was before this call)

    if (titleToSave.isEmpty &&
        contentToSave.isEmpty &&
        (drawingToSave == null || drawingToSave.isEmpty)) {
      print("Skipping update: Note is effectively empty (View)");
      // Optionally, handle deletion of note if it becomes completely empty
      // if (!_isClosing) update(); // Update UI to reflect empty state if needed
      return;
    }

    final updatedNoteModel = UserNotesModel(
      id: note!.id,
      title: titleToSave,
      content: contentToSave,
      date: note!.date, // Preserve original creation date
      drawing: drawingToSave,
      categoryId: selectedCategoryId?.toString(),
    );

    try {
      final response = await sqlDb.updateData(
        "UPDATE notes SET title = ?, content = ?, drawing = ?, categoryId = ? WHERE id = ?",
        [
          updatedNoteModel.title,
          updatedNoteModel.content,
          updatedNoteModel.drawing,
          updatedNoteModel.categoryId,
          updatedNoteModel.id,
        ],
      );

      // Critical check *after* await
      if (_isClosing) {
        print(
            "NoteviewController: updateData response received, but now _isClosing is true. Aborting further processing.");
        return;
      }

      if (response > 0) {
        note =
            updatedNoteModel; // Update the controller's current note instance
        // Reflect saved drawing in drawingBytes
        if (note!.drawing != null && note!.drawing!.isNotEmpty) {
          drawingBytes = base64Decode(note!.drawing!);
        } else {
          drawingBytes = null;
        }

        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>()
              .getNoteData(); // Refresh notes list in home
        }
        print("Note updated successfully (View): ID=${note!.id}");
      } else {
        print("Failed to update note (View): ID=${note!.id}");
      }
    } catch (e) {
      if (!_isClosing) {
        // Log error only if not closing
        print("Error updating note (View): $e");
      }
    }

    // Final UI update, only if not closing
    if (!_isClosing) {
      update();
    } else {
      print(
          "NoteviewController: updateData finished, but _isClosing is true. Final GetX update() skipped.");
    }
  }

  Future<String?> getDrawingAsBase64() async {
    if (_isClosing ||
        !areControllersInitialized ||
        signatureController == null) {
      return note
          ?.drawing; // Fallback to existing if controller not ready or closing
    }

    if (signatureController!.isNotEmpty) {
      final bytes = await signatureController!.toPngBytes();
      return bytes != null ? base64Encode(bytes) : null;
    }
    // If in drawing mode and canvas is empty, it signifies no new drawing or it was cleared
    if (isDrawingMode) return null;

    // If not in drawing mode, or canvas is empty when not in drawing mode, return the existing drawing
    return note?.drawing;
  }

  @override
  void onClose() {
    print("NoteviewController: onClose started. Setting _isClosing to true.");
    _isClosing = true; // Set flag immediately to prevent further operations
    _debounceTimer?.cancel(); // Cancel any pending debounced updates

    // Log potential unsaved changes if applicable
    if (areControllersInitialized && note != null && note!.id != null) {
      bool titleChanged = insideTitleField!.text != (note!.title ?? "");
      bool contentChanged = insideTextField!.text != (note!.content ?? "");
      if (titleChanged ||
          contentChanged ||
          (isDrawingMode && signatureController?.isNotEmpty == true)) {
        print(
            "NoteView onClose: Potential unsaved changes. Title='${insideTitleField!.text}', Content='${insideTextField!.text}'");
        // Avoid calling async updateData() here as it's risky during onClose.
        // Rely on debounced saves or explicit save actions by the user.
      }
    }

    print(
        "NoteviewController: Disposing TextEditingControllers and SignatureController.");
    insideTextField?.dispose();
    insideTitleField?.dispose();
    signatureController?.dispose();

    // Nullify to help GC and make state explicit
    insideTextField = null;
    insideTitleField = null;
    signatureController = null;

    super.onClose();
    print("NoteviewController: onClose completed.");
  }
}
