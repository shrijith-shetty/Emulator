import 'package:emulator/%20learn_database/db.dart';
import 'package:flutter/cupertino.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Insert a note
  await DatabaseHelper.instance.insert({
    'title': 'First Note',
    'content': 'This is my first SQLite note!'
  });

  // Fetch all notes
  var notes = await DatabaseHelper.instance.queryAll();
  print(notes);
}
