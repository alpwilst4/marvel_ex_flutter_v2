import 'package:flutter/material.dart';
import 'package:marvel_ex_flutter_v2/models/character.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';

void main() async {
  List<Character> list = await Character().getCharacters(30);
  runApp(MyApp(list));
}

class MyApp extends StatelessWidget {
  MyApp(this.list);
  final List<Character> list;
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => Character(),
    child: MaterialApp(home: HomeScreen(list)),

    );
  }
}