import 'package:flutter/material.dart';

class LinearProgressPageIndicator extends StatefulWidget {
  /// The current page index ValueNotifier
  final ValueNotifier<int> currentPageNotifier;

  /// The width of indicator
  final double width;

  /// The height of indicator
  final double height;

  /// The number of pages
  final int itemCount;

  /// The duration of the progress animation
  final Duration duration;

  /// The progress color of the indicator
  final Color progressColor;

  /// The background color of the indicator
  final Color backgroundColor;

  const LinearProgressPageIndicator({
    Key key,
    @required this.currentPageNotifier,
    @required this.width,
    @required this.height,
    @required this.itemCount,
    @required this.progressColor,
    this.backgroundColor,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  _LinearProgressPageIndicatorState createState() =>
      _LinearProgressPageIndicatorState();
}

class _LinearProgressPageIndicatorState
    extends State<LinearProgressPageIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _sizeTween;
  double width;
  double previousWidth;
  double nextWidth;
  double stepWidth;
  int itemCount;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animationController.addListener(() => setState(() {}));

    width = widget.width;
    itemCount = widget.itemCount;
    stepWidth = width / itemCount;
    previousWidth = 0;
    
    _onCurrentPageNotifierValueChanged();
    widget.currentPageNotifier.addListener(_onCurrentPageNotifierValueChanged);

    super.initState();
  }

  @override
  void dispose() {
    widget.currentPageNotifier.removeListener(_onCurrentPageNotifierValueChanged);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: CustomPaint(
        painter: ProgressPainter(_sizeTween, widget.height, widget.width,
            widget.progressColor, widget.backgroundColor),
      ),
    );
  }

  _onCurrentPageNotifierValueChanged()
  {
    _readCurrentPageNotifierValue();
    _resetAnimation();
  }

  _readCurrentPageNotifierValue() {
      nextWidth = stepWidth * (widget.currentPageNotifier.value + 1);
      _sizeTween = Tween(begin: previousWidth, end: nextWidth)
          .animate(_animationController);
      previousWidth = nextWidth;
  }

  _resetAnimation() {
      _animationController.reset();
      _animationController.forward();
  }
}

class ProgressPainter extends CustomPainter {
  Paint bgPaint;
  Paint progressPaint;
  final Animation<double> value;
  final double height;
  final double width;
  final Color progressColor;
  final Color backgroundColor;

  ProgressPainter(this.value, this.height, this.width, this.progressColor,
      this.backgroundColor) {
    bgPaint = Paint()..color = backgroundColor ?? progressColor.withAlpha(90);
    progressPaint = Paint()..color = progressColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect myRect = Offset(0.0, 0.0) & Size(value.value, height);
    Rect bgRect = Offset(0.0, 0.0) & Size(width, height);
    canvas.drawRect(bgRect, bgPaint);
    canvas.drawRect(myRect, progressPaint);
  }

  @override
  bool shouldRepaint(ProgressPainter oldDelegate) {
    return true;
  }
}
