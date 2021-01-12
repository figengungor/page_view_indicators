import 'package:flutter/material.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class StepPageIndicatorDemo extends StatefulWidget {
  @override
  _StepPageIndicatorDemoState createState() {
    return _StepPageIndicatorDemoState();
  }
}

class _StepPageIndicatorDemoState extends State<StepPageIndicatorDemo> {
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StepPageIndicator Demo'),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildStepIndicator(),
        _buildPageView(),
      ],
    );
  }

  _buildPageView() {
    return Expanded(
      child: PageView.builder(
        itemCount: 8,
        controller: _pageController,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Text(
              'Step ${index + 1}',
              style: Theme.of(context).textTheme.headline4,
            ),
          );
        },
        onPageChanged: (int index) {
          _currentPageNotifier.value = index;
        },
      ),
    );
  }

  _buildStepIndicator() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16.0),
      child: StepPageIndicator(
        itemCount: 8,
        currentPageNotifier: _currentPageNotifier,
        size: 16,
        onPageSelected: (int index) {
          if (_currentPageNotifier.value > index)
            _pageController.jumpToPage(index);
        },
      ),
    );
  }
}
