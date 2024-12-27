
import 'package:echo_note/Appwrite_Model.dart';
import 'package:echo_note/Appwrite_service.dart';
import 'package:flutter/material.dart';


class EditText extends StatefulWidget {
  final String id;
  final String Title;
  final String Content;
  
  const EditText({
    super.key,
    required this.id,
    required this.Title,
    required this.Content,
  });

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  late AppwriteService _appwriteService;
  late List<Texts> _text;
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController contentcontroller = TextEditingController();

 // final DateTime dateTime = DateTime.now();
 



   

    @override
    void initState(){
      super.initState();
      _appwriteService =AppwriteService();
      titlecontroller.text=widget.Title;
      contentcontroller.text=widget.Content;
    }

    Future<void> _updateText()async{
      final updatedTitle=titlecontroller.text;
      final updatedContent=contentcontroller.text;
      if(updatedTitle.isNotEmpty && updatedContent.isNotEmpty){
        try {
        final updatedText = await _appwriteService.updateText(
  widget.id,
  updatedTitle,
  updatedContent,
);
          
      Navigator.pop(context, Texts.fromDocument(updatedText));
        } catch (e) {
          print("Error updated text:$e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("falied  to updata document")));
        }
      }
    }
  

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
          IconButton(
              onPressed: _updateText,
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
          ],
        ),
      ),
    );
  }
}