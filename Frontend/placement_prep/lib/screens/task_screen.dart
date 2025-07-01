import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tasks.dart';

class DailyTaskScreen extends StatefulWidget {
  @override
  _DailyTaskScreenState createState() => _DailyTaskScreenState();
}

class _DailyTaskScreenState extends State<DailyTaskScreen> with TickerProviderStateMixin {
  List<Task> tasks = [];
  final TextEditingController _taskController = TextEditingController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
 String? _token;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _loadTokenAndFetchTasks();
  }

  Future<void> _loadTokenAndFetchTasks() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');

    if (_token != null) {
      await _fetchTasks();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token not found!')),
      );
    }
  }

  Future<void> _markTaskDone(Task t) async {
  try {
    DateTime now = DateTime.now();
    String date = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final url = Uri.parse('http://192.168.29.61:3000/candidate/task/mark-done');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'token': _token!,
      },
      body: jsonEncode({
        'id': t.id,
        'date': date,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Task marked as done')),
      );
      await _fetchTasks();
    } else {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Failed to mark task done')),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error marking task done: $error')),
    );
  }
}

Future<void> _markTaskUndone(Task t) async {
  try {
    DateTime now = DateTime.now();
    String date = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final url = Uri.parse('http://192.168.29.61:3000/candidate/task/mark-undone');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'token': _token!,
      },
      body: jsonEncode({
        'id': t.id,
        'date': date,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Task marked as undone')),
      );
      await _fetchTasks();
    } else {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Failed to mark task as undone')),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error marking task as undone: $error')),
    );
  }
}

  @override
  void dispose() {
    _pulseController.dispose();
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _fetchTasks() async {
    try {
         DateTime now = DateTime.now();
    String date = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      final url = Uri.parse('http://192.168.29.61:3000/candidate/task/get')
      .replace(queryParameters: {
        'date': date,
      });
      final response = await http.get(url,headers: {
        'Content-Type': 'application/json',
        'token': _token!,
      },);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> taskList = jsonData['tasks'];

        setState(() {
          tasks = taskList.map((taskJson) => Task.fromJson(taskJson)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch tasks')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching tasks: $error')),
      );
    }
  }

  Future<void> _addTask(String title) async {
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task title cannot be empty')),
      );
      return;
    }

    try {
      DateTime now = DateTime.now();
      String date = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final url = Uri.parse('http://192.168.29.61:3000/candidate/task/add');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json','token': _token!,},
        body: jsonEncode({
          'title': title,
          'date': date,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Task added successfully')),
        );
        _taskController.clear();
        await _fetchTasks();
      } else {
        final message = jsonDecode(response.body)['message'] ?? 'Failed to add task';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding task: $error')),
      );
    }
  }

  int get completedCount => tasks.where((task) => task.completed).length;
  double get progressPercentage => tasks.isEmpty ? 0 : (completedCount / tasks.length) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF581C87),
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: SizedBox.expand(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 24),
                  _buildStatsGrid(),
                  SizedBox(height: 24),
                  _buildQuickAdd(),
                  SizedBox(height: 24),
                  _buildTasksList(),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.track_changes, color: Colors.white, size: 24),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Daily Focus",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Today's Tasks",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.more_vert, color: Colors.white, size: 20),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard("Completed", "$completedCount/${tasks.length}", Icons.check, [Colors.green, Colors.teal])),
            SizedBox(width: 16),
            Expanded(child: _buildStatCard("Progress", "${progressPercentage.round()}%", Icons.emoji_events, [Colors.blue, Colors.purple])),
          ],
        ),
        SizedBox(height: 16),
        LinearProgressIndicator(
          value: tasks.isEmpty ? 0 : completedCount / tasks.length,
          backgroundColor: Colors.white.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, List<Color> colors) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAdd() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _taskController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Add a new task...",
              ),
              onSubmitted: (value) => _addTask(value.trim()),
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () => _addTask(_taskController.text.trim()),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink, Colors.purple],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.add, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: tasks.map((task) => _buildTaskItem(task)).toList(),
      ),
    );
  }
Widget _buildTaskItem(Task task) {
  return GestureDetector(
    onTap:() { if (task.completed) {
      _markTaskUndone(task);
    } else {
      _markTaskDone(task);
    }
  },
    child: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: task.completed ? Colors.green : Colors.white.withOpacity(0.3),
                width: 2,
              ),
              color: task.completed ? Colors.green : Colors.transparent,
            ),
            child: task.completed
                ? Icon(Icons.check, color: Colors.white, size: 12)
                : null,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                color: task.completed ? Colors.white.withOpacity(0.6) : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                decoration: task.completed ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: FloatingActionButton(
            onPressed: () {
              // Optionally open a dialog to add task
            },
            backgroundColor: Colors.pink,
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}

