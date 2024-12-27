

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
      final lissts = await _appwriteService.getLists();
      setState(() {
        _lists = lissts.map((e) => Addlists.fromDocument(e)).toList();
      });
    } catch (e) {
      print('Error loading lists: $e');
    }
  }

  void _navigateToEditLisst(BuildContext context, Addlists lisst) async {
    final updatedLisst = await Navigator.push(
        context,
      MaterialPageRoute(
            builder: (context) => EditNote(
                  id: lisst.id,
                  Title: lisst.Title,
                  addlist: lisst.addlist,
                ))); 

    if (updatedLisst != null) {
      setState(() {
        final index = _lists.indexWhere((t) => t.id == updatedLisst.id);
        if (index != -1) {
          _lists[index] = updatedLisst;
        }
      });
    }
  }

  Future<void> _deleteLisst(String lisstId) async {
    try {
      await _appwriteService.deleteTask(lisstId);
      _loadLissts();
    } catch (e) {
      print('Error deleting list:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: /*_lissts.isEmpty
          ? Center(child: Text("no data"))
          :*/
            Column(
          children: [
            Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 7,
                      crossAxisSpacing: 7),
                  itemCount: _lists.length,
                  itemBuilder: (context, index) {
                    final lisst = _lists[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                  Text(lisst.Title,
                                      style: TextStyle(color: Colors.white)),
                                  Spacer(),
                                  PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'Edit') {
                                          _navigateToEditLisst(context, lisst);
                                        } else if (value == 'Delete') {
                                          _deleteLisst(lisst.id);
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
                              
                              ...lisst.addlist
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
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}