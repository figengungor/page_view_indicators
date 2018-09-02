import 'package:flutter/material.dart';
import 'package:page_view_indicators/arrow_page_indicator.dart';

class ArrowPageIndicatorDemo extends StatefulWidget {
  @override
  ArrowPageIndicatorDemoState createState() {
    return new ArrowPageIndicatorDemoState();
  }
}

class ArrowPageIndicatorDemoState extends State<ArrowPageIndicatorDemo> {
  final _items = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.pink,
  ];
  final _pageController = PageController();
  final _pageController2 = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _currentPageNotifier2 = ValueNotifier<int>(0);
  final _boxHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ArrowPageIndicator Demo'),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() => ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          Text('isInside:false [Arrows in row], isJump: true'),
          ArrowPageIndicator(
            isJump: true,
            pageController: _pageController,
            currentPageNotifier: _currentPageNotifier,
            itemCount: _items.length,
            child: _buildPageView(_pageController, _currentPageNotifier),
          ),
          Text('isInside:true [Arrows in stack], isJump:false, custom icons'),
          ArrowPageIndicator(
            iconPadding: EdgeInsets.symmetric(horizontal: 16.0),
            isInside: true,
            leftIcon: Image.asset(
              "assets/images/left_arrow.png",
              width: 46.0,
              height: 46.0,
            ),
            rightIcon: Image.asset(
              "assets/images/right_arrow.png",
              width: 46.0,
              height: 46.0,
            ),
            /* rightIcon: Icon(
              Icons.arrow_right,
              color: Colors.white,
              size: 90.0,
            ),
            leftIcon: Icon(
              Icons.arrow_left,
              color: Colors.white,
              size: 90.0,
            ),*/
            pageController: _pageController2,
            currentPageNotifier: _currentPageNotifier2,
            itemCount: _items.length,
            child: _buildPageView(_pageController2, _currentPageNotifier2),
          ),
        ]
            .map((item) => Padding(
                  child: item,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ))
            .toList(),
      );

  _buildPageView(
          PageController pageController, ValueNotifier currentPageNotifier) =>
      Container(
        color: Colors.black,
        height: _boxHeight,
        child: PageView.builder(
            itemCount: _items.length,
            controller: pageController,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: FlutterLogo(
                  colors: _items[index],
                  size: 75.0,
                ),
              );
            },
            onPageChanged: (int index) {
              currentPageNotifier.value = index;
            }),
      );
}
