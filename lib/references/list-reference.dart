import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

//classe qui complete le listTile

class ListForReference {
  Image noteCirlceAvatar;  
  String noteTitle; 
  String noteID;  
  DateTime createEditingTime;
  DateTime lastEditingTime;

  ListForReference({
    this.noteCirlceAvatar, 
    this.noteTitle, 
    this.noteID, 
    this.createEditingTime, 
    this.lastEditingTime, 
  }); 
}

//enumeration possibilitées de titres en fonction des pages 
enum TitreText {listes, ajouter, changer} //des notes 


//classe 
class ModelPreferences {

  static SharedPreferences preferences; 
  static const titleKey = "titre"; 
  static const descriptionKey = "description"; 
  static const datekey = "date"; 

  static Future initPreferences() async {
    preferences = await SharedPreferences.getInstance(); 
  }

  static Future setTheTitle(String title) async {
    await preferences.setString(titleKey, title); 
  }
  static String getTheTitle() => preferences.getString(titleKey); 

   static Future setTheDescription(String description) async {
     await preferences.setString(descriptionKey, description);
   }
  static String getTheDescription() => preferences.getString(descriptionKey);

  //methode changer date 
  static DateTime getTheDate() {
    final thenewDate = preferences.getString(datekey); 
    return thenewDate == null ? null : DateTime.tryParse(thenewDate); 
  }
}

//alert dialogue pour supprimer une note
class DeleteAlertDialogue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Attention", 
      style: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: Colors.black54, 
          fontWeight: FontWeight.bold, 
          fontSize: 20
        )
      ),), 
      content: Text("Etes-vous sure de supprimer cette note ? 😐",
        style: GoogleFonts.openSans(
        textStyle: TextStyle(
          color: Colors.black54, 
          fontSize: 20, 
        )
      ),
      ),
      actions: <Widget> [
        FlatButton(
          child: Text("Oui ✔", 
          style: TextStyle(
            color: Colors.black45, 
            fontWeight: FontWeight.bold
          ),), 
          onPressed: () {
            Navigator.of(context).pop(true); 
            //supprimmer pa note
          }
        ),

         FlatButton(
          child: Text("Non ✖", 
          style: TextStyle(
            color: Colors.black45,
            fontWeight: FontWeight.w500,  
          ),), 
          onPressed: () {
            Navigator.of(context).pop(false); 
          }
        ),
      ],
      elevation: 25,
      backgroundColor: Color(0xFF5499C7),
      shape: RoundedRectangleBorder(),  //CircleBorder()
    );
  }
}