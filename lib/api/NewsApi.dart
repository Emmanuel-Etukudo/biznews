import 'dart:convert';
import 'dart:io';

import 'package:biznews/model/model.dart';
import 'package:biznews/util/failure.dart';
import 'package:http/http.dart' as http;

class NewsApi {
  Future<List<Articles>?> getNews() async {
    try {
      final call = await http.get(Uri.parse(
          "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=7321501a62d34b5d840a2854be86d94a"));
      if (call.statusCode == 200) {
        final json = jsonDecode(call.body);
        return NewsModel.fromJson(json).articles;
      } else if (call.statusCode != 200) {
        throw Failure(message: "Check URL");
      }
    } on SocketException {
      throw Failure(message: "You are not connected to the internet. Why :(");
    } catch (e) {
      throw Failure(message: "An unknown error occurred");
    }
  }
}
