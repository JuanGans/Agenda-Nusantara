import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

/// Database Helper - Singleton pattern
/// Menangani semua operasi CRUD untuk tasks dan users
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inisialisasi database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, AppConstants.DB_NAME);

    return openDatabase(
      path,
      version: AppConstants.DB_VERSION,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Membuat tabel saat database pertama kali dibuat
  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE ${AppConstants.TABLE_USERS} (
        ${AppConstants.COL_USER_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.COL_USER_USERNAME} TEXT NOT NULL,
        ${AppConstants.COL_USER_PASSWORD} TEXT NOT NULL
      )
    ''');

    // Create tasks table
    await db.execute('''
      CREATE TABLE ${AppConstants.TABLE_TASKS} (
        ${AppConstants.COL_TASK_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.COL_TASK_TITLE} TEXT NOT NULL,
        ${AppConstants.COL_TASK_DESCRIPTION} TEXT,
        ${AppConstants.COL_TASK_DUE_DATE} TEXT NOT NULL,
        ${AppConstants.COL_TASK_CATEGORY} TEXT NOT NULL,
        ${AppConstants.COL_TASK_IS_DONE} INTEGER DEFAULT 0,
        ${AppConstants.COL_TASK_COMPLETED_AT} TEXT
      )
    ''');

    // Insert default user
    await db.insert(
      AppConstants.TABLE_USERS,
      User(
        username: AppConstants.DEFAULT_USERNAME,
        password: AppConstants.DEFAULT_PASSWORD,
      ).toMap(),
    );
  }

  /// Handle database upgrade (jika version berubah)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementasi upgrade logic di sini jika diperlukan di masa depan
  }

  // ========================= USER OPERATIONS =========================

  /// Ambil user berdasarkan id
  Future<User?> getUserById(int id) async {
    final db = await database;
    final result = await db.query(
      AppConstants.TABLE_USERS,
      where: '${AppConstants.COL_USER_ID} = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  /// Ambil semua user
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final result = await db.query(AppConstants.TABLE_USERS);
    return result.map((map) => User.fromMap(map)).toList();
  }

  /// Insert user baru
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(
      AppConstants.TABLE_USERS,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update user
  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      AppConstants.TABLE_USERS,
      user.toMap(),
      where: '${AppConstants.COL_USER_ID} = ?',
      whereArgs: [user.id],
    );
  }

  /// Validasi login
  Future<bool> validateLogin(String username, String password) async {
    final users = await getAllUsers();
    for (var user in users) {
      if (user.username == username && user.password == password) {
        return true;
      }
    }
    return false;
  }

  /// Update password user
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    final users = await getAllUsers();
    if (users.isEmpty) return false;

    final user = users.first;
    if (user.password != oldPassword) return false;

    final updated = user.copyWith(password: newPassword);
    await updateUser(updated);
    return true;
  }

  // ========================= TASK OPERATIONS =========================

  /// Insert task baru
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(
      AppConstants.TABLE_TASKS,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Ambil task berdasarkan id
  Future<Task?> getTaskById(int id) async {
    final db = await database;
    final result = await db.query(
      AppConstants.TABLE_TASKS,
      where: '${AppConstants.COL_TASK_ID} = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Task.fromMap(result.first);
    }
    return null;
  }

  /// Ambil semua tasks
  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final result = await db.query(
      AppConstants.TABLE_TASKS,
      orderBy: '${AppConstants.COL_TASK_DUE_DATE} ASC',
    );
    return result.map((map) => Task.fromMap(map)).toList();
  }

  /// Ambil tasks berdasarkan kategori
  Future<List<Task>> getTasksByCategory(String category) async {
    final db = await database;
    final result = await db.query(
      AppConstants.TABLE_TASKS,
      where: '${AppConstants.COL_TASK_CATEGORY} = ?',
      whereArgs: [category],
      orderBy: '${AppConstants.COL_TASK_DUE_DATE} ASC',
    );
    return result.map((map) => Task.fromMap(map)).toList();
  }

  /// Hitung tasks selesai
  Future<int> countCompletedTasks() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${AppConstants.TABLE_TASKS} '
      'WHERE ${AppConstants.COL_TASK_IS_DONE} = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Hitung tasks belum selesai
  Future<int> countIncompleteTasks() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${AppConstants.TABLE_TASKS} '
      'WHERE ${AppConstants.COL_TASK_IS_DONE} = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Update task
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      AppConstants.TABLE_TASKS,
      task.toMap(),
      where: '${AppConstants.COL_TASK_ID} = ?',
      whereArgs: [task.id],
    );
  }

  /// Tandai task selesai
  Future<int> completeTask(int taskId, String completedDate) async {
    final db = await database;
    return await db.update(
      AppConstants.TABLE_TASKS,
      {
        AppConstants.COL_TASK_IS_DONE: 1,
        AppConstants.COL_TASK_COMPLETED_AT: completedDate,
      },
      where: '${AppConstants.COL_TASK_ID} = ?',
      whereArgs: [taskId],
    );
  }

  /// Tandai task belum selesai
  Future<int> incompleteTask(int taskId) async {
    final db = await database;
    return await db.update(
      AppConstants.TABLE_TASKS,
      {
        AppConstants.COL_TASK_IS_DONE: 0,
        AppConstants.COL_TASK_COMPLETED_AT: null,
      },
      where: '${AppConstants.COL_TASK_ID} = ?',
      whereArgs: [taskId],
    );
  }

  /// Hapus task
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      AppConstants.TABLE_TASKS,
      where: '${AppConstants.COL_TASK_ID} = ?',
      whereArgs: [id],
    );
  }

  /// Hapus semua tasks
  Future<int> deleteAllTasks() async {
    final db = await database;
    return await db.delete(AppConstants.TABLE_TASKS);
  }

  /// Get tasks completed per date (untuk grafik)
  Future<Map<String, int>> getCompletedTasksPerDate() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT ${AppConstants.COL_TASK_COMPLETED_AT}, COUNT(*) as count
      FROM ${AppConstants.TABLE_TASKS}
      WHERE ${AppConstants.COL_TASK_IS_DONE} = 1 
        AND ${AppConstants.COL_TASK_COMPLETED_AT} IS NOT NULL
      GROUP BY ${AppConstants.COL_TASK_COMPLETED_AT}
      ORDER BY ${AppConstants.COL_TASK_COMPLETED_AT} ASC
    ''');

    final Map<String, int> taskCounts = {};
    for (var row in result) {
      final date = row['completed_at'] as String?;
      final count = (row['count'] as int?) ?? 0;
      if (date != null) {
        taskCounts[date] = count;
      }
    }
    return taskCounts;
  }

  /// Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
