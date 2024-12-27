
import 'package:echo_note/Appwrite_Model.dart';
import 'package:echo_note/Appwrite_service.dart';
import 'package:echo_note/Task_Screen.dart';
import 'package:flutter/material.dart';


class TaskExample extends StatefulWidget {
  const TaskExample({super.key});

  @override
  State<TaskExample> createState() => _TaskExampleState();
}

class _TaskExampleState extends State<TaskExample> {
  late AppwriteService _appwriteService;
  late List<Task> _task;
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  final DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    _task = [];
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

  Future<void> _addtask() async {
    final Title = titlecontroller.text;
    final Description = descriptioncontroller.text;

    String date = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
    String time = "${dateTime.hour}:${dateTime.minute}";

    if (Title.isNotEmpty && Description.isNotEmpty) {
      try {
        await _appwriteService.addTask(Title, Description, date, time);
        titlecontroller.clear();
        descriptioncontroller.clear();

        _loadtask();
      } catch (e) {
        print("Error adding task:$e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            "Add New Task",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TaskScreen()));
              },
              child: IconButton(
                  onPressed: _addtask,
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  )),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              TextField(
                controller: titlecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text(
                      "Title",
                      style: TextStyle(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
              ),
              SizedBox(height: 20),
              TextField(
                controller: descriptioncontroller,
                maxLines: 20,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text(
                      "Description",
                      style: TextStyle(color: Colors.green),
                    ),
                    alignLabelWithHint: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Text(
                    "${dateTime.day.toString()}-${dateTime.month.toString()}-${dateTime.year.toString()}",
                    style: TextStyle(color: Colors.green),
                  ),
                  Spacer(),
                  Text("${dateTime.hour.toString()}:${dateTime.minute}",
                      style: TextStyle(color: Colors.green))
                ],
              ),
            ],
          ),
        ));
  }
}