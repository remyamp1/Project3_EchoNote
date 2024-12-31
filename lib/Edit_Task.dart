
import 'package:echo_note/Appwrite_Model.dart';
import 'package:echo_note/Appwrite_service.dart';
import 'package:flutter/material.dart';


class EditTask extends StatefulWidget {
  final String id;
  final String Title;
  final String Description;

  const EditTask({
    super.key,
    required this.id,
    required this.Title,
    required this.Description,
  });
  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late AppwriteService _appwriteService;
  late List<Task> _task;

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  final DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
  //  _task = [];

  titlecontroller.text=widget.Title;
  descriptioncontroller.text=widget.Description;
  }

 Future<void> _updateTask()async{
      final updatedTitle=titlecontroller.text;
      final updatedDescription=descriptioncontroller.text;
      if(updatedTitle.isNotEmpty && updatedDescription.isNotEmpty){
        try {
        final updatedTask = await _appwriteService.updateTask(
  widget.id,
  updatedTitle,
  updatedDescription,
);
          
      Navigator.pop(context, Texts.fromDocument(updatedTask));
        } catch (e) {
          print("Error updated text:$e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("falied  to updata document")));
        }
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
          "Edit Task",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: _updateTask,
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ))
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
            SizedBox(height: 15),
            TextField(
              controller: descriptioncontroller,
              maxLines: 15,
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
              height: 15,
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
      ),
    );
  }
}