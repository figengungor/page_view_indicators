import 'package:flutter/material.dart';

class StepPageIndicator extends StatefulWidget {
  static const double _defaultSize = 8.0;
  static const double _defaultSpacing = 8.0;
  static const Color _defaultStepColor = Colors.green;

  /// The current page index ValueNotifier
  final ValueNotifier<int> currentPageNotifier;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a step is tapped
  final ValueChanged<int> onPageSelected;

  ///The step color
  final Color stepColor;

  ///The step size
  final double size;

  ///The space between steps
  final double stepSpacing;

  ///The step display widget for the previous steps
  final Widget previousStep;

  ///The step display widget for the next steps
  final Widget nextStep;

  ///The step display widget for the selected step
  final Widget selectedStep;

  StepPageIndicator({
    Key key,
    @required this.currentPageNotifier,
    @required this.itemCount,
    this.onPageSelected,
    this.size = _defaultSize,
    this.stepSpacing = _defaultSpacing,
    Color stepColor,
    this.previousStep,
    this.selectedStep,
    this.nextStep,
  })  : this.stepColor = stepColor ?? _defaultStepColor,
        assert(size >= 0, "size must be a positive number"),
        super(key: key);

  @override
  _StepPageIndicatorState createState() {
    return _StepPageIndicatorState();
  }
}

class _StepPageIndicatorState extends State<StepPageIndicator> {
  int _currentPageIndex = 0;

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
    return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: List<Widget>.generate(widget.itemCount, (int index) {
          return GestureDetector(
              onTap: () => widget.onPageSelected == null
                  ? null
                  : widget.onPageSelected(index),
              child: SizedBox(
                  width: widget.size + widget.stepSpacing,
                  height: widget.size,
                  child: Center(
                    child: _getStep(index),
                  )));
        }));
  }

  bool isSelected(int dotIndex) => _currentPageIndex == dotIndex;

  bool isPrevious(int dotIndex) => _currentPageIndex > dotIndex;

  bool isNext(int dotIndex) => _currentPageIndex < dotIndex;

  _handlePageIndex() {
    setState(_readCurrentPageIndex);
  }

  _readCurrentPageIndex() {
    _currentPageIndex = widget.currentPageNotifier.value;
  }

  _getStep(int index) {
    if (isPrevious(index)) {
      return widget.previousStep ??
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: widget.stepColor)),
            child: FittedBox(
              child: Icon(
                Icons.check,
                color: widget.stepColor,
              ),
            ),
          );
    } else if (isSelected(index)) {
      return widget.selectedStep ??
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: widget.stepColor)),
            child: Container(
                margin: const EdgeInsets.all(2),
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.stepColor,
                  shape: BoxShape.circle,
                )),
          );
    } else {
      return widget.nextStep ??
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: widget.stepColor)),
          );
    }
  }
}
