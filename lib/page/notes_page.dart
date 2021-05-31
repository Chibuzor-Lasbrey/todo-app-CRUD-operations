import 'package:flutter/material.dart';
import 'package:sqflite_database_example/db/notes_database.dart';
import 'package:sqflite_database_example/model/note.dart';
import 'package:sqflite_database_example/page/edit_note_page.dart';
import 'package:sqflite_database_example/page/note_detail_page.dart';
import 'package:sqflite_database_example/widget/note_card_widget.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu_outlined),
            color: Colors.white,
            iconSize: 35,
            onPressed: () {},
          ),
          title: Text("My Todos",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.white)),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                iconSize: 35,
                padding: EdgeInsets.symmetric(vertical: 4),
                onPressed: () {}),
          ],
        ),
        body: SafeArea(
          minimum: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          child: Container(
            child: Column(
              children: [
                Container(
                    alignment: AlignmentDirectional.centerStart,
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                    child: Text(
                      "Welcome back,Mr Lasbrey",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    )),
                Container(
                  color: Colors.black,
                  child: Image(
                    image: NetworkImage(
                        "https://images.unsplash.com/photo-1575680841437-a429bf58c2ad?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fGltYWdlcyUyMHdpdGglMjB0ZXh0fGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0),
                      ),
                    ),
                    child: Center(
                      child: isLoading
                          ? CircularProgressIndicator()
                          : notes.isEmpty
                              ? Text(
                                  'No Notes',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                )
                              : buildNotes(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditNotePage()),
            );

            refreshNotes();
          },
        ),
      );

  Widget buildNotes() => ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}
