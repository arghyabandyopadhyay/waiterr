import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

Future<String> downloadURL(String directory) async {
  String downloadURL = await storage.ref(directory).getDownloadURL();
  return downloadURL;
}
