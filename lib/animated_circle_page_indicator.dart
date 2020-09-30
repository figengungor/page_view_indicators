import 'package:flutter/material.dart';

class AnimatedCirclePageIndicator extends StatefulWidget {
  /// the current page index ValueNotifier
  final ValueNotifier<int> currentPageNotifier;

  /// the number of items managed by the PageController
  final int itemCount;

  /// circle radius
  final double radius;

  /// circle border width
  final double borderWidth;

  /// radius of the inner circle that becomes visible when selected
  final double activeRadius;

  /// the horizontal space between circles
  final double spacing;

  /// the fill color of circle
  final Color fillColor;

  /// the border color of circle
  final Color borderColor;

  /// the color of inner circle that becomes visible when selected
  final Color activeColor;

  /// the padding of this widget
  final EdgeInsets padding;

  /// the active circle animation duration (selected/unselected)
  final Duration duration;

  const AnimatedCirclePageIndicator({
    Key key,
    @required this.currentPageNotifier,
    @required this.itemCount,
    @required this.radius,
    this.borderWidth = 0,
    this.activeRadius,
    this.spacing = 4,
    this.fillColor = const Color(0xFF4C4C4C),
    this.borderColor = Colors.white,
    this.activeColor = Colors.white,
    this.padding,
    this.duration = const Duration(milliseconds: 200),
  })  : assert(radius != null && radius > 0,
            'No radius, no circle pal, give non-zero radius'),
        assert(radius > activeRadius,
            'No pal, activeRadius can not be bigger than radius'),
        super(key: key);

  @override
  _AnimatedCircleIndicatorState createState() =>
      _AnimatedCircleIndicatorState();
}

class _AnimatedCircleIndicatorState extends State<AnimatedCirclePageIndicator> {
  int _currentIndex;

  @override
  void initState() {
    _readCurrentPageIndex();
    widget.currentPageNotifier.addListener(_handlePageIndex);
    super.initState();
  }

  @override
  void dispose() {
    widget.currentPageNotifier.removeListener(_handlePageIndex);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          for (int i = 0; i < widget.itemCount; i++)
            Padding(
              padding: EdgeInsets.only(left: widget.spacing),
              child: _Circle(
                radius: widget.radius,
                borderWidth: widget.borderWidth,
                fillColor: widget.fillColor,
                borderColor: widget.borderColor,
                activeColor: widget.activeColor,
                activeRadius: widget.activeRadius,
                isSelected: _isSelected(i),
                duration: widget.duration,
              ),
            )
        ],
      ),
    );
  }

  bool _isSelected(int index) {
    return index == _currentIndex;
  }

  void _handlePageIndex() {
    setState(_readCurrentPageIndex);
  }

  _readCurrentPageIndex() {
    _currentIndex = widget.currentPageNotifier.value;
  }
}

class _Circle extends StatefulWidget {
  final double radius;
  final double borderWidth;
  final Color fillColor;
  final Color borderColor;
  final Color activeColor;
  final double activeRadius;
  final bool isSelected;
  final Duration duration;

  const _Circle({
    Key key,
    @required this.radius,
    this.borderWidth,
    this.fillColor,
    this.borderColor,
    this.activeColor,
    double activeRadius,
    this.isSelected = false,
    this.duration,
  })  : this.activeRadius = activeRadius ?? radius / 2,
        super(key: key);

  @override
  _CircleState createState() => _CircleState();
}

class _CircleState extends State<_Circle> with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  bool _isSelectedPreviously;

  @override
  void didUpdateWidget(_Circle oldWidget) {
    if (oldWidget.isSelected != widget.isSelected) {
      _handleAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _handleAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, snapshot) {
          return SizedBox(
            width: widget.radius * 2,
            height: widget.radius * 2,
            child: CustomPaint(
              painter: _CirclePainter(widget.radius,
                  borderWidth: widget.borderWidth,
                  fillColor: widget.fillColor,
                  borderColor: widget.borderColor,
                  activeColor: widget.activeColor,
                  activeCircleRadius: _animation?.value ?? 0),
            ),
          );
        });
  }

  _handleAnimation() {
    Tween<double> _radiusTween;
    if (widget.isSelected) {
      _radiusTween = Tween(begin: 0.0, end: widget.radius / 2);
    } else if (_isSelectedPreviously == true && widget.isSelected == false) {
      _radiusTween = Tween(begin: widget.radius / 2, end: 0.0);
    } else {
      _radiusTween = Tween(begin: 0.0, end: 0.0);
    }

    _animation = _radiusTween.animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.reset();
    _controller.forward();
    _isSelectedPreviously = widget.isSelected;
  }
}

class _CirclePainter extends CustomPainter {
  final double radius;
  final double borderWidth;
  final Color fillColor;
  final Color borderColor;
  final Color activeColor;
  final double activeCircleRadius;

  _CirclePainter(
    this.radius, {
    this.borderWidth,
    this.fillColor,
    this.borderColor,
    this.activeColor,
    this.activeCircleRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint fillPaint = Paint()
      ..color = fillColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    Paint borderPaint = Paint()
      ..color = borderColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    Paint activePaint = Paint()
      ..color = activeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      size.center(Offset.zero),
      radius,
      fillPaint,
    );
    if (borderWidth > 0)
      canvas.drawCircle(
        size.center(Offset.zero),
        radius,
        borderPaint,
      );
    canvas.drawCircle(
      size.center(Offset.zero),
      activeCircleRadius,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) =>
      oldDelegate.radius != radius ||
      oldDelegate.borderWidth != borderWidth ||
      oldDelegate.fillColor != fillColor ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.activeColor != activeColor ||
      oldDelegate.activeCircleRadius != activeCircleRadius;
}
