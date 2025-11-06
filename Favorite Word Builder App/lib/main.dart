import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
   return ChangeNotifierProvider(
      create: (context) => MainAppState(),
      child:  MaterialApp(
        title: 'PlayGround',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor:Colors.green),
        ),
      home: HomePage(),
      ),
   );
  }
}

class MainAppState extends ChangeNotifier{
  var current = WordPair.random();
  var favorites = <WordPair>[];
  void getNext(){
    current = WordPair.random();
    notifyListeners();
  }
  void toggleFavorites(){
    if(favorites.contains(current)){
      favorites.remove(current);
    }else{
      favorites.add(current);
    }
    notifyListeners();
  }
}

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage>{

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context){
    Widget page;

    switch(selectedIndex){
    case 0:
      page = GeneratorPage();
    case 1:
      page = FavoritesPage();
    default:
      throw UnimplementedError('no widget for $selectedIndex');
  }

   return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination( icon: Icon(Icons.home), label: Text("Home")),
                  NavigationRailDestination( icon: Icon(Icons.favorite), label: Text("Favorites")),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected:(value){
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),

            Expanded(
                child: Container(
                  color:Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
          ],
        ),
    ); 
  });
  }
}


class GeneratorPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MainAppState>();
    var pair = appState.current;

    IconData heartIcon;
    if(appState.favorites.contains(pair)){
      heartIcon = Icons.favorite;
    }else{heartIcon = Icons.favorite_border;}

    return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('A random idea is cooking something: '),
              BigCard(pair: pair),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () { appState.toggleFavorites(); },
                    icon: Icon(heartIcon),
                    label: Text("Fav Btn!"),
                  ),
                  ElevatedButton(
                    onPressed:(){ appState.getNext(); },
                    child: Text("Next!"),
                  ),
                ],
              ),
            ], 
          ),
      );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child:  Padding(
        padding: const EdgeInsets.all(20),
        child:  Text(pair.asLowerCase, 
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}"
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var fav = context.watch<MainAppState>();
    var fstyleTitle = Theme.of(context).textTheme.titleMedium!.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    var fstyleSpecial = Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
      decorationStyle: TextDecorationStyle.dotted,
      decorationColor: Theme.of(context).colorScheme.primary,
    );
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(8),
        children: fav.favorites.map((x) => Card(
          child: ListTile(
            title: Text(x.asLowerCase, style: fstyleTitle),
            subtitle: Text.rich(
              TextSpan(
                text: "Sentence Usage : ~ amssn snnsnj ",
                children: <TextSpan>[
                  TextSpan(text: "'${x.asLowerCase}'", style: fstyleSpecial),
                  TextSpan(text: " sjnajnudiks sndsknsk")
                ]
              ),
            ),
          )
        )).toList(),
      ),
    );
  }
}