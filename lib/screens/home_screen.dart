import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marvel_ex_flutter_v2/models/character.dart';
import 'package:marvel_ex_flutter_v2/models/comics.dart';
import 'package:provider/provider.dart';

import 'detail_page.dart';

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
        List list2 = await Character().getCharacters(count+30);
        
        setState(() {
          count = count+30;
         list = list+list2;
          CharacterListBuild(scrollController: _scrollController, list: list,count: count,);
        });
      }
    });

    return Scaffold(
      appBar: AppBar(),
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
    return ListView.builder(
      addRepaintBoundaries: false,
      cacheExtent: 30,
      controller: _scrollController,
      itemCount: count,
      itemBuilder: (context, index) {
        print(index);
        return buildCharacterCard(context,
          list,
          index,
        );
      },
    );
  }
}

Widget buildCharacterCard(BuildContext context,List<Character> characters, int index) {
  return GestureDetector(
    onTap: () async {
        Comics comic = Comics();
        List<Comics> newStyle =
            await comic.getComicDatas(jsonEncode(characters[index].comics));

        //print(newStyle[0].name);

        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(
                      name: characters[index].name,
                      imageUrl: characters[index].imageUrl,
                      description: characters[index].description,
                      comics: newStyle,
                    )));
      },
      child: Card(
        child: ListTile(
      leading: SizedBox(
          height: 40,
          width: 40,
          child: Hero(
                      tag: "image",
                      child: CachedNetworkImage(
              imageUrl: characters[index].imageUrl,
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
            ),
          )),
      title: Text(characters[index].name),
    )),
  );
}
