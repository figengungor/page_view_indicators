import 'package:flutter/material.dart';
import 'package:page_view_indicators/animated_circle_page_indicator.dart';

class AnimatedCirclePageIndicatorDemo extends StatefulWidget {
  @override
  AnimatedCirclePageIndicatorDemoState createState() {
    return new AnimatedCirclePageIndicatorDemoState();
  }
}

class AnimatedCirclePageIndicatorDemoState
    extends State<AnimatedCirclePageIndicatorDemo> {
  final _items = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.pink,
    Colors.red,
    Colors.amber,
    Colors.brown,
    Colors.yellow,
    Colors.blue,
  ];
  final _pageController = PageController(initialPage: 2);
  final _currentPageNotifier = ValueNotifier<int>(2);
  final _boxHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AnimatedCirclePageIndicator Demo'),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            _buildPageView(),
            _buildCircleIndicator(),
          ],
        ),
      ],
    );
  }

  _buildPageView() {
    return Container(
      color: Colors.black87,
      height: _boxHeight,
      child: PageView.builder(
          itemCount: _items.length,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: FlutterLogo(
                colors: _items[index],
                size: 50.0,
              ),
            );
          },
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          }),
    );
  }

  _buildCircleIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedCirclePageIndicator(
          itemCount: _items.length,
          currentPageNotifier: _currentPageNotifier,
          borderWidth: 2,
          spacing: 6,
          radius: 8,
          activeRadius: 6,
        ),
      ),
    );
  }
}
