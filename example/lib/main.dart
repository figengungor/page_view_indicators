import 'package:example/animated_circle_page_indicator_demo.dart';
import 'package:example/circle_page_indicator_demo2.dart';
import 'package:example/linear_progress_page_indicator_demo.dart';
import 'package:example/circle_page_indicator_demo.dart';
import 'package:example/arrow_page_indicator_demo.dart';
import 'package:example/arrow_page_indicator_demo2.dart';
import 'package:example/step_indicator_demo.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PageViewIndicators Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => HomePage(),
        '/circle_page_indicator_demo': (context) => CirclePageIndicatorDemo(),
        '/circle_page_indicator_demo2': (context) => CirclePageIndicatorDemo2(),
        '/animated_circle_page_indicator_demo': (context) =>
            AnimatedCirclePageIndicatorDemo(),
        '/arrow_page_indicator_demo': (context) => ArrowPageIndicatorDemo(),
        '/arrow_page_indicator_demo2': (context) => ArrowPageIndicatorDemo2(),
        '/linear_progress_page_indicator_demo': (context) =>
            LinearProgressPageIndicatorDemo(),
        '/step_page_indicator_demo': (context) => StepPageIndicatorDemo(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final _navItems = [
    NavItem('CirclePageIndicator Demo', '/circle_page_indicator_demo'),
    NavItem('CirclePageIndicator Demo 2(Loop)', '/circle_page_indicator_demo2'),
    NavItem('AnimatedCirclePageIndicator Demo',
        '/animated_circle_page_indicator_demo'),
    NavItem('ArrowPageIndicator Demo', '/arrow_page_indicator_demo'),
    NavItem('ArrowPageIndicator Demo2', '/arrow_page_indicator_demo2'),
    NavItem('LinearProgressPageIndicator Demo',
        '/linear_progress_page_indicator_demo'),
    NavItem('StepPageIndicator Demo', '/step_page_indicator_demo'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PageViewIndicators Demo'),
      ),
      body: _getNavButtons(context),
    );
  }

  _getNavButtons(BuildContext context) {
    return ListView(
      children: _navItems
          .map(
            (item) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(

                style: ElevatedButton.styleFrom( padding: EdgeInsets.all(8.0),
                  primary: Colors.green,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, item.routeName);
                },
                child: Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class NavItem {
  final title;
  final routeName;

  NavItem(this.title, this.routeName);
}
