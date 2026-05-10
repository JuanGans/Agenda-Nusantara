class Task {
  final int? id;
  final String title;
  final String description;
  final String dueDate; // Format: YYYY-MM-DD
  final String category; // 'penting' atau 'biasa'
  final int isDone; // 0 = belum, 1 = selesai
  final String? completedAt; // Format: YYYY-MM-DD, nullable

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.category,
    this.isDone = 0,
    this.completedAt,
  });

  /// Konversi dari Map (hasil query database)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: map['due_date'] ?? '',
      category: map['category'] ?? 'biasa',
      isDone: map['is_done'] ?? 0,
      completedAt: map['completed_at'],
    );
  }

  /// Konversi ke Map (untuk insert/update ke database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'category': category,
      'is_done': isDone,
      'completed_at': completedAt,
    };
  }

  /// Salin dengan beberapa field yang diubah
  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? dueDate,
    String? category,
    int? isDone,
    String? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      isDone: isDone ?? this.isDone,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Convenience method untuk menandai task selesai
  Task markAsComplete(String completedDate) {
    return copyWith(isDone: 1, completedAt: completedDate);
  }

  /// Convenience method untuk menandai task belum selesai
  Task markAsIncomplete() {
    return copyWith(isDone: 0, completedAt: null);
  }

  @override
  String toString() =>
      'Task(id: $id, title: $title, category: $category, isDone: $isDone)';
}
