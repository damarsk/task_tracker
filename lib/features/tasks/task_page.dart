import 'package:material_ui/material_ui.dart';

import '../../models/todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _controller = TextEditingController();

  final List<Todo> _tasks = [
    Todo(id: 1, title: 'Belajar Alpro'),
    Todo(id: 2, title: 'Ngerjain Tugas di LMS'),
    Todo(id: 3, title: 'Persiapan UAS'),
  ];

  int get _completedCount => _tasks.where((task) => task.isCompleted).length;

  void _addTask() {
    final title = _controller.text.trim();

    if (title.isEmpty) return;

    setState(() {
      _tasks.add(Todo(id: DateTime.now().microsecondsSinceEpoch, title: title));
      _controller.clear();
    });
  }

  void _toggleTask(int id, bool value) {
    setState(() {
      final index = _tasks.indexWhere((task) => task.id == id);

      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(isCompleted: value);
      }
    });
  }

  void _deleteTask(int id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _tasks.length;
    final progress = total == 0 ? 0.0 : _completedCount / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your progress',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(value: progress),
                    const SizedBox(height: 12),
                    Text('$_completedCount of $total tasks completed'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Tasks', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(child: Text('No tasks yet. Add one!'))
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];

                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: task.isCompleted,
                              onChanged: (value) {
                                _toggleTask(task.id, value ?? false);
                              },
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: task.isCompleted ? Colors.grey : null,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red,
                              onPressed: () => _deleteTask(task.id),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a task...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add),
                  iconSize: 28,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
