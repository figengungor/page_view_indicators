import 'package:flutter/material.dart';

//https://gist.github.com/collinjackson/4fddbfa2830ea3ac033e34622f278824

class CirclePageIndicator extends StatefulWidget {
  static const double _defaultSize = 8.0;
  static const double _defaultSelectedSize = 8.0;
  static const double _defaultSpacing = 8.0;
  static const Color _defaultDotColor = const Color(0x509E9E9E);
  static const Color _defaultSelectedDotColor = Colors.grey;

  /// The current page index ValueNotifier
  final ValueNotifier<int> currentPageNotifier;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int>? onPageSelected;

  ///The dot color
  final Color dotColor;

  ///The selected dot color
  final Color selectedDotColor;

  ///The normal dot size
  final double size;

  ///The selected dot size
  final double selectedSize;

  ///The space between dots
  final double dotSpacing;

  ///The border width of the indicator
  final double borderWidth;

  ///The borderColor is set to dotColor if not set
  final Color? borderColor;

  ///The selectedBorderColor is set to selectedDotColor if not set
  final Color? selectedBorderColor;

  CirclePageIndicator({
    Key? key,
    required this.currentPageNotifier,
    required this.itemCount,
    this.onPageSelected,
    this.size = _defaultSize,
    this.dotSpacing = _defaultSpacing,
    Color? dotColor,
    Color? selectedDotColor,
    this.selectedSize = _defaultSelectedSize,
    this.borderWidth = 0,
    this.borderColor,
    this.selectedBorderColor,
  })  : this.dotColor = dotColor ??
            ((selectedDotColor?.withAlpha(150)) ?? _defaultDotColor),
        this.selectedDotColor = selectedDotColor ?? _defaultSelectedDotColor,
        assert(borderWidth < size,
            'Border width cannot be bigger than dot size, duh!'),
        super(key: key);

  @override
  CirclePageIndicatorState createState() {
    return new CirclePageIndicatorState();
  }
}

class CirclePageIndicatorState extends State<CirclePageIndicator> {
  int _currentPageIndex = 0;
  Color? _borderColor;
  Color? _selectedBorderColor;

  @override
  void initState() {
    _readCurrentPageIndex();
    widget.currentPageNotifier.addListener(_handlePageIndex);
    _borderColor = widget.borderColor ?? widget.dotColor;
    _selectedBorderColor =
        widget.selectedBorderColor ?? widget.selectedDotColor;
    super.initState();
  }

  @override
  void dispose() {
    widget.currentPageNotifier.removeListener(_handlePageIndex);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: List<Widget>.generate(widget.itemCount, (int index) {
          double size = widget.size;
          Color color = widget.dotColor;
          Color? borderColor = _borderColor;
          if (isSelected(index)) {
            size = widget.selectedSize;
            color = widget.selectedDotColor;
            borderColor = _selectedBorderColor;
          }
          return GestureDetector(
            onTap: () => widget.onPageSelected == null
                ? null
                : widget.onPageSelected!(index),
            child: Container(
              width: size + widget.dotSpacing,
              child: Material(
                color: widget.borderWidth > 0 ? borderColor : color,
                type: MaterialType.circle,
                child: Container(
                  width: size,
                  height: size,
                  child: Center(
                    child: Material(
                      type: MaterialType.circle,
                      color: color,
                      child: Container(
                        width: size - widget.borderWidth,
                        height: size - widget.borderWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }));
  }

  bool isSelected(int dotIndex) => _currentPageIndex == dotIndex;

  _handlePageIndex() {
    setState(_readCurrentPageIndex);
  }

  _readCurrentPageIndex() {
    _currentPageIndex = widget.currentPageNotifier.value;
  }
}
