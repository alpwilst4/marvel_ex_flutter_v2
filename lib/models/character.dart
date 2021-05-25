
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:marvel_ex_flutter_v2/data/data.api/character_api.dart';

//const size = "/portrait_xlarge.jpg";
const size = "/portrait_incredible.jpg";

class Character extends ChangeNotifier {
  //static List<Character> _characters = [];

  final String name;
  final String imageUrl;
  final String description;
  final Map comics;
  Character({this.name, this.description, this.imageUrl, this.comics});

  // UnmodifiableListView<Character> get characters {
  //   return UnmodifiableListView(_characters);
  // }

  Future getCharacters(int limit) async {
    List<Character> _characters = [];
    var data = await CharacterApi().getCharactersFromApi(limit);
    var jsonData = jsonDecode(data.body.toString());

    for (var u in jsonData["data"]["results"]) {
      Character character = Character(
          name: u["name"],
          description: u["description"],
          imageUrl: u["thumbnail"]["path"].toString() + size,
          comics: u["comics"]);
      _characters.add(character);
      notifyListeners();
    }
    return _characters;
  }
}
