import 'package:flutter/material.dart';

void main() => runApp(
    MaterialApp(
      home: const HomeScreen(),
    )
);

class Note {

  String title;
  String body;

  Note({this.title="", this.body=""});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Note> notes = [];

  @override
  Widget build(BuildContext context) => Scaffold(

    appBar: AppBar(
      title: Text("My Notes"),
      centerTitle: true,
      backgroundColor: Colors.yellow,
    ),

    body: notes.isEmpty ? Center(child: Text("No notes added yet", style: TextStyle(fontSize: 25),)) :

    ListView.separated(
      padding: EdgeInsets.all(8.0),
      itemCount: notes.length,
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
      itemBuilder: (context, index) => ListTile(
        title: Text(notes[index].title),
        trailing: IconButton(onPressed: ()=>setState(()=>notes.removeAt(index)), icon: Icon(Icons.delete)),
        onTap: () async {
          Note result = await Navigator.push(context, MaterialPageRoute(builder: (newContext) => NoteScreen(note: notes[index])));
          setState(()=>notes[index] = result);
          } ,
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black), borderRadius: BorderRadiusGeometry.circular(12)),
        ),
    ),


    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        Note result = await Navigator.push(context, MaterialPageRoute(builder: (newContext) => NoteScreen(note: Note())));
        setState(()=>notes.add(result));
      },
      child: Icon(Icons.add)
    ),

  );
}

class NoteScreen extends StatefulWidget {

  final Note note;

  const NoteScreen({super.key, required this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    appBar: AppBar(
      backgroundColor: Colors.yellow,
      leading: IconButton(
          icon: Icon(Icons.check),
          onPressed: () => Navigator.pop(context, widget.note),
      )
    ),

    body: Container(
      margin: EdgeInsets.all(15),
      child: Column(

        children: [

          TextFormField(
            initialValue: widget.note.title,
            autofocus: true,
            autocorrect: true,
            textCapitalization: TextCapitalization.sentences,
            maxLength: 100,
            decoration: InputDecoration(
                hint: Text("Note title here", style: TextStyle(
                    color: Colors.grey.withAlpha(125)
                ),
                )
            ),
            onChanged: (title) => setState(()=> widget.note.title = title),
          ),

          TextFormField(
            initialValue: widget.note.body,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hint: Text("Note body here", style: TextStyle(
                  color: Colors.grey.withAlpha(125)
            ))),
            maxLines: null,
            autocorrect: true,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (body) => setState(()=> widget.note.body = body)
          ),
        ],
      ),
    )
  );}
}
