import 'package:echo_note/Appwrite_service.dart';
import 'package:flutter/material.dart';

class Editlist extends StatefulWidget {
  final String id;
  final String Title;
  final List<dynamic> addlist;

  Editlist({required this.id, required this.Title, required this.addlist});

  @override
  _EditlistState createState() => _EditlistState();
}

class _EditlistState extends State<Editlist> {
  late AppwriteService _appwriteService;
  late TextEditingController titleController;
  TextEditingController addlistController = TextEditingController();
  late List<String> addlistItems;
  int? _editingIndex;
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    titleController = TextEditingController(text: widget.Title);
    _editController = TextEditingController();
    addlistItems = List<String>.from(widget.addlist);

    //  addlistController = TextEditingController(text: widget.addlist);
    //  addlistItems = widget.addlist
    //    .split(','); // Splitting the addlist string into a list of items
  }

  @override
  void dispose() {
    titleController.dispose();
    addlistController.dispose();
    _editController.dispose();
    super.dispose();
  }

  Future<void> _updateList() async {
    try {
      await _appwriteService.updateLisst(
        widget.id,
        titleController.text,
        addlistItems,
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error updating list: $e');
    }
  }

  void _addItemToAddlist() {
    if (addlistController.text.isNotEmpty) {
      setState(() {
        addlistItems.add(addlistController.text);
        addlistController.clear();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      addlistItems.removeAt(index);
    });
  }

  void _startEditing(int index) {
    setState(() {
      _editingIndex = index;
      _editController.text = addlistItems[index];
    });
  }

  void _stopEditing() {
    setState(() {
      if (_editingIndex != null) {
        addlistItems[_editingIndex!] = _editController.text;
        _editingIndex = null;
        _editController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Edit List'),
        actions: [
          IconButton(
              onPressed: _updateList,
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
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'List Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: addlistController,
              decoration: InputDecoration(
                labelText: 'Add List Item',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addItemToAddlist,
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: addlistItems.length,
                itemBuilder: (context, index) {
                  return _editingIndex == index
                      ? ListTile(
                          title: TextField(
                            controller: _editController,
                            onSubmitted: (_) => _stopEditing(),
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                          ),
                          trailing: IconButton(
                              onPressed: _stopEditing,
                              icon: Icon(
                                Icons.check,
                                color: Colors.green,
                              )),
                        )
                      : ListTile(
                          title: Text(addlistItems[index]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () => _startEditing(index),
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.red,
                                  )),
                              IconButton(
                                  onPressed: () => _removeItem(index),
                                  icon: Icon(
                                    Icons.cancel,
                                  )),
                            ],
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}