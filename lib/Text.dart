
import 'package:echo_note/Appwrite_Model.dart';
import 'package:echo_note/Appwrite_service.dart';
import 'package:echo_note/Text_Screen.dart';
import 'package:flutter/material.dart';


class TextExample extends StatefulWidget {
  const TextExample({super.key});

  @override
  State<TextExample> createState() => _TextExampleState();
}

class _TextExampleState extends State<TextExample> {
  late AppwriteService _appwriteService;
  late List<Texts> _text;
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController contentcontroller = TextEditingController();

  final DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    _text = [];
  }

  Future<void> _loadtext() async {
    try {
      final tasks = await _appwriteService.getTasks();
      setState(() {
        _text = tasks.map((e) => Texts.fromDocument(e)).toList();
      });
    } catch (e) {
      print("Title is empty");
    }
  }

  Future<void> _addtext() async {
    final Title = titlecontroller.text;
    final Description = contentcontroller.text;

    String date = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    String time = "${dateTime.hour}/${dateTime.minute}";

    if (Title.isNotEmpty && Description.isNotEmpty) {
      try {
        await _appwriteService.addText(Title, Description, date, time);
        titlecontroller.clear();
        contentcontroller.clear();

        _loadtext();
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
            "Add New Note",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TextScreen()));
              },
              child: IconButton(
                  onPressed: _addtext,
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  )),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
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
              controller: contentcontroller,
              maxLines: 20,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(
                    "Content",
                    style: TextStyle(color: Colors.green),
                  ),
                  alignLabelWithHint: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green))),
            )
          ]),
        ));
  }
}