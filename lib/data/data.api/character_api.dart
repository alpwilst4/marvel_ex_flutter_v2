import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

const privateKey = "588b317f5ff26f07f6d12ff7cdf058552d7664e9";
const publicKey = "41a73cf475e65559db98277c9910298b";

class CharacterApi {
  Future<dynamic> getCharactersFromApi(int limit) async {
    var ts = DateTime.now().millisecondsSinceEpoch;
    var completedKey = ts.toString() + privateKey + publicKey;
    var hash = md5.convert(utf8.encode(completedKey)).toString();
    print(
        "https://gateway.marvel.com/v1/public/characters?ts=$ts&apikey=$publicKey&hash=$hash&limit=30");
    var data = await http.get(Uri.parse(
        "https://gateway.marvel.com/v1/public/characters?ts=$ts&apikey=$publicKey&hash=$hash&limit=30&limit=${limit}&offset=${limit-30}"));
        

        

    return data;
  }
}
