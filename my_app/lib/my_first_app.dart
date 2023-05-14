import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(secondary: Colors.blueAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var previous = <WordPair>[]; // 'List' collection
  var favorites = <WordPair>{}; // 'Set' collection

  void addCurrentToPrevious() {
    const maxPrevious = 20;
    previous.insert(0, current);
    if (previous.length > maxPrevious) {
      previous.removeAt(previous.length - 1);
    }

    notifyListeners();
  }

  void getNext() {
    addCurrentToPrevious();
    current = WordPair.random();
    notifyListeners();
  }

  // ↓ Add the code below.

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    IconData icon;
    if (appState.favorites.contains(appState.current)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Namer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A random idea:'),
            BigCard(pair: appState.current),
            Text('Previous ideas:'),
            // Expanded list viewer with center alignment,
            Expanded(
              child: ListView(
                children: appState.previous
                    .map(
                      (e) => Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e.asLowerCase),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min, // ← Add this.
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                    // show message based on favorite status
                    var message = appState.favorites.contains(appState.current)
                        ? 'Added to favorites'
                        : 'Removed from favorites';

                    final flushBar = Flushbar(
                      message: message,
                      duration: Duration(seconds: 1),
                      flushbarPosition: FlushbarPosition.TOP,
                      // forwardAnimationCurve: Curves.easeInOutQuint,
                      // reverseAnimationCurve: Curves.easeInOutQuint,
                    );
                    flushBar.show(context);
                  },
                  icon: Icon(icon),
                  label: Text('Favorite'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        // currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        // onTap: _onItemTapped,
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
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        // ↓ Change this line.
        child: Text(pair.asLowerCase, style: style),
      ),
    );
  }
}
