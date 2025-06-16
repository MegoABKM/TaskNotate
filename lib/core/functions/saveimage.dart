import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<String> saveImageToFileSystem(XFile image) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final String extension = path.extension(image.path);
    final String newPath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}$extension';
    final File newImage = await File(image.path).copy(newPath);
    return newImage.path;
  } catch (e) {
    print("Error saving image: $e");
    return "";
  }
}

// Future<String?> getImagePathFromDatabase() async {
//   SqlDb sqlDb = SqlDb();
//   final List<Map<String, dynamic>> results = await sqlDb.query('images');
//   return results.isNotEmpty ? results.first['path'] as String : null;
// }


// Future<XFile?> pickImage() async {
//   final picker = ImagePicker();
//   return await picker.pickImage(source: ImageSource.gallery);
// }

