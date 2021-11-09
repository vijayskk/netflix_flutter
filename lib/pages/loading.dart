// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void getdata(BuildContext context) async {
    Response res = await get(Uri.parse(
        "https://api.themoviedb.org/3/genre/movie/list?api_key=bac63f0b426881aff0bc5d4cb4ed4f72&language=en-US"));
    Map resjson = jsonDecode(res.body);
    List generedata = resjson["genres"];
    List<String> finaldata = [];
    for (var i = 0; i < generedata.length; i++) {
      Response mov = await get(Uri.parse(
          "https://api.themoviedb.org/3/discover/movie?with_genres=${generedata[i]["id"]}&api_key=bac63f0b426881aff0bc5d4cb4ed4f72&language=en-US"));
      Map movies = jsonDecode(mov.body);
      String id = generedata[i]["name"].toString();
      String data = jsonEncode({"name": id, "rowmovies": movies});
      finaldata.add(data);
    }
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool status = await sp.setStringList('movies', finaldata);
    if (status) {
      Navigator.of(context).pushNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    getdata(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          "assets/netflix.gif",
          width: double.infinity,
        ),
      ),
    );
  }
}
