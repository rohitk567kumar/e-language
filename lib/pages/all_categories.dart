import 'package:e_language/pages/home.dart';
import 'package:flutter/material.dart';

class AllCotegories extends StatefulWidget {
  const AllCotegories({super.key});

  @override
  State<AllCotegories> createState() => _AllCotegoriesState();
}

class _AllCotegoriesState extends State<AllCotegories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
            backgroundColor: Colors.green.shade700,
            elevation: 5,
            title: Text(
              ("All Categories").toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: Colors.white),
            ),
            centerTitle: true),
        body: Column(
          children: [
            ListOfCategory(minusVariable: 0),
          ],
        ));
  }
}
