import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/Models/categoryModel.dart';
import 'package:movies_app/Models/movieModel.dart';
import 'package:movies_app/Widgets/movieTile.dart';

class HomePage extends ConsumerWidget {
  late double _deviceHeight, _deviceWidth;
  final TextEditingController _searchTextFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // use it if u get overflow pixels when the keyboard appears
      backgroundColor: Colors.black,
      body: Container(
        height: _deviceHeight,
        width: _deviceWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _backgroundWidget(),
            _foregroundWidgets(),
          ],
        ),
      ),
    );
  }

  Widget _backgroundWidget() {
    return Container(
      height: _deviceHeight,
      width: _deviceWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
            image: NetworkImage(
                "https://assets-prd.ignimgs.com/2022/07/21/oppenheimer-poster-1658411601593.jpeg?fit=bounds&width=1280&height=720"),
            fit: BoxFit.fill),
      ),
      // Add Blur Filter For the Image
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          color: Colors.black.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _foregroundWidgets() {
    return SafeArea(
      child: Container(
        width: _deviceWidth * 0.88,
        padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _topBarWidget(),
            Container(
              height: _deviceHeight * 0.84,
              padding: EdgeInsets.only(top: _deviceHeight * 0.02),
              child: _moviesListViewWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBarWidget() {
    return Container(
      height: _deviceHeight * 0.08,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _searchFieldWidget(),
          _categorySelectionWidget(),
        ],
      ),
    );
  }

  Widget _searchFieldWidget() {
    const border = InputBorder.none; // remove border from EditText
    return Container(
      width: _deviceWidth * 0.5,
      child: TextField(
        controller: _searchTextFieldController,
        onSubmitted: (input) {},
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
            focusedBorder: border,
            border: border,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white54,
            ),
            hintStyle: TextStyle(color: Colors.white54),
            filled: false,
            fillColor: Colors.white24,
            hintText: "Search...."),
      ),
    );
  }

  Widget _categorySelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: CategoryModel.popular,
      icon: const Icon(Icons.menu, color: Colors.white24),
      underline: Container(),
      items: [
        DropdownMenuItem(
          child:
              Text(CategoryModel.none, style: TextStyle(color: Colors.white24)),
          value: CategoryModel.none,
        ),
        DropdownMenuItem(
          child: Text(CategoryModel.popular,
              style: TextStyle(color: Colors.white24)),
          value: CategoryModel.popular,
        ),
        DropdownMenuItem(
          child: Text(CategoryModel.upcoming,
              style: TextStyle(color: Colors.white24)),
          value: CategoryModel.upcoming,
        ),
      ],
      onChanged: (value) {},
    );
  }

  Widget _moviesListViewWidget() {
    final List<MovieModel> movies = [];
    for (var i = 0; i < 20; i++) {
      movies.add(MovieModel(
          name: "Barbie",
          language: "en",
          isAdult: false,
          description:
              "Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land. However, when they get a chance to go to the real world, they soon discover the joys and perils of living among humans.",
          posterPath: "/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg",
          backgroundPath: "/tTfnd2VrlaZJSBD9HUbtSF3CqPJ.jpg",
          rating: 7.5,
          releaseDate: "2023-07-19"));
    }
    if (movies.isNotEmpty) {
      return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: _deviceHeight * 0.01, horizontal: 0),
            child: GestureDetector(
              onTap: () {},
              child: MovieTile(
                  movie: movies[index],
                  height: _deviceHeight * 0.2,
                  width: _deviceWidth * 0.88),
            ),
          );
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(backgroundColor: Colors.white),
      );
    }
  }
}
