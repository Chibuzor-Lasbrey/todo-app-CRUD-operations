import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_database_example/auth_screens/login_page.dart';
import 'package:sqflite_database_example/db/notes_database.dart';
import 'package:sqflite_database_example/model/note.dart';

import 'package:sqflite_database_example/page/edit_note_page.dart';
import 'package:sqflite_database_example/page/note_detail_page.dart';
import 'package:sqflite_database_example/provider/auth_provider.dart';
import 'package:sqflite_database_example/widget/note_card_widget.dart';
import 'package:page_transition/page_transition.dart';

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

  String? email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Builder(
                  builder: (context) => IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ))),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                })
          ],
        ),
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          DrawerHeader(
              child: Center(
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/images/puppy.jpg"))),
            ),
          )),
          Center(
              child: Container(
            child: Text("Email: $email",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 14)),
          )),
          TextButton(
            onPressed: () {
              //sign out user
              AuthClass().signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false);
            },
            child: Text("Log Out",
                style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.red)),
          )
        ])),
        body: SafeArea(
          minimum: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
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
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        )
                      : buildNotes(),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: AddEditNotePage()),
            );

            refreshNotes();
          },
        ),
      );

  Widget buildNotes() => StaggeredGridView.countBuilder(
        crossAxisCount: 4,
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
        staggeredTileBuilder: (int index) =>
            new StaggeredTile.count(2, index.isEven ? 2 : 1),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      );
}
