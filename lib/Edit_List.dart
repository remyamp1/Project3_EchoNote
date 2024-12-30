
import 'package:echo_note/Appwrite_Model.dart';
import 'package:echo_note/Appwrite_service.dart';
import 'package:flutter/material.dart';
class EditNote extends StatefulWidget {
  final String id;
  final String Title;
  final List<String> addlist;
  const EditNote({
    required this.id,required this.Title,required this.addlist
    });

 /* factory EditNote.fromDocument(Document document){
    return EditNote(id: document.$id,
     Title: document.data['Title'] as String,
      addlist:List<String>.from(document.data['addlist'] ?? []));
  } */

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
 late AppwriteService _appwriteService;
//late TextEditingController titleController;
  //late TextEditingController addlistContoller;
  // late List<String> addlistitem;
    late List<Addlists> _lists;
   TextEditingController titlecontroller = TextEditingController();
  TextEditingController addlistcontroller = TextEditingController();
  
  List<String> get addlist => [];

  
 
 @override
 void initState() {
  super.initState();
  _appwriteService = AppwriteService();
  titlecontroller.text=widget.Title;
  addlistcontroller.text=widget.Title;
 /// titleController = TextEditingController(text: widget.Title);
 // addlistContoller = TextEditingController();
 // addlistitem = List.from(widget.addlist); // No need for split
}
    
   // _appwriteService = AppwriteService();
  

/*  titlecontroller.text=widget.Title;
  addlistcontroller.text=widget.Title; */
  

  /*@override
    void dispose() {
    titleController.dispose();
    for (var controller in addlistContoller) {
      controller.dispose();
    }
    super.dispose();
  } */

 Future<void> _updateList()async{
final updatedTitle=titlecontroller.text;
final updatedaddlist=addlistcontroller.text;
if(updatedTitle.isNotEmpty && updatedaddlist.isNotEmpty){
        try {
     final updatedList=  await _appwriteService.updateList(
  widget.id,
  updatedTitle,
  updatedaddlist as List<String>,
);
          
      Navigator.pop(context,Addlists.fromDocument(updatedList));
        } catch (e) {
          print("Error updated list:$e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("falied  to updata document")));
        }
      }
    
 }
    

 Future <void> _addLists()async {
  final Title=titlecontroller.text;
  final addlists=addlistcontroller.text;
    if (Title.isNotEmpty && addlists.isNotEmpty){
   try {
     await _appwriteService.addLists(Title, addlist);
     titlecontroller.clear();
     addlistcontroller.clear();
   } catch (e) {
     print("error adding list:$e");
   }
    }
  }

 /* void _removeListItem(int index) {
    setState(() {
      addlistitem.removeAt(index);
    });
  }*/

/*  Future<void> _addlists() async {
    final Title = titlecontroller.text;
    final addlist= addlistcontroller.text;


    if (Title.isNotEmpty && addlist.isNotEmpty) {
      try {
         final addlistAsList = [addlist];
        await _appwriteService.addLists(Title, addlistAsList,);
        titlecontroller.clear();
        addlistcontroller.clear();
      } catch (e) {
        print("Error adding task:$e");
      }
    }
  } */

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
            IconButton(onPressed: _updateList,
            
             icon: Icon(Icons.check,color: Colors.white,))
            ],
        ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
        SizedBox(height: 10),
              TextField(
                controller:titlecontroller,
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
                   // onPressed: _addNewListItem,
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(),
                    label: Text(
                     "Add to List",
                      style: TextStyle(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
              )

         /*     SizedBox(height: 10),
              Expanded(child: 
              ListView.builder(
                itemCount: addlistitem.length,
                itemBuilder: (context,index){
                return ListTile(
                  title: Text(addlistitem[index]),
                  trailing: IconButton(onPressed: ()=> _removeListItem(index),
                   icon: Icon(Icons.delete)),
                );

              })), */
  
          ],
        ),
      ),
    );
  }
}