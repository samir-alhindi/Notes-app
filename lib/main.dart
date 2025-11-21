import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'note.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>("notes");

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    )
);
}



class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  final Box<Note> notesBox = Hive.box<Note>("notes");

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //List<Note> notes = [];

  @override
  Widget build(BuildContext context) => Scaffold(

    appBar: AppBar(
      title: Text("My Notes"),
      centerTitle: true,
      backgroundColor: Colors.yellow,
    ),

    body: widget.notesBox.isEmpty ? Center(child: Text("No notes added yet", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)) :

    ListView.separated(
      padding: EdgeInsets.all(8.0),
      itemCount: widget.notesBox.length,
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
      itemBuilder: (context, index) => Card(
        child: ListTile(
          title: Text(widget.notesBox.getAt(index)?.title ?? "null"),
          trailing: IconButton(onPressed: () => _confirmDeletion(index), icon: Icon(Icons.delete)),
          onTap: () async {
            Note result = await Navigator.push(context, MaterialPageRoute(builder: (newContext) => NoteScreen(note: widget.notesBox.getAt(index)??Note(title: "null", body: "null"))));
            widget.notesBox.putAt(index, result);
            setState(()=>null);
            } ,
          ),
      ),
    ),


    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        Note result = await Navigator.push(context, MaterialPageRoute(builder: (newContext) => NoteScreen(note: Note())));
        widget.notesBox.add(result);
        setState(()=>null);
      },
      child: Icon(Icons.add)
    ),

  );

  void _confirmDeletion(int index){
    showDialog(
        context: context,
        builder: (newContext) => AlertDialog(
          title: Text("Delete ' ${widget.notesBox.getAt(index)?.title} ' ?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(newContext), child: Text("CANCEL")),
            TextButton(
                onPressed: () {
                  widget.notesBox.deleteAt(index);
                  setState(() => null);
                  Navigator.pop(newContext);
                  },
                child: Text("CONFIRM")),
          ],
        )
    );
  }
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result)=> didPop ?null : Navigator.pop(context, widget.note),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.yellow,
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
        ),
    );}
}
