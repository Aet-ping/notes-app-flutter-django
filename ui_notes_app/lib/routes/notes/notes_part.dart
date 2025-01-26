import 'package:flutter/material.dart';
import 'package:ui_notes_app/services/notes_data.dart';
import 'package:ui_notes_app/routes/notes/second_part_note.dart';

class NotesPart extends StatefulWidget {
  const NotesPart({super.key});
  @override
  State<NotesPart> createState() => _NotesPartState();
}

class _NotesPartState extends State<NotesPart> {
  late Future<List<dynamic>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _notesFuture = fetchAllNotes();
  }

  Future<void> refreshNotes() async {
    try {
      setState(() {
        _notesFuture = fetchAllNotes();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to refresh notes: $e')),
      );
    }
  }

  Future<void> handleDeleteNote(int id) async {
    try {
      await deleteNote(id);
      await refreshNotes();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete note: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("My Notes", style: TextStyle(fontSize: 24)),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondPartNote(
                        content: "",
                        id: "",
                        title: "Enter a title",
                        actions: "createNote",
                      ),
                    ),
                  ).then((_) {
                    refreshNotes();
                  });
                },
                icon: Icon(Icons.add),
              ),
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  final bool? confirmLogout = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Logout'),
                        content: Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Return true if the user confirms
                              Navigator.of(context).pop(true);
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmLogout == true) {
                    try {
                      await logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to logout: $e')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
          Container(
            height: 5,
            width: double.maxFinite,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black)),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _notesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final items = snapshot.data!;
                  return RefreshIndicator(
                    onRefresh: refreshNotes,
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final note = items[index];
                        return Column(
                          children: [
                            Container(
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SecondPartNote(
                                          content: note["content"],
                                          actions: "updateNote",
                                          id: note['id'].toString(),
                                          title: note["title"],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(note["title"]),
                                      IconButton(
                                        onPressed: () async {
                                          await handleDeleteNote(note["id"]);
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return Center(child: Text('No notes available.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
