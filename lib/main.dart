
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/references/list-reference.dart';
import 'package:todoapp/references/add_element.dart';
import 'package:todoapp/services/notes_services_crud.dart';
import 'package:todoapp/SliverBody.dart';
import 'package:device_preview/device_preview.dart';
import 'package:share/share.dart';
import 'package:todoapp/services/DBreference.dart'; 



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, 
    DeviceOrientation.portraitDown, 
  ]); 
  await ModelPreferences.initPreferences(); 
  runApp(
    DevicePreview(
      builder: (context) => MyApp(), 
      enabled: !kReleaseMode,));
}
class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Flutter TodoApp',
      theme: ThemeData(     
        primarySwatch: Colors.blue,
      ),
      //Changed Notifier
     home: HomePageTodoApp()
       
    );
  }
}   

class HomePageTodoApp extends StatefulWidget {
  //final service = NoteServices(); 
  @override
  _HomePageTodoAppState createState() => _HomePageTodoAppState();
}

class _HomePageTodoAppState extends State<HomePageTodoApp> {
  GlobalKey <ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>(); 
  final dbInstance = Databasehelper.instance;
    
  @override
  void initState() { 
    super.initState();
  }

  void showSnackBar(String themessage) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('le message: $themessage'),
        ),
      );
    } 

    void share(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject();
    final String text = ""; 
    Share.share(
      text, 
      subject: text, 
      sharePositionOrigin: renderBox.localToGlobal(Offset.zero) & renderBox.size, 
    ); 
  }
  
   void dismisstheListTile(BuildContext context, int index, Slidableactions actions) {

    switch (actions) {
      case Slidableactions.liker: 
      showSnackBar("Liker"); 
        break; 
      
      case Slidableactions.partager:
      showSnackBar("Partager");
      share(context); 
        break; 

      case Slidableactions.plus:
      showSnackBar("Plus");
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SecondPage()
          )
        );
        break; 

      case Slidableactions.supprimer: 
      showSnackBar("Supprimer");
      //supprimer de db
        setState(() async {
          listPush.removeAt(index);
        });
        break;
      
    }
  }


 
  @override
  Widget build(BuildContext context) {
    dynamic currentime = DateFormat.jm().format(DateTime.now()); 

    //ou avec intl
    return Scaffold(
      backgroundColor: Color(0xFF2D2C35),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.blueGrey,
        clipBehavior: Clip.none,
        child: Icon(Icons.add), 
        onPressed: () {
          print(currentime); 
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SecondPage(

            ), 
          )); 
        },
      ),
          body : Stack(
        children: <Widget> [
          CustomScrollView( 
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35), 
                  bottomRight: Radius.circular(35),
                ), 
              ),
              pinned: false,
              stretch: true,
              floating: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              expandedHeight: 280,
              stretchTriggerOffset: 280,
              onStretchTrigger: () {
                print("tu vas trop loin !");
                return;
                },
              leading: IconButton(
                icon: FaIcon(FontAwesomeIcons.bars, size: 20), 
                onPressed: () {
                  //TODO: Créer un drawer pour d'autres fonctionnalitées
                  scaffoldkey.currentState.openDrawer(); 
                },
              ),
              //flexibleSpaceBar
              flexibleSpace: FlexibleSpaceBar(  
                centerTitle: true,
                collapseMode: CollapseMode.parallax, //pin
                stretchModes:<StretchMode> [
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                    StretchMode.blurBackground,
                ],
                background: Stack(
                    fit: StackFit.expand,
                    children: <Widget> [
                      //ajout autre texte
                      Image.asset("assets/images/montagne.jpg", fit: BoxFit.fill), 
                      DecoratedBox( 
                        //effet ombre
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, 0.5), 
                            end: Alignment(0.0, 0.5), 
                            colors: <Color> [
                               Color(0x60000000),
                              Color(0x00000000),
                            ]
                          )
                        )
                      ), 
                      Column(
                        //si deux textes 
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          Wrap(
                          children: <Widget> [ 
                            Padding(
                              padding: EdgeInsets.only(
                                top: 150, 
                                bottom: 0,
                                left: 130,
                                right: 0,    
                              ),
                              child: Container( 
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft, 
                                    end: Alignment.bottomRight, 
                                    colors: [ 
                                      Colors.black.withOpacity(0.5), 
                                      Colors.black.withOpacity(0.2), 
                                    ]
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(30)), 
                                ),
                                  child: Text("Listes des notes",  
                                    style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                    color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600, 
                                      ), 
                                    ),
                                  ),
                                ),
                            ),
                          ]),
                           
                        ],
                      ),  
                    ],
                  ),
                
              ),
            ), 
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                  margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white54, 
                          Colors.white60, 
                        ]
                      ),
                    ),
                    //StreamBuilder

                    child: SlidableWidget(
                        onDismissedactions: (actions) => 
                          dismisstheListTile(context, index, actions), 
                        child: listTileChild(context, index),
                        ),
                  ); 
                }, 
                childCount: listPush.length
              )
            )
          ],
        ),
        
        ]
      ),
    );  
  }
   ListTile listTileChild(BuildContext context, int index) {
    return ListTile(
        title: Text(listPush.isEmpty ? "pas de titre" : listPush[index].noteTitle, 
        style: TextStyle(color: Theme.of(context).primaryColor)), 
        isThreeLine: true,
        //ou CircleAvatar
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: listPush[index].noteCirlceAvatar, 
        ),   
        subtitle: Text(
        "dernière fois édité: ${listPush[index].lastEditingTime.day}/${listPush[index].lastEditingTime.month}/${listPush[index].lastEditingTime.year}, body: ${listPush.isEmpty ? "pas de description" : listPush[index].noteID}",
        style: TextStyle(),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SecondPage(
              noteID: listPush[index].noteID,
              ), 
            )
          );
        }, 
      );
  }
}

