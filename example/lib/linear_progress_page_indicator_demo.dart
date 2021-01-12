import 'package:flutter/material.dart';
import 'package:page_view_indicators/linear_progress_page_indicator.dart';

class LinearProgressPageIndicatorDemo extends StatefulWidget {
  @override
  _LinearProgressPageIndicatorDemoState createState() {
    return _LinearProgressPageIndicatorDemoState();
  }
}

class _LinearProgressPageIndicatorDemoState
    extends State<LinearProgressPageIndicatorDemo> {
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
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _boxHeight = 300.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LinearProgressPageIndicator Demo'),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildPageView(),
        _buildLinearProgressIndicator(),
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
                textColor: _items[index],
                size: 50.0,
              ),
            );
          },
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          }),
    );
  }

  _buildLinearProgressIndicator() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          LinearProgressPageIndicator(
            itemCount: _items.length,
            currentPageNotifier: _currentPageNotifier,
            progressColor: Colors.green,
            width: constraints.maxWidth,
            height: 30,
          ),
    );
  }
}
