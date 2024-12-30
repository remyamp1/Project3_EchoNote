import 'package:echo_note/Appwrite_Model.dart';
import 'package:echo_note/Appwrite_service.dart';
import 'package:echo_note/Edit_List.dart';
import 'package:flutter/material.dart';


class ListScreen extends StatefulWidget {
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late AppwriteService _appwriteService;
  late List<Addlists> _lists;
 // Addlists updateList=Addlists(id: '', Title: '', addlist:[]);
  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    _lists = [];
    _loadLissts();
    // Ensure this is called to load the data when the screen initializes
  }

  Future<void> _loadLissts() async {
    try {
      final lists = await _appwriteService.getLists();
      setState(() {
        _lists = lists.map((e) => Addlists.fromDocument(e)).toList();
      });
    } catch (e) {
      print('Error loading lists: $e');
    }
  }

  void _navigateToEditLisst(BuildContext context, Addlists list) async {
    final updatedList = await Navigator.push(
        context,
      MaterialPageRoute(
            builder: (context) => EditNote(
                  id: list.id,
                  Title: list.Title,
                  addlist: list.addlist,
                ))); 

    if (updatedList != null) {
      setState(() {
        final index = _lists.indexWhere((t) => t.id == updatedList.id);
        if (index != -1) {
          _lists[index] = updatedList;
        }
      });
      _loadLissts();
    }
  }




Future<void> _deleteLists(String listId) async {
  try {
    await _appwriteService.deleteLists(listId);
    _loadLissts();
   setState(() {
      _lists.removeWhere((list) => list.id == listId);
    });
  } catch (e) {
    print('Error deleting list: $e');
  }
}


/* void _confirmDelete(String lisstId) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirm Delete'),
      content: Text('Are you sure you want to delete this item?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            _deleteLisst(lisstId);  // Perform deletion
          },
          child: Text('Delete'),
        ),
      ],
    ),
  );
} */


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: /*_lists.isEmpty
          ? Center(child: Text("no data"))
          :*/ Column(
            children: [
              Expanded(
                child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 7,
                          crossAxisSpacing: 7),
                      itemCount: _lists.length,
                      itemBuilder: (context, index) {
                        final list = _lists[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: ()=> _navigateToEditLisst(context,list),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color.fromARGB(255, 140, 120, 248)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(list.Title,
                                            style: TextStyle(color: Colors.white)),
                                        Spacer(),
                                        PopupMenuButton<String>(
                                            onSelected: (value) {
                                              if (value == 'Edit') {
                                                _navigateToEditLisst(context, list);
                                              } else if (value == 'Delete') {
                                                _deleteLists(list.id);
                                              }
                                            },
                                            itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                      value: "Edit",
                                                      child: Text("Edit")),
                                                  PopupMenuItem(
                                                      value: 'Delete',
                                                      child: Text('delete')),
                                                ]),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    
                                    ...list.addlist
                                        .map((item) => Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 2.0),
                                              child: Text(item,
                                                  style:
                                                      TextStyle(color: Colors.white)),
                                            ))
                                        .toList(),
                                  ],
                                ),
                              ),
                              
                            
                            ),
                            
                          ),
                        );
                      }),
              ),
            ],
          ),
      ),
    );
  }
}