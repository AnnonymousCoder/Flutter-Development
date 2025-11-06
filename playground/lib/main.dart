import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:intl/intl.dart";

void main(){
  debugPaintSizeEnabled = true;
  runApp(
    const MaterialApp(
      home: PlayApp(),
    )
  );
}

class PlayApp extends StatelessWidget{
  const PlayApp({super.key});

  Widget nxtAlarm({required double hours, required double minutes}) => 
  Column(
    children: <Widget>[
      Text("Alarm in $hours $minutes minutes"),
      Text(DateFormat("EEE, MMM d, jm").format(DateTime.now())),
    ],
  );

  @override
  Widget build(BuildContext context){
    return CustomScrollView(
      slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: nxtAlarm(hours: 17, minutes: 16),
            ),
            bottom: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Alarm"),
              actionsPadding: EdgeInsets.all(8),
              actions: <Widget>[
                IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.add),
                ),
                IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.more_vert_rounded),
                )
              ],
            )
          ),
      ],
    );
  }
}