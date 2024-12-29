
import 'package:echo_note/Appwrite_Model.dart';
import 'package:echo_note/Appwrite_service.dart';
import 'package:echo_note/Edit_Text.dart';
import 'package:flutter/material.dart';


class TextScreen extends StatefulWidget {
  const TextScreen({super.key});

  @override
  State<TextScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TextScreen> {
  //  TextEditingController titlecontroller = TextEditingController();
 // TextEditingController contentcontroller = TextEditingController();

  late AppwriteService _appwriteService;
  late List<Texts> _text;

//  final DateTime dateTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    _text = [];
    _loadtext();
  }

  Future<void> _loadtext() async {
    try {
      final texts = await _appwriteService.getTexts();
      setState(() {
        _text = texts.map((e) => Texts.fromDocument(e)).toList();
      });
    } catch (e) {
      print("Title is empty");
      
    }
  }

  void _navigateToEditText(BuildContext context, Texts texts)async{
    final updatedText=await Navigator.push(context, MaterialPageRoute(
      builder: (context)=>EditText(id: texts.id,
       Title:texts.Title, 
       Content: texts.Content)));


      if(updatedText !=null){
        setState(() {
          final index=_text.indexWhere((text)=>text.id==updatedText.id);

          if(index != -1){
            _text[index]=updatedText;
          }
        });

        _loadtext();
      }
  }
  Future<void> _deletetext(String textId)async{
    try {
     await _appwriteService.deleteText(textId);
     _loadtext();
    } catch (e) {
      print("error deleting text:$e");
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
                  itemCount: _text.length,
                  itemBuilder: (context, index) {
                    final texts = _text[index];
                    return Container(
                      height: 30,
                      width: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(255, 231, 162, 243)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(texts.Title),
                                Spacer(),
                                PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'Edit') {
                                        _navigateToEditText(context, texts);
                                      } else if (value == 'Delete') {

                                        _deletetext(texts.id);
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
                            ),
                            Text(texts.Content),
                          //  Text(texts.Date),
                            //Text(texts.Time),
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