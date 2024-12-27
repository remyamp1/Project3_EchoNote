
import 'package:echo_note/Appwrite_Model.dart';
import 'package:echo_note/Appwrite_service.dart';
import 'package:echo_note/Edit_Task.dart';
import 'package:flutter/material.dart';


class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late AppwriteService _appwriteService;
  late List<Task> _task;

  final DateTime dateTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    _task = [];
    _loadtask();
  }

  Future<void> _loadtask() async {
    try {
      final tasks = await _appwriteService.getTasks();
      setState(() {
        _task = tasks.map((e) => Task.fromDocument(e)).toList();
      });
    } catch (e) {
      print("Title is empty");
    }
  }

  Future<void> _deleteLists(String taskId) async {
    try {
      await _appwriteService.deleteLists(taskId);
      _loadtask();
    } catch (e) {
      print("Error  deleting task:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 7),
                  itemCount: _task.length,
                  itemBuilder: (context, index) {
                    final tasks = _task[index];
                    return Container(
                      height: 30,
                      width: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(255, 250, 234, 87)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(tasks.Title),
                              ],
                            ),
                            Text(tasks.Description),
                            Text(tasks.Date),
                            Text(tasks.Time),
                            Row(
                              children: [
                                Text("Task ended"),
                                Spacer(),
                                PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'Edit') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EditTask(
                                                      id: tasks.id,
                                                      Title: tasks.Title,
                                                      Description:
                                                          tasks.Description,
                                                    )));
                                      } else if (value == 'Delete') {
                                        _deleteLists(tasks.id);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                          PopupMenuItem(
                                              value: 'Edit',
                                              child: Text("Edit")),
                                          PopupMenuItem(
                                              value: 'Delete',
                                              child: Text("Delete")),
                                        ])
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}