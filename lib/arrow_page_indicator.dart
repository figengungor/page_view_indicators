import 'package:flutter/material.dart';

//https://stackoverflow.com/questions/51119795/how-to-remove-scroll-glow

class ArrowPageIndicator extends StatefulWidget {
  /// [PageController] of the [child] to control pages and transition.
  final PageController pageController;

  /// The current page index ValueNotifier
  /// [child] should notify when onPageChanged is triggered.
  final ValueNotifier<int> currentPageNotifier;

  /// The [PageView] that is used with this indicator
  /// It has the same [pageController] and
  /// Notifies indicator with [currentPageNotifier]
  final Widget child;

  /// The number of items managed by the PageController
  final int itemCount;

  /// The custom right icon widget
  /// Could be a [Icon], [Text] or [Image]. Go crazy.
  final Widget? rightIcon;

  /// The custom left icon widget
  /// Could be a [Icon], [Text] or [Image]. Go crazy.
  final Widget? leftIcon;

  ///The size of default right and left [Icon]
  final double iconSize;

  ///The color of default right and left [Icon]
  final Color? iconColor;

  ///The padding of default right and left [Icon]
  final EdgeInsetsGeometry iconPadding;

  /// The duration of page transition
  /// Used if [isJump] is set to false
  final int duration;

  /// The curve of page transition
  /// Used if [isJump] is set to false
  final Curve curve;

  /// If set to [True], page transition happens without animation.
  /// Otherwise, page transition happens with animation specified
  ///with [duration] and [curve]
  final bool isJump;

  /// If set to [True], left and right arrows is on the [child]
  /// Otherwise [child] is placed between them.
  final bool isInside;

  /// Semantic label for default left [Icon]
  final String? tooltipLeft;

  /// Semantic label for default right [Icon]
  final String? tooltipRight;

  static const defaultIconSize = 46.0;

  static const defaultDuration = 300;

  static const defaultCurve = Curves.easeOut;

  static const defaultPadding = EdgeInsets.all(8.0);

  const ArrowPageIndicator({
    Key? key,
    required this.pageController,
    required this.currentPageNotifier,
    required this.itemCount,
    required this.child,
    this.rightIcon,
    this.leftIcon,
    this.iconColor,
    this.iconPadding = defaultPadding,
    this.duration = defaultDuration,
    this.curve = defaultCurve,
    this.isJump = false,
    this.isInside = false,
    this.iconSize = defaultIconSize,
    this.tooltipLeft,
    this.tooltipRight,
  }) : super(key: key);

  @override
  ArrowPageIndicatorState createState() {
    return new ArrowPageIndicatorState();
  }
}

class ArrowPageIndicatorState extends State<ArrowPageIndicator> {
  var _pageIndex = 0;

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
  Widget build(BuildContext context) => _buildBody();

  _buildArrow(
          {Widget? icon, IconData? iconData, bool? isLeft, required bool isNotVisible}) =>
      Opacity(
        opacity: isNotVisible ? 0.0 : 1.0,
        child: GestureDetector(
          child: Padding(
            padding: widget.iconPadding,
            child: icon ??
                Icon(
                  iconData,
                  color: widget.iconColor,
                  size: widget.iconSize,
                  semanticLabel:
                      isLeft! ? widget.tooltipLeft : widget.tooltipRight,
                ),
          ),
          onTap: isNotVisible==true
              ? null
              : () {
                  widget.isJump
                      ? widget.pageController
                          .jumpToPage(isLeft! ? _pageIndex - 1 : _pageIndex + 1)
                      : isLeft!
                          ? widget.pageController.previousPage(
                              duration: Duration(milliseconds: widget.duration),
                              curve: widget.curve)
                          : widget.pageController.nextPage(
                              duration: Duration(milliseconds: widget.duration),
                              curve: widget.curve);
                },
        ),
      );

  _buildLeftArrow() => _buildArrow(
      icon: widget.leftIcon,
      iconData: Icons.chevron_left,
      isNotVisible: isFirstPage(),
      isLeft: true);

  _buildRightArrow() => _buildArrow(
      icon: widget.rightIcon,
      iconData: Icons.chevron_right,
      isNotVisible: isLastPage(),
      isLeft: false);

  _buildPageView() => ScrollConfiguration(
        child: widget.child,
        behavior: NoGlowBehaviour(),
      );

  _buildBody() => widget.isInside ? _buildBodyWithStack() : _buildBodyWithRow();

  _buildBodyWithStack() => Stack(
        children: <Widget>[
          _buildPageView(),
          Positioned(
            left: 0.0,
            top: 0.0,
            bottom: 0.0,
            child: _buildLeftArrow(),
          ),
          Positioned(
            right: 0.0,
            top: 0.0,
            bottom: 0.0,
            child: _buildRightArrow(),
          ),
        ],
      );

  _buildBodyWithRow() => Row(
        children: <Widget>[
          _buildLeftArrow(),
          Expanded(
            child: _buildPageView(),
          ),
          _buildRightArrow(),
        ],
      );

  bool isFirstPage() => _pageIndex == 0;

  bool isLastPage() => _pageIndex == widget.itemCount - 1;

  _handlePageIndex() {
    setState(_readCurrentPageIndex);
  }

  _readCurrentPageIndex() {
    _pageIndex = widget.currentPageNotifier.value;
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
