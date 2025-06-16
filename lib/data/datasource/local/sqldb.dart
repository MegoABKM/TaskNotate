import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDb {
  static Database? _db;

  Future<Database> get db async {
    if (_db == null) _db = await _initializeDb();
    return _db!;
  }

  Future<Database> _initializeDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "tasknotate1233333.db");
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async => await db.execute('PRAGMA foreign_keys = ON;'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE categoriestasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      categoryName TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE categoriesnotes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      categoryName TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      content TEXT NOT NULL,
      Date TEXT,
      drawing TEXT,
      categoryId INTEGER,
      FOREIGN KEY (categoryId) REFERENCES categoriesnotes(id) ON DELETE SET NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      content TEXT NOT NULL,
      date TEXT,
      estimatetime TEXT,
      starttime TEXT,
      reminder TEXT,
      status TEXT NOT NULL DEFAULT 'Not Set',
      priority TEXT NOT NULL DEFAULT 'Not Set',
      subtask TEXT,
      images TEXT,
      timeline TEXT,
      categoryId INTEGER,
      FOREIGN KEY (categoryId) REFERENCES categoriestasks(id) ON DELETE SET NULL
    )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE categoriestasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        categoryName TEXT NOT NULL
      )
      ''');
      await db.execute('''
      CREATE TABLE categoriesnotes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        categoryName TEXT NOT NULL
      )
      ''');
      final categories = await db.rawQuery('SELECT * FROM categories');
      for (var category in categories) {
        final categoryId = category['id'];
        final categoryName = category['categoryName'];
        final taskCount = Sqflite.firstIntValue(await db.rawQuery(
                'SELECT COUNT(*) FROM task_categories WHERE categoryId = ?',
                [categoryId])) ??
            0;
        if (taskCount > 0) {
          await db.rawInsert(
              'INSERT INTO categoriestasks (categoryName) VALUES (?)',
              [categoryName]);
        }
        final noteCount = Sqflite.firstIntValue(await db.rawQuery(
                'SELECT COUNT(*) FROM note_categories WHERE categoryId = ?',
                [categoryId])) ??
            0;
        if (noteCount > 0) {
          await db.rawInsert(
              'INSERT INTO categoriesnotes (categoryName) VALUES (?)',
              [categoryName]);
        }
      }
      final tasks = await db.rawQuery('SELECT * FROM tasks');
      for (var task in tasks) {
        final oldCategoryId = task['categoryId'];
        if (oldCategoryId != null) {
          final taskCategoryMapping = await db.rawQuery(
              'SELECT categoryId FROM task_categories WHERE taskId = ?',
              [task['id']]);
          if (taskCategoryMapping.isNotEmpty) {
            final oldCatId = taskCategoryMapping.first['categoryId'];
            final newCat = await db.rawQuery(
                'SELECT id FROM categoriestasks WHERE categoryName = (SELECT categoryName FROM categories WHERE id = ?)',
                [oldCatId]);
            if (newCat.isNotEmpty) {
              final newCategoryId = newCat.first['id'];
              await db.rawUpdate('UPDATE tasks SET categoryId = ? WHERE id = ?',
                  [newCategoryId, task['id']]);
            }
          }
        }
      }
      final notes = await db.rawQuery('SELECT * FROM notes');
      for (var note in notes) {
        final oldCategoryId = note['categoryId'];
        if (oldCategoryId != null) {
          final noteCategoryMapping = await db.rawQuery(
              'SELECT categoryId FROM note_categories WHERE noteId = ?',
              [note['id']]);
          if (noteCategoryMapping.isNotEmpty) {
            final oldCatId = noteCategoryMapping.first['categoryId'];
            final newCat = await db.rawQuery(
                'SELECT id FROM categoriesnotes WHERE categoryName = (SELECT categoryName FROM categories WHERE id = ?)',
                [oldCatId]);
            if (newCat.isNotEmpty) {
              final newCategoryId = newCat.first['id'];
              await db.rawUpdate('UPDATE notes SET categoryId = ? WHERE id = ?',
                  [newCategoryId, note['id']]);
            }
          }
        }
      }
      await db.execute('DROP TABLE IF EXISTS task_categories');
      await db.execute('DROP TABLE IF EXISTS note_categories');
      await db.execute('DROP TABLE IF EXISTS categories');
    }
    if (oldVersion < 3) {
      await db.execute(
          'CREATE TABLE tasks_new AS SELECT id, title, content, Date, estimatetime, starttime, reminder, status, priority, subtask, images, timeline, categoryId FROM tasks');
      await db.execute('DROP TABLE tasks');
      await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT NOT NULL,
        Date TEXT,
        estimatetime TEXT,
        starttime TEXT,
        reminder TEXT,
        status TEXT NOT NULL DEFAULT 'Not Set',
        priority TEXT NOT NULL DEFAULT 'Not Set',
        subtask TEXT,
        images TEXT,
        timeline TEXT,
        categoryId INTEGER,
        FOREIGN KEY (categoryId) REFERENCES categoriestasks(id) ON DELETE SET NULL
      )
      ''');
      await db.execute(
          'INSERT INTO tasks SELECT id, title, content, Date, estimatetime, starttime, reminder, status, priority, subtask, images, timeline, categoryId FROM tasks_new');
      await db.execute('DROP TABLE tasks_new');
    }
  }

  Future<List<Map<String, dynamic>>> readData(String sql,
      [List<Object?>? arguments]) async {
    Database myDb = await db;
    return await myDb.rawQuery(sql, arguments);
  }

  Future<int> insertData(String sql, [List<Object?>? arguments]) async {
    Database myDb = await db;
    return await myDb.rawInsert(sql, arguments);
  }

  Future<int> updateData(String sql, [List<Object?>? arguments]) async {
    Database myDb = await db;
    return await myDb.rawUpdate(sql, arguments);
  }

  Future<int> deleteData(String sql, [List<Object?>? arguments]) async {
    Database myDb = await db;
    return await myDb.rawDelete(sql, arguments);
  }

  Future<void> transaction(Future<void> Function(Database) action) async {
    Database myDb = await db;
    await myDb.transaction((txn) async => await action(myDb));
  }
}
