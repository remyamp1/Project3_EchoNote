
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart';

class AppwriteService {
  late Client client;
  late Databases databases;

  static const endpoint = "https://cloud.appwrite.io/v1";
  static const projectId = "674d58350038714332d9";
  static const databaseId = "674d58b3000a8e87d128";
  static const taskcollectionId = "674d58c4001c94b00eaf";
  static const textcollectionId = "674d5968000749948a62";
  static const listcollectionId = "674d592300129f8ddb49";
  AppwriteService() {
    client = Client();
    client.setEndpoint(endpoint);
    client.setProject(projectId);
    databases = Databases(client);
  }
  
  get documentId => null;
// taskcollection function
  Future<List<Document>> getTasks() async {
    try {
      final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: taskcollectionId,
      );
      return result.documents;
    } catch (e) {
      print("error loading tasks:$e");
      rethrow;
    }
  }

  Future<Document> addTask(
      String Title, String Description, String Date, String Time) async {
    try {
      final documentId = ID.unique();
      final result = await databases.createDocument(
        databaseId: databaseId,
        collectionId: taskcollectionId,
        data: {
          'Title': Title,
          'Description': Description,
          'Date': Date,
          'Time': Time
        },
        documentId: documentId,
      );
      return result;
    } catch (e) {
      print('Error creating task:$e');
      rethrow;
    }
  }

  Future<void> deleteTask(String documentId) async {
    try {
      await databases.deleteDocument(
          databaseId: databaseId,
          collectionId: taskcollectionId,
          documentId: documentId);
    } catch (e) {
      print("error deleting task:$e");
      rethrow;
    }
  }


  Future<Document> updateTask(
    String textId, String Title, String Description,) async {
  try {
    final result = await databases.updateDocument(
      databaseId: databaseId,
      collectionId: taskcollectionId,
      data: {'Title': Title, 
      'Description': Description,
       },
      documentId: textId,
    );
    return result;
  } catch (e) {
    print("Error updating text: $e");
    throw Exception("Failed to update text");
  }
}

// textcollection function
  Future<List<Document>> getTexts() async {
    try {
      final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: textcollectionId,
      );
      return result.documents;
    } catch (e) {
      print("error loading tasks:$e");
      rethrow;
    }
  }

  Future<Document> addText(
      String Title, String Content, ) async {
    try {
      final documentId = ID.unique();
      final result = await databases.createDocument(
        databaseId: databaseId,
        collectionId: textcollectionId,
        data: {'Title': Title, 'Content': Content,},
        documentId: documentId,
      );
      return result;
    } catch (e) {
      print('Error creating task:$e');
      rethrow;
    }
  }


Future<Document> updateText(String textId, String Title, String Content) async {
  try {
    final result = await databases.updateDocument(
      databaseId: databaseId,
      collectionId: textcollectionId,
      data: {'Title': Title, 'Content': Content},
      documentId: textId,
    );
    return result;
  } catch (e) {
    print("Error updating text: $e");
    throw Exception("Failed to update text");
  }
}


  Future<void> deleteText(String documentId) async {
    try {
      await databases.deleteDocument(
          databaseId: databaseId,
          collectionId: textcollectionId,
          documentId: documentId);
    } catch (e) {
      print("error deleting task:$e");
      rethrow;
    }
  }

  // Listcollection function

   Future<List<Document>> getLissts() async {
    try {
      final result = await databases.listDocuments(
          databaseId: databaseId, collectionId: listcollectionId);
      return result.documents;
    } catch (e) {
      print('Error loading notes:$e');
      rethrow;
    }
  }
 Future<Document> addLisst(String Title, List<String> addlist) async {
    try {
      final documentId = ID.unique();
      final response = await databases.createDocument(
        databaseId: databaseId,
        collectionId: listcollectionId,
        data: {
          'Title': Title,
          'addlist': addlist, // Pass the entire list of strings
        },
        documentId: documentId,
      );
      print('Document created with title: ${response.data['Title']}');
      print('List data:${response.data['addlist']}');
      return response;
    } catch (e) {
      print('Error creating list: $e');
      rethrow;
    }
  }

  Future<Document> updateLisst(
    String lisstId, String Title, List<String> addList) async {
  try {
    final result = await databases.updateDocument(
      databaseId: databaseId,
      collectionId: listcollectionId,
      documentId: lisstId,
      data: {
        'Title': Title,
        'addlist': addList,
      },
    );
    return result;
  } catch (e) {
    print('Error updating list :$e');
    rethrow;
  }
}

Future<void> deleteLisst(String LisstId) async {
  try {
    await databases.deleteDocument(
      databaseId: databaseId,
      collectionId: listcollectionId,
      documentId: LisstId,
    );
    print('List deleted successfully');
  } catch (e) {
    print('Error deleting list: $e');
    rethrow;
  }
}

}