import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_app/Controllers/mainPageDataController.dart';
import 'package:movies_app/Models/categoryModel.dart';
import 'package:movies_app/Models/mainPageData.dart';
import 'package:movies_app/Models/movieModel.dart';
import 'package:movies_app/Widgets/movieTile.dart';

// Declare MainPageData provider
final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>(
  (ref) {
    return MainPageDataController();
  },
);
// PosterURL provider
final selectedMoviePosterURLProvider = StateProvider<String>(
  (ref) {
    //get movies
    final movies =
        ref.watch(mainPageDataControllerProvider).movies;
    // set first value of PosterURL
    return movies!.isNotEmpty
        ? movies[0].posterURL()
        : '';
  },
);

class HomePage extends ConsumerWidget {
  late double _deviceHeight, _deviceWidth;
  late MainPageDataController _mainPageDataController;
  late MainPageData _mainPageData;
  final TextEditingController _searchTextFieldController =
      TextEditingController();
  late WidgetRef widgetRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    // watch the instance of MainPageDataController
    _mainPageDataController =
        ref.watch(mainPageDataControllerProvider.notifier);
    // watch the instance of MainPageData
    _mainPageData = ref.watch(mainPageDataControllerProvider);

    // init the WidgetRef to use it in other Widgets
    widgetRef = ref;

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
    // read the state of Poster URL
    final selectedPosterURl = widgetRef.watch(selectedMoviePosterURLProvider);
    if (selectedPosterURl != '') {
      return Container(
        height: _deviceHeight,
        width: _deviceWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
              image: NetworkImage(selectedPosterURl), fit: BoxFit.fill),
        ),
        // Add Blur Filter For the Image
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: Colors.black.withOpacity(0.4),
          ),
        ),
      );
    } else {
      return Container(
        height: _deviceHeight,
        width: _deviceWidth,
        color: Colors.black,
      );
    }
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
        onChanged: (value) {
          _mainPageDataController.updateTextSearch(value);
        },
        onSubmitted: (input) {
          _mainPageDataController.updateTextSearch(input);
        },
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
      dropdownColor: Colors.black87,
      value: _mainPageData.searchCategory,
      icon: const Icon(Icons.menu, color: Colors.white38),
      underline: Container(),
      items: [
        DropdownMenuItem(
          child: Text(CategoryModel.none),
          value: CategoryModel.none,
        ),
        DropdownMenuItem(
          child: Text(CategoryModel.popular,
              style: TextStyle(color: Colors.white38)),
          value: CategoryModel.popular,
        ),
        DropdownMenuItem(
          child: Text(CategoryModel.upcoming,
              style: TextStyle(color: Colors.white38)),
          value: CategoryModel.upcoming,
        ),
      ],
      onChanged: (value) => value.toString().isNotEmpty
          ? _mainPageDataController.updateSearchCategory(value.toString())
          : null,
    );
  }

  Widget _moviesListViewWidget() {
    final List<MovieModel>? movies = _mainPageData.movies;
    if (movies!.isNotEmpty) {
      return NotificationListener(
        // Active Infinite Scroll for getting more movies
        onNotification: (onScrollNotification) {
          if (onScrollNotification is ScrollEndNotification) {
            final before = onScrollNotification.metrics.extentBefore;
            final max = onScrollNotification.metrics.maxScrollExtent;
            if (before == max) {
              _mainPageDataController.getMovies();
              return true;
            }
            return false;
          }
          return false;
        },
        child: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: _deviceHeight * 0.01, horizontal: 0),
              child: GestureDetector(
                onTap: () {
                  // change the state of Poster URL
                  widgetRef
                      .read(selectedMoviePosterURLProvider.notifier)
                      .state = movies[index].posterURL();
                },
                child: MovieTile(
                    movie: movies[index],
                    height: _deviceHeight * 0.2,
                    width: _deviceWidth * 0.88),
              ),
            );
          },
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(backgroundColor: Colors.white),
      );
    }
  }
}
