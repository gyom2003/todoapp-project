import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/references/list-reference.dart';
import 'package:todoapp/services/notes_services_crud.dart';
import 'package:todoapp/services/DBreference.dart'; 


class SecondPage extends StatefulWidget {
  //constructeur changer val textFormField
  final String noteID;  
  SecondPage({
    this.noteID,
  }); 

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  String errtext = ""; 
  String descEdited = ""; 
  String titleEdited = ""; 


  TextEditingController titleController; 
  TextEditingController descController;

  final formKeyOne = GlobalKey<FormState>();
  final formKeyTwo = GlobalKey<FormState>(); 

  final dbInstance = Databasehelper.instance; 

  bool get trueEditing => widget.noteID != null; 
  //bool validateController = true; 

  void addDatatoList(int index) async {

    Map<String, dynamic> row = {
      Databasehelper.columnTitle : titleEdited, 
      Databasehelper.columnDesc : descEdited
    }; 
    final id = await dbInstance.insert(row); 
    final query = await dbInstance.queryall(); 
    print(id); 
    print(row.values);
    print(query); 
    titleEdited = ""; 
    descEdited = ""; 
    listPush.add(
      ListForReference(
        noteTitle: row[0].toString(), 
        noteID: row[1].toString(),
        createEditingTime: DateTime.now(),
        lastEditingTime: DateTime.now(),
        noteCirlceAvatar: listPush[index].noteCirlceAvatar,  
      
      )
    );
  }

  void completetheDelete() async {
    //nouveau button
     Map<String, dynamic> row = {
      Databasehelper.columnTitle : titleEdited, 
      Databasehelper.columnDesc : descEdited
    };
    await dbInstance.deletedata(row[0]); 
    await dbInstance.deletedata(row[1]);
  }

  void updateDatatoList(int index) async {  
    Map<String, dynamic> row = {
      Databasehelper.columnTitle : titleEdited, 
      Databasehelper.columnDesc : descEdited
    }; 
    try {
       listPush.forEach((element) {
        element.createEditingTime = DateTime.now();
        element.lastEditingTime =  DateTime.now();
        element.noteCirlceAvatar = listPush[index].noteCirlceAvatar;
        element.noteID = row[1].toString();
        element.noteTitle = row[0].toString();  
      });
    } catch(e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    int index; 
    return Scaffold(
      backgroundColor: Color(0xFF7FB3D5),
      appBar: AppBar(
        title: Text(
          trueEditing ? "Modification de la note": "Ajoute de nouvelles choses à faire",
        style: GoogleFonts.openSans(
          textStyle: TextStyle(
            color: Colors.white, 
            fontSize: 17, 
            fontWeight: FontWeight.w500, 
          )
        ),), 
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, 
          color: Colors.blueGrey), 
          onPressed: () {
            Navigator.push(context, 
            MaterialPageRoute(
              builder: (context) => HomePageTodoApp(), 
            )); 
          },
        ),
        actions: <Widget> [
        ],
      ),
      body: Stack(
      children: <Widget>  [ 
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topCenter,
            //ou avec un container
            child: CircleAvatar(
              radius: 37, 

              child: CircleAvatar(
                radius: 36,
                backgroundImage: NetworkImage("https://to-do-cdn.microsoft.com/static-assets/c87265a87f887380a04cf21925a56539b29364b51ae53e089c3ee2b2180148c6/icons/logo.png"),
                backgroundColor: Color(0xFF7FB3D5),
                foregroundColor: Colors.black54, 
              ),
            ),
          ),
        ),
          
        //vrai body 
        Positioned(
          top: 160,
          bottom: 0,
          left: 0, 
          right: 0,
          child: Column(
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: titleController,
                  onChanged: (_valuetitle) {
                    titleEdited = _valuetitle; 
                  },
                  //key: formKeyOne, 
                  decoration: InputDecoration(
                    hintText: "title de la note", 
                    hintStyle: TextStyle(
                      color: Colors.black54, 
                      fontWeight: FontWeight.w500, 
                    ), 
                    //bordure
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)), 
                      borderSide: BorderSide(color: Colors.transparent,) // Color(0xFF7FB3D5)
                    ), 
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.greenAccent), 
                       borderRadius: BorderRadius.all(Radius.circular(35))
                    ), 
                    prefixIcon: Icon(Icons.title_rounded), 
                    filled: true, 
                    fillColor: Colors.grey[500],
                  ), 
                ),
              ), 

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: descController, 
                  onChanged: (_valuedesc) {
                    descEdited = _valuedesc; 
                  },
                  //key: formKeyTwo,
                  decoration: InputDecoration( 
                    hintText: "contenue de la note",
                    hintStyle: TextStyle(
                      color: Colors.black54, 
                      fontWeight: FontWeight.w500,
                    ),
                     //bordure
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)), 
                      borderSide: BorderSide(color: Colors.transparent,) // Color(0xFF7FB3D5)
                    ), 
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.greenAccent), 
                       borderRadius: BorderRadius.all(Radius.circular(35))
                    ), 
                    prefixIcon: Icon(Icons.title_rounded), 
                    filled: true, 
                    fillColor: Colors.grey[500],
                  ), 
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 325, 
            left: 35, 
          ), 
          child: SizedBox(
            width: _width * 0.8,
            height: 55, 
            child: RaisedButton(
              clipBehavior: Clip.none,
              child: Text("Poster", 
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  color: Colors.white,
                ),
              )),
              color: Color(0xFF5499C7), //oxFF2980B9
              onPressed: () {
                Navigator.of(context).pop();
                if (trueEditing) {
                 
                  updateDatatoList(index);
                   
                } else {
                  
                  addDatatoList(index); 
                  
                }
              }
            )
          ),
        ), 
        Padding(
          padding: EdgeInsets.only(
            top: 425, 
            left: 85, 
          ), 
          child: SizedBox(
            width: _width * 0.5,
            height: 45, 
            child: RaisedButton(
              clipBehavior: Clip.none,
              child: Text("Supprimer la dernière requete ⚡", 
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  color: Colors.white,
                ),
              )),
              color: Color(0xFF2980B9), //oxFF2980B9 //oxff40A497
              onPressed: () {
                completetheDelete(); 
                Navigator.of(context).pop();
               
              }
            )
          ),
        ), 


        ], 
      )
    );
  }
}
