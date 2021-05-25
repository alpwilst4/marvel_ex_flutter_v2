import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marvel_ex_flutter_v2/models/character.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.list);
  final List<Character> list;

  @override
  _HomeScreenState createState() => _HomeScreenState(list);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState(this.list);
  List<Character> list;
  

  int count = 30;
  
  @override
  Widget build(BuildContext context) {
    

    ScrollController _scrollController = ScrollController();

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        list = await Character().getCharacters(60);
        setState(() {
         
          CharacterListBuild(scrollController: _scrollController, list: list,count: count,);
        });
      }
    });

    return Scaffold(
      body: Consumer<Character>(
        builder: (context, charactersDatas, child) {
          return CharacterListBuild(
              scrollController: _scrollController, list: list,count: count,);
        },
      ),
    );
  }
}

class CharacterListBuild extends StatelessWidget {
  const CharacterListBuild({
    Key key,
    @required ScrollController scrollController,
    @required this.list,
    this.count,
  })  : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;
  final List<Character> list;
  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView(
      addAutomaticKeepAlives: true,
      controller: _scrollController,
      children: 
        buildCharacterCard(list)
      ,
    );
  }
}

List<Card> buildCharacterCard(List<Character> characters) {
  List<Card> list = [];
  for (var character in characters) {
    var card = Card(
      child: ListTile(
    leading: SizedBox(
        height: 40,
        width: 40,
        child: CachedNetworkImage(
          imageUrl: character.imageUrl,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        )),
    title: Text(character.name),
  ));
  list.add(card);
  }
  return list;
  
}


// ListView.builder(
//       cacheExtent: 30,
//       controller: _scrollController,
//       itemCount: count,
//       itemBuilder: (context, index) {
//         print(index);
//         return buildCharacterCard(
//           list,
//           index,
//         );
//       },
//     );
