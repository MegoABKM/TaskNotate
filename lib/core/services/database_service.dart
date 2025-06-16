import 'package:get/get.dart';
import 'package:tasknotate/data/datasource/local/sqldb.dart';

class DatabaseService extends GetxService {
  SqlDb sqlDb = SqlDb();

  Future<DatabaseService> init() async {
    // Initialize database if needed
    return this;
  }
}
