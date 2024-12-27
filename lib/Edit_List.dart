import 'package:flutter/material.dart';
class EditNote extends StatefulWidget {
  final String id;
  final String Title;
  final List<String> addlist;
  const EditNote({required this.id,required this.Title,required this.addlist});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
   TextEditingController titlecontroller = TextEditingController();
  TextEditingController addlistcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            "Edit Note",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.check,color: Colors.white,))
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
                controller: addlistcontroller,
                decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(),
                    label: Text(
                      "Add to list",
                      style: TextStyle(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
              ),
          ],
        ),
      ),
    );
  }
}