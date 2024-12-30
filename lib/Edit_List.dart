
import 'package:echo_note/Appwrite_Model.dart';
import 'package:echo_note/Appwrite_service.dart';
import 'package:flutter/material.dart';


class EditNote extends StatefulWidget {
  final String id;
  final String Title;
  final List<String> addlist;

  const EditNote({
    required this.id,
    required this.Title,
    required this.addlist,
  });

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late AppwriteService _appwriteService;
  late TextEditingController titleController;
  late TextEditingController addlistController;
  List<String> addlistItems = [];

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    titleController = TextEditingController(text: widget.Title);
    addlistController = TextEditingController();
    addlistItems = List.from(widget.addlist);
  }

  @override
  void dispose() {
    titleController.dispose();
    addlistController.dispose();
    super.dispose();
  }

  Future<void> _updateList() async {
    final updatedTitle = titleController.text;
    if (updatedTitle.isNotEmpty && addlistItems.isNotEmpty) {
      try {
        final updatedList = await _appwriteService.updateList(
          widget.id,
          updatedTitle,
          addlistItems,
        );
        Navigator.pop(context, Addlists.fromDocument(updatedList));
      } catch (e) {
        print("Error updating list: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update the document")),
        );
      }
    }
  }

  void _addNewListItem() {
    final newItem = addlistController.text.trim();
    if (newItem.isNotEmpty) {
      setState(() {
        addlistItems.add(newItem);
      });
      addlistController.clear();
    }
  }

  void _removeListItem(int index) {
    setState(() {
      addlistItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Edit Note"),
        actions: [
          IconButton(
            onPressed: _updateList,
            icon: Icon(Icons.check, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                label: Text("Title", style: TextStyle(color: Colors.green)),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: addlistController,
                    decoration: InputDecoration(
                      label: Text("Add to List", style: TextStyle(color: Colors.green)),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: _addNewListItem,
                       icon: Icon(Icons.add, color: Colors.green)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                ),
              /*  IconButton(
                  onPressed: _addNewListItem,
                  icon: Icon(Icons.add, color: Colors.green),
                ), */
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: addlistItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(addlistItems[index]),
                    trailing: IconButton(
                      onPressed: () => _removeListItem(index),
                      icon: Icon(Icons.delete, color: Colors.red),
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
