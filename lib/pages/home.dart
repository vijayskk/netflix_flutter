// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List? movies;

  getMovies() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      movies = sp.getStringList('movies');
    });
  }

  @override
  Widget build(BuildContext context) {
    getMovies();
    if (movies != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
          children: movies!
              .map((e) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 0, right: 8, left: 20),
                        child: Text(
                          jsonDecode(e)["name"],
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ),
                      MovieRow(
                        data: jsonDecode(e)["rowmovies"],
                      ),
                    ],
                  ))
              .toList(),
        ),
      );
    } else {
      return Scaffold(
          body: Center(
        child: Text("Error"),
      ));
    }
  }
}

class MovieRow extends StatelessWidget {
  Map data;
  MovieRow({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List list = data["results"];
    return Container(
      width: double.infinity,
      height: 300,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list
            .map((e) => RowImage(
                  image: e["poster_path"],
                ))
            .toList(),
      ),
    );
  }
}

class RowImage extends StatelessWidget {
  String? image;
  RowImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 0, bottom: 20),
      child: Container(
        width: 150,
        height: 200,
        child: Image.network(
          "https://image.tmdb.org/t/p/w185$image",
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CupertinoActivityIndicator(
                radius: 30,
                animating: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
