import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; 
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


enum Slidableactions {liker, partager, plus, supprimer}


  class SlidableWidget extends StatefulWidget {
    SlidableWidget({
      @required this.child, 
      @required this.onDismissedactions, 
    }); 
    final Widget child; 
    final Function(Slidableactions actions) onDismissedactions; 

  @override
  _SlidableWidgetState createState() => _SlidableWidgetState();
}

class _SlidableWidgetState extends State<SlidableWidget>  with SingleTickerProviderStateMixin{

   //animation variables
    AnimationController likeController; 
    bool isFinished;
    Animation colorTweenAnimationController;

     @override 
    void initState() {
      super.initState(); 
      likeController = AnimationController(
        vsync: this, 
        duration: Duration(
          milliseconds: 200, 
        ), 
      ); 
      colorTweenAnimationController = ColorTween(
        begin: Colors.grey[400], 
        end: Colors.red[600],
      ).animate(likeController); 

      likeController.forward(); 
       likeController.addStatusListener(
      (status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isFinished = true; 
        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          isFinished = false; 
          });
        }
      }
    );
  }

  @override
  void dispose() {
    super.dispose(); 
    likeController.dispose(); 
  }


    @override
    Widget build(BuildContext context) {
      return Slidable(
        child: widget.child, 
            actionPane : SlidableDrawerActionPane(), 
            actionExtentRatio: 0.30,
            actions: <Widget>[
        IconSlideAction(
          caption: 'Liker',
          color: Colors.blue,
          iconWidget: AnimatedBuilder(
            animation: likeController,
            builder: (BuildContext context, child) {
              return  IconButton(
              icon: Icon(
                Icons.favorite, 
                color: colorTweenAnimationController.value,
              ),
              onPressed: () async {
                isFinished ? likeController.reverse() : likeController.forward();
                widget.onDismissedactions(Slidableactions.liker);  
              }
            );
            }
          ),
        ),
        IconSlideAction(
          caption: 'Partager',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () async {
            widget.onDismissedactions(Slidableactions.partager);
          }
        ),
],
secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Plus',
          color: Colors.black45,
          icon: Icons.more_horiz,
          onTap: () async {
            widget.onDismissedactions(Slidableactions.plus);  
          }
        ),
        IconSlideAction(
          caption: 'Supprimer',
          color: Colors.red,
          icon: FontAwesomeIcons.trash, 
          
          onTap: () async { 
             widget.onDismissedactions(Slidableactions.supprimer);
          }
        ),
      ],
    );
  } 
}