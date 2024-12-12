import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateNotes extends StatefulWidget {
  const CreateNotes({super.key});

  @override
  State<CreateNotes> createState() => _CreateNotesState();
}

class _CreateNotesState extends State<CreateNotes> {
  // Initialize the TextEditingController
  final TextEditingController noteController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser; // Get the current user

  @override
  void dispose() {
    // Dispose controller when not needed
    noteController.dispose();
    super.dispose();
  }

  Future<void> addNote() async {
    String note = noteController.text.trim();

    if (note.isNotEmpty && user != null) {
      try {
        await FirebaseFirestore.instance.collection("Notes").add({
          "createdAt": DateTime.now(),
          "note": note,
          "userId": user!.uid
        });

        noteController.clear(); // Clear the input field after adding the note
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note added successfully!')),
        );
      } catch (e) {
        print("Error adding note: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add note: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Notes"),
        backgroundColor: Colors.purple[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            TextFormField(
              controller: noteController, // Attach controller to TextFormField
              decoration: InputDecoration(hintText: "Add Notes"),
            ),
           ElevatedButton(
            onPressed: () async {
            await addNote(); 
            Navigator.pushNamed(context, '/home'); // Navigate to the home screen
            },
            child: Text("Add Notes"),
            ),
          ],
        ),
      ),
    );
  }
}
