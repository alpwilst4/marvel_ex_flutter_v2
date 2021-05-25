import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'package:marvel_ex_flutter_v2/models/comics.dart';
import 'package:marvel_ex_flutter_v2/models/comics_with_dates.dart';

const start = "(";
const end = ")";

class DetailPage extends StatelessWidget {
  DetailPage(
      {this.name, this.description, this.imageUrl, this.index, this.comics});
  final String description;
  final String name;
  final String imageUrl;
  final String index;
  final List<Comics> comics;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Flexible(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Hero(tag: "image", child: Image.network(imageUrl)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 3,color: Colors.white70)),
                child: AnimatedTextKit(animatedTexts: [
                  TypewriterAnimatedText(name,
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Flexible(
                    child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                )),
              ),
              Expanded(
                child: ListView(
                  children: getComics(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Card> getComics() {
    List<ComicsWithDates> data = [];
    for (var comic in comics) {
      final startIndex = comic.name.indexOf(start);
      final endIndex = comic.name.indexOf(end, startIndex + start.length);
      int date = int.tryParse(
              comic.name.substring(startIndex + start.length, endIndex)) ??
          1000;
      data.add(ComicsWithDates(name: comic.name, date: date));
    }
    List reversed = selectionSort(data).reversed.toList();
    List<Card> ar = [];
    int i = 0;

    for (var item in reversed) {
      if (item.date > 2005 && i < 10) {
        ar.add(Card(
            child: ListTile(
                title: Text(
          item.name,
          style: TextStyle(fontSize: 12),
        ))));
        i++;
      }
    }
    return ar;
  }

  List selectionSort(List<ComicsWithDates> list) {
    if (list == null || list.length == 0) return list;
    int n = list.length;
    int i, steps;
    for (steps = 0; steps < n; steps++) {
      for (i = steps + 1; i < n; i++) {
        if (list[steps].date > list[i].date) {
          swap(list, steps, i);
        }
      }
    }
    return list;
  }

  void swap(List<ComicsWithDates> list, int steps, int i) {
    var temp = list[steps];
    list[steps] = list[i];
    list[i] = temp;
  }
}

// Container(
//                 padding: EdgeInsets.all(5),
//                 decoration: BoxDecoration(border: Border.all(width: 3,color: Colors.white70)),
//                 child: Text(name,
//                     style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white)),
//               ),
