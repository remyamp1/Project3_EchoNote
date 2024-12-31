
import 'package:echo_note/Appwrite_Model.dart';
import 'package:echo_note/Appwrite_service.dart';
import 'package:echo_note/List_Screen.dart';
import 'package:flutter/material.dart';


class ListExample extends StatefulWidget {
  @override
  State<ListExample> createState() => _ListExampleState();
}

class _ListExampleState extends State<ListExample> {
  late AppwriteService _appwriteService;

  TextEditingController titleController = TextEditingController();
  TextEditingController addlistContoller = TextEditingController();

  late List<String> add = [];

  void newList() {
    setState(() {
      if (addlistContoller.text.isNotEmpty) {
        add.add(addlistContoller.text);
        addlistContoller.clear();
      }
    });
  }

  List<Lisst> convertAddToLisst() {
    List<Lisst> newLisstItems = [];
    for (var item in add) {
      newLisstItems.add(Lisst(Title: item, id: 'id', addlist: [item]));
    }
    return newLisstItems;
  }

  void _removeAdd(int index) {
    setState(() {
      add.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    _loadLissts();
    // Ensure this is called to load the data when the screen initializes
  }

  Future<void> _loadLissts() async {
    try {
      setState(() {
      });
    } catch (e) {
      print('Error loading lists: $e');
    }
  }

  // Other methods...

  Future<void> _addLisst() async {
    final Title = titleController.text;
    final addlist = add;

    if (Title.isNotEmpty && addlist.isNotEmpty) {
      try {
        List<Lisst> newLisstItems = convertAddToLisst();

        // ignore: unused_local_variable
        for (var lisstItem in newLisstItems) {
          await _appwriteService.addLisst(Title, addlist);
        }
        titleController.clear();
        addlistContoller.clear();
        setState(() {
          add.clear();
        });
        await _loadLissts();
      } catch (e) {
        print('Error adding task:$e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Add New List",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Listscreen()));
              },
              icon: IconButton(
                onPressed: _addLisst,
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          SizedBox(height: 10),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text(
                  "Title",
                  style: TextStyle(color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green))),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: TextField(
              controller: addlistContoller,
              decoration: InputDecoration(
                suffixIcon:
                    IconButton(onPressed: newList, icon: Icon(Icons.add)),
                border: OutlineInputBorder(),
                label: Text(
                  "Add to list",
                  style: TextStyle(color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: add.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(add[index]),
                              Spacer(),
                              GestureDetector(
                                  onTap: () {
                                    _removeAdd(index);
                                  },
                                  child: Icon(Icons.cancel)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }))
        ]),
      ),
    );
  }
}
