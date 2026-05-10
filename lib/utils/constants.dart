// Constants untuk aplikasi Agenda Nusantara
class AppConstants {
  // Database constants
  static const String DB_NAME = 'agenda_nusantara.db';
  static const int DB_VERSION = 1;
  static const String TABLE_USERS = 'users';
  static const String TABLE_TASKS = 'tasks';

  // User table columns
  static const String COL_USER_ID = 'id';
  static const String COL_USER_USERNAME = 'username';
  static const String COL_USER_PASSWORD = 'password';

  // Task table columns
  static const String COL_TASK_ID = 'id';
  static const String COL_TASK_TITLE = 'title';
  static const String COL_TASK_DESCRIPTION = 'description';
  static const String COL_TASK_DUE_DATE = 'due_date';
  static const String COL_TASK_CATEGORY = 'category';
  static const String COL_TASK_IS_DONE = 'is_done';
  static const String COL_TASK_COMPLETED_AT = 'completed_at';

  // Category constants
  static const String CATEGORY_PENTING = 'penting';
  static const String CATEGORY_BIASA = 'biasa';

  // Default credentials
  static const String DEFAULT_USERNAME = 'user';
  static const String DEFAULT_PASSWORD = 'user';

  // Route names
  static const String ROUTE_LOGIN = '/login';
  static const String ROUTE_HOME = '/home';
  static const String ROUTE_TAMBAH_PENTING = '/tambah-penting';
  static const String ROUTE_TAMBAH_BIASA = '/tambah-biasa';
  static const String ROUTE_DAFTAR = '/daftar';
  static const String ROUTE_SETTINGS = '/settings';

  // Colors
  static const int COLOR_PENTING = 0xFFE74C3C; // Red
  static const int COLOR_BIASA = 0xFF27AE60;  // Green
  static const int COLOR_PRIMARY = 0xFF2BA08D; // Teal
}
