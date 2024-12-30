import 'package:flutter/material.dart';
import 'package:echo_note/Appwrite_service.dart';
import 'package:echo_note/Appwrite_Model.dart';
import 'package:echo_note/Edit_List.dart';

class ListScreen extends StatefulWidget {
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late AppwriteService _appwriteService;
  List<Addlists> _lists = [];

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    _loadLists();
  }

  Future<void> _loadLists() async {
    try {
      final lists = await _appwriteService.getLists();
      setState(() {
        _lists = lists.map((e) => Addlists.fromDocument(e)).toList();
      });
    } catch (e) {
      print('Error loading lists: $e');
    }
  }

  Future<void> _deleteList(String listId) async {
    try {
      await _appwriteService.deleteLists(listId);
      setState(() {
        _lists.removeWhere((list) => list.id == listId);
      });
    } catch (e) {
      print('Error deleting list: $e');
    }
  }

  void _navigateToEditList(BuildContext context, Addlists list) async {
    final updatedList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNote(
          id: list.id,
          Title: list.Title,
          addlist: list.addlist,
        ),
      ),
    );

    if (updatedList != null) {
      setState(() {
        final index = _lists.indexWhere((t) => t.id == updatedList.id);
        if (index != -1) {
          _lists[index] = updatedList;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: _lists.isEmpty
            ? Center(child: Text("No data available"))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 7,
                  crossAxisSpacing: 7,
                ),
                itemCount: _lists.length,
                itemBuilder: (context, index) {
                  final list = _lists[index];
                  return GestureDetector(
                    onTap: () => _navigateToEditList(context, list),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromARGB(255, 140, 120, 248),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(list.Title, style: TextStyle(color: Colors.white)),
                                Spacer(),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'Edit') {
                                      _navigateToEditList(context, list);
                                    } else if (value == 'Delete') {
                                      _deleteList(list.id);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(value: 'Edit', child: Text('Edit')),
                                    PopupMenuItem(value: 'Delete', child: Text('Delete')),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            ...list.addlist.map((item) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Text(item, style: TextStyle(color: Colors.white)),
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
