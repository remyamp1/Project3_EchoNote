
import 'package:dart_appwrite/models.dart';

class Task {
  final String id;
  final String Title;
  final String Description;
  final String Date;
  final String Time;

  Task({
    required this.id,
    required this.Title,
    required this.Description,
    required this.Date,
    required this.Time,
  });

  factory Task.fromDocument(Document doc) {
    return Task(
        id: doc.$id,
        Title: doc.data["Title"] ?? '',
        Description: doc.data['Description'] ?? '',
        Date: doc.data['Date'] ?? '',
        Time: doc.data['Time'] ?? '');
  }
}
// Text
class Texts {
  final String id;
  final String Title;
  final String Content;


  Texts({
    required this.id,
    required this.Title,
    required this.Content,
 
  });

  factory Texts.fromDocument(Document doc) {
    return Texts(
        id: doc.$id,
        Title: doc.data["Title"] ?? '',
        Content: doc.data['Content'] ?? '',
      );
  }
}
// List
class Lisst {
  final String id;
  final String Title;
  final List<String> addlist;  // Change from String to List<String>

  Lisst({
    required this.id,
    required this.Title,
    required this.addlist,
  });

  factory Lisst.fromDocument(Document doc) {
    // Ensure the 'addlist' field is a list
    return Lisst(
      id: doc.$id,
      Title: doc.data['Title'],
      addlist: List<String>.from(doc.data['addlist'] ?? []),  // Convert 'addlist' to List<String>
    );
  }
}