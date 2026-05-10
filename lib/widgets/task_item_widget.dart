import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';

/// Widget untuk menampilkan satu item task dalam list
class TaskItemWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  const TaskItemWidget({
    super.key,
    required this.task,
    required this.onTap,
    this.onLongPress,
    this.isSelected = false,
  });

  Color _getArrowColor() {
    if (task.category == AppConstants.CATEGORY_PENTING) {
      return const Color(AppConstants.COLOR_PENTING);
    } else {
      return const Color(AppConstants.COLOR_BIASA);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[200] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.grey : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Checkbox(
          value: task.isDone == 1,
          onChanged: (_) => onTap(),
          activeColor: _getArrowColor(),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: task.isDone == 1 ? Colors.grey : Colors.black87,
            decoration:
                task.isDone == 1 ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          '${task.dueDate} · ${task.category}',
          style: TextStyle(
            fontSize: 12,
            color: task.isDone == 1 ? Colors.grey : Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: _getArrowColor(),
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
