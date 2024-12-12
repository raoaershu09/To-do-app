import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateNotes extends StatefulWidget {
  final String noteId;
  final String initialNote;

  const UpdateNotes({super.key, required this.noteId, required this.initialNote});

  @override
  State<UpdateNotes> createState() => _UpdateNotesState();
}

class _UpdateNotesState extends State<UpdateNotes> {
  final TextEditingController noteController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the current note text
    noteController.text = widget.initialNote;
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  Future<void> updateNote() async {
    String updatedNote = noteController.text.trim();

    if (updatedNote.isNotEmpty && user != null) {
      try {
        // Update the note in Firestore
        await FirebaseFirestore.instance
            .collection("Notes")
            .doc(widget.noteId)
            .update({
          "note": updatedNote,
          "updatedAt": DateTime.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note updated successfully!')),
        );
        Navigator.pop(context); // Go back after updating
      } catch (e) {
        print("Error updating note: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update note: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Notes"),
        backgroundColor: Colors.purple[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            TextFormField(
              controller: noteController,
              decoration: InputDecoration(hintText: "Update Note"),
            ),
            ElevatedButton(
              onPressed: updateNote,
              child: Text("Update Note"),
            ),
          ],
        ),
      ),
    );
  }
}
