import 'package:flutter/material.dart';
import 'package:page_view_indicators/arrow_page_indicator.dart';

class ArrowPageIndicatorDemo2 extends StatefulWidget {
  @override
  ArrowPageIndicatorDemo2State createState() {
    return new ArrowPageIndicatorDemo2State();
  }
}

class ArrowPageIndicatorDemo2State extends State<ArrowPageIndicatorDemo2> {
  final _items = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.pink,
  ];
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _boxHeight = 150.0;

  String _text='';

  @override
  void initState() {
    _text = _items[0].toString();
    _currentPageNotifier.addListener(_handlePageChange);
    super.initState();
  }

  @override
  void dispose() {
    _currentPageNotifier.removeListener(_handlePageChange);
    super.dispose();
  }

  _handlePageChange() {
      setState(() {
        _text = _items[_currentPageNotifier.value].toString();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ArrowPageIndicator Demo 2'),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() =>
          Column(
            children: <Widget>[
              ArrowPageIndicator(
                isJump: true,
                pageController: _pageController,
                currentPageNotifier: _currentPageNotifier,
                itemCount: _items.length,
                child: Text(_text),
              ),
              _buildPageView(_pageController, _currentPageNotifier)
            ],
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
