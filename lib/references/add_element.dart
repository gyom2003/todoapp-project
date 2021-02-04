import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/references/list-reference.dart';
import 'package:todoapp/services/notes_services_crud.dart';
import 'package:todoapp/services/DBreference.dart'; 
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';


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

  String errtext; 
  String descEdited; 
  String titleEdited;
  File selectedimage;  


  TextEditingController titleController; 
  TextEditingController descController;

  final formKeyOne = GlobalKey<FormState>();
  final formKeyTwo = GlobalKey<FormState>(); 
  final picker = ImagePicker();

  final dbInstance = Databasehelper.instance; 

  bool get trueEditing => widget.noteID != null; 
  //bool validateController = true; 

  void addDatatoList(int index) async {

    Map<String, dynamic> row = {
      //ou titleEdited, descEdited
      Databasehelper.columnTitle : titleEdited, 
      Databasehelper.columnDesc : descEdited, 
    }; 
    final id = await dbInstance.insert(row); 
    final query = await dbInstance.queryall(); 
    print(id); 
    print(row.values);
    print(query); 
    try {
    listPush.add(
      ListForReference(
        noteTitle: row[0], 
        noteID: row[1],
        createEditingTime: DateTime.now(),
        lastEditingTime: DateTime.now(),
        noteCirlceAvatar: listPush.isEmpty ? "": listPush[index].noteCirlceAvatar,  
      )
    );
    } catch(e) {
      print("erreure add data: ${e.toString()}"); 
    }
  }

  void completetheDelete() async {
    //nouveau button
     Map<String, dynamic> row = {
      Databasehelper.columnTitle : titleEdited,  
      Databasehelper.columnDesc : descEdited,
    };
    //à revoire
    await dbInstance.deletedata(row['columnTitle']); 
    await dbInstance.deletedata(row['columnDesc']);

    final id = await dbInstance.insert(row); 
    final query = await dbInstance.queryall(); 
    print(id); 
    print(row.values);
    print(query); 
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
        element.noteCirlceAvatar = Image.file(selectedimage, fit: BoxFit.cover);
        element.noteID = row[1].toString();
        element.noteTitle = row[0].toString();  
      }); {}
    } catch(e) {
      print("erreure update: ${e.toString()}");
    }
  }

  Future getImageCamera() async {
    PickedFile file = await picker.getImage(source: ImageSource.camera); 
    setState(() {
      if (file != null) {
        selectedimage = File(file.path); 
      } else {
        print("pas encore d'image selectionnée de la gallerie"); 
      }
    });
  }

   Future<void> cropImage() async {
    File selected = await ImageCropper.cropImage(
      sourcePath: selectedimage.path, 
      aspectRatioPresets: Platform.isAndroid
      ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ]
    : [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio5x3,
      CropAspectRatioPreset.ratio5x4,
      CropAspectRatioPreset.ratio7x5,
      CropAspectRatioPreset.ratio16x9
    ], 
     androidUiSettings: AndroidUiSettings(
      toolbarTitle: 'Cropper',
      toolbarColor: Colors.deepOrange,
      toolbarWidgetColor: Colors.white,
      initAspectRatio: CropAspectRatioPreset.original,
      lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      )
    );
    setState(() {
      selectedimage = selected ?? selectedimage; 
    }); 

  }

  theAlertDialogue(BuildContext context) {
    return AlertDialog(
      title: Text("message obligatoire ! "), 
      content: Text("modifier l'image ou la valider ♉?"), 
      actions: <Widget> [
        FlatButton(
           child: Text("Oui ✔"), 
           onPressed: () {
             if (selectedimage != null) {
               Image.file(selectedimage); 
               cropImage(); 
             }
           },
        ), 
        FlatButton(
           child: Text("Non ✖ mais merci quand même pour le geste"), 
           onPressed: () {
            Navigator.of(context).pop(false); 
            getImageCamera(); 
           }, 
        ), 
      ],
    ); 
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
           padding: EdgeInsets.all(8.0),
           child: Container(
             margin: EdgeInsets.symmetric(horizontal: 25), 
             height: 150, 
             width: _width, 
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.all(Radius.circular(10)), 
             ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: <Widget> [
                IconButton(
                icon: Icon(
                  Icons.add_a_photo, 
                  color: Colors.black45,),
                  onPressed: (){
                    print("image picker avec la caméra"); 
                    theAlertDialogue(context); 
                  },
                ),
              ],
            )
           )
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
