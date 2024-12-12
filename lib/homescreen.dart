import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'createNotes.dart';
import 'signin.dart';
import 'updatenotes.dart'; // Import the UpdateNotes screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? userId = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      // If there's no user logged in, navigate to the sign-in screen.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.off(() => SignIn());
      });
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Get.off(() => SignIn());
            },
            child: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Notes")
            .where("userId", isEqualTo: userId?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No Data Found"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var noteDoc = snapshot.data!.docs[index];
              var note = noteDoc['note'] ?? 'Default note';
              var noteId = noteDoc.id; // Get the document ID (noteId)

              return Card(
                child: ListTile(
                  title: Text(note),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,  // Ensure icons take only necessary space
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Navigate to the UpdateNotes screen
                          Get.to(() => UpdateNotes(
                            noteId: noteId,        // Pass the note ID
                            initialNote: note,     // Pass the initial note text
                          ));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          // Delete the note from Firestore
                          await FirebaseFirestore.instance
                              .collection("Notes")
                              .doc(noteId)
                              .delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Note deleted successfully!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CreateNotes());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
