import 'package:counselor/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const double kPickerHeaderPortraitHeight = 60.0;
const double kPickerHeaderLandscapeWidth = 168.0;
const double kDialogActionBarHeight = 52.0;
const double kDialogMargin = 30.0;
void showMaterialScrollPicker({
  required BuildContext context,
  required String title,
  required List<String> items,
  String? selectedItem,
  required TextStyle titleStyle,
  Color? headerColor,
  Color? headerTextColor,
  Color? backgroundColor,
  Color? buttonTextColor,
  String? confirmText,
  String? cancelText,
  required double maxLongSide,
  double? maxShortSide,
  double? fontSizeValue,
  required double itemHeigth,
  bool showDivider = true,
  ValueChanged<String>? onChanged,
  required Function(String) onConfirmed,
  VoidCallback? onCancelled,
}) {
  Get.bottomSheet(
    ScrollPickerDialog(
      itemHeight: itemHeigth,
      fontSizeValue: fontSizeValue ?? 18,
      items: items,
      title: title,
      titleStyle: titleStyle,
      initialItem: selectedItem,
      headerColor: headerColor ?? BLUEKALM,
      headerTextColor: headerTextColor,
      backgroundColor: backgroundColor,
      buttonTextColor: buttonTextColor,
      confirmText: confirmText,
      cancelText: cancelText,
      maxLongSide: maxLongSide,
      maxShortSide: maxLongSide,
      showDivider: showDivider,
    )
    //     .then((selection) {
    //   if (onChanged != null && selection != null) onChanged(selection);
    //   if (onCancelled != null && selection == null) onCancelled();
    //   if (selection != null) onConfirmed(selection);
    // });
    ,
  );
  showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return ScrollPickerDialog(
        itemHeight: itemHeigth,
        fontSizeValue: fontSizeValue ?? 18,
        items: items,
        title: title,
        titleStyle: titleStyle,
        initialItem: selectedItem,
        headerColor: headerColor ?? BLUEKALM,
        headerTextColor: headerTextColor,
        backgroundColor: backgroundColor,
        buttonTextColor: buttonTextColor,
        confirmText: confirmText,
        cancelText: cancelText,
        maxLongSide: maxLongSide,
        maxShortSide: maxLongSide,
        showDivider: showDivider,
      );
    },
  ).then((selection) {
    if (onChanged != null && selection != null) onChanged(selection);
    if (onCancelled != null && selection == null) onCancelled();
    if (selection != null) onConfirmed(selection);
  });
  // .then((selection) {
  //   if (onChanged != null && selection != null) onChanged(selection);
  //   if (onCancelled != null && selection == null) onCancelled();
  //   if (selection != null) onConfirmed(selection);
  // });
}

// copied from flutter calendar picker
const Duration _dialogSizeAnimationDuration = Duration(milliseconds: 200);

/// This is a support widget that returns an Dialog with checkboxes as a Widget.
/// It is designed to be used in the showDialog method of other fields.
class ResponsiveDialog extends StatefulWidget
    implements ICommonDialogProperties {
  const ResponsiveDialog({
    Key? key,
    required this.context,
    String? title,
    Widget? child,
    this.headerColor,
    required this.titleStyle,
    this.headerTextColor,
    this.backgroundColor,
    this.buttonTextColor,
    this.forcePortrait = false,
    double? maxLongSide,
    double? maxShortSide,
    this.hideButtons = false,
    this.okPressed,
    this.cancelPressed,
    this.confirmText,
    this.cancelText,
  })  : title = title ?? "Title Here",
        child = child ?? const Text("Content Here"),
        maxLongSide = maxLongSide ?? 600,
        maxShortSide = maxShortSide ?? 400,
        super(key: key);

  // Variables
  final BuildContext context;
  @override
  final String? title;
  final Widget? child;
  final bool? forcePortrait;
  @override
  final TextStyle? titleStyle;
  @override
  final Color? headerColor;
  @override
  final Color? headerTextColor;
  @override
  final Color? backgroundColor;
  @override
  final Color? buttonTextColor;
  @override
  final double? maxLongSide;
  @override
  final double? maxShortSide;
  final bool? hideButtons;
  @override
  final String? confirmText;
  @override
  final String? cancelText;

  // Events
  final VoidCallback? cancelPressed;
  final VoidCallback? okPressed;

  @override
  _ResponsiveDialogState createState() => _ResponsiveDialogState();
}

class _ResponsiveDialogState extends State<ResponsiveDialog> {
  Color? _headerColor;
  Color? _headerTextColor;
  Color? _backgroundColor;
  Color? _buttonTextColor;

  Widget header(BuildContext context, Orientation orientation) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      height: (orientation == Orientation.portrait)
          ? kPickerHeaderPortraitHeight
          : null,
      width: (orientation == Orientation.landscape)
          ? kPickerHeaderLandscapeWidth
          : null,
      child: Center(
        child: Text(
          widget.title ?? "Title Here",
          style: widget.titleStyle ??
              TextStyle(
                fontSize: 20.0,
                color: _headerTextColor,
              ),
          textAlign: TextAlign.center,
        ),
      ),
      padding: const EdgeInsets.all(10.0),
    );
  }

  Widget actionBar(BuildContext context) {
    // MESTI PERLU DICEK
    if (widget.hideButtons != null && widget.hideButtons == true) {
      return Container();
    }

    var localizations = MaterialLocalizations.of(context);

    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
                width: 1.0, color: _headerColor ?? const Color(0xFF000000)),
          ),
        ),
        child: ButtonBar(
          children: <Widget>[
            TextButton(
              // textColor: _buttonTextColor,
              child: Text(widget.cancelText ?? localizations.cancelButtonLabel),
              onPressed: () => (widget.cancelPressed == null)
                  ? Navigator.of(context).pop()
                  : widget.cancelPressed!(),
            ),
            TextButton(
              // textColor: _buttonTextColor,
              child: Text(widget.confirmText ?? localizations.okButtonLabel),
              onPressed: () => (widget.okPressed == null)
                  ? Navigator.of(context).pop()
                  : widget.okPressed!(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    // _headerColor = widget.headerColor ?? theme.primaryColor;
    // _headerTextColor =
    //     widget.headerTextColor ?? theme.primaryTextTheme.headline6.color;
    // _buttonTextColor = widget.buttonTextColor ?? theme.textTheme.button.color;
    // _backgroundColor = widget.backgroundColor ?? theme.dialogBackgroundColor;

    final Orientation orientation = MediaQuery.of(context).orientation;

    // constrain the dialog from expanding to full screen
    final Size dialogSize = (orientation == Orientation.portrait)
        ? Size(widget.maxShortSide!, widget.maxLongSide!)
        : Size(widget.maxLongSide!, widget.maxShortSide!);

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (widget.forcePortrait != null && widget.forcePortrait == true) {
          orientation = Orientation.portrait;
        }

        switch (orientation) {
          case Orientation.portrait:
            return Column(
              children: <Widget>[
                header(context, orientation),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: widget.child,
                  ),
                ),
                actionBar(context),
              ],
            );
          case Orientation.landscape:
            return Row(
              children: <Widget>[
                header(context, orientation),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        widget.child != null
                            ? Expanded(
                                child: widget.child!,
                              )
                            : Container(),
                        actionBar(context),
                      ],
                    ),
                  ),
                ),
              ],
            );
        }
      },
    );
  }
}

abstract class ICommonDialogProperties {
  final String? title;
  final Color? headerColor;
  final Color? headerTextColor;
  final Color? backgroundColor;
  final Color? buttonTextColor;
  final double? maxLongSide;
  final double? maxShortSide;
  final TextStyle? titleStyle;
  final String? confirmText;
  final String? cancelText;

  ICommonDialogProperties(
      {this.title,
      this.headerColor,
      this.headerTextColor,
      this.backgroundColor,
      this.buttonTextColor,
      this.maxLongSide,
      this.maxShortSide,
      this.titleStyle,
      this.confirmText,
      this.cancelText});
}

class ScrollPickerDialog extends StatefulWidget
    implements ICommonDialogProperties {
  const ScrollPickerDialog({
    Key? key,
    required this.title,
    required this.items,
    this.initialItem,
    required this.titleStyle,
    this.headerColor,
    this.headerTextColor,
    this.backgroundColor,
    this.buttonTextColor,
    required this.maxLongSide,
    this.maxShortSide,
    this.showDivider = true,
    this.confirmText,
    this.cancelText,
    required this.fontSizeValue,
    required this.itemHeight,
  }) : super(key: key);

  // Variables
  final List<String> items;
  final String? initialItem;
  final double itemHeight;
  @override
  final String title;
  @override
  final TextStyle titleStyle;
  @override
  final Color? headerColor;
  @override
  final Color? headerTextColor;
  @override
  final Color? backgroundColor;
  @override
  final Color? buttonTextColor;
  @override
  final double maxLongSide;
  @override
  final double? maxShortSide;
  @override
  final String? confirmText;
  @override
  final String? cancelText;
  final double fontSizeValue;
  final bool? showDivider;

  @override
  State<ScrollPickerDialog> createState() =>
      _ScrollPickerDialogState(initialItem, fontSizeValue, itemHeight);
}

class _ScrollPickerDialogState extends State<ScrollPickerDialog> {
  _ScrollPickerDialogState(
      this.selectedItem, this.fontSizeValue, this.itemHeight);
  String? selectedItem;
  double? fontSizeValue;
  double? itemHeight;
  @override
  Widget build(BuildContext context) {
    return ResponsiveDialog(
      context: context,
      title: widget.title,
      titleStyle: widget.titleStyle,
      headerColor: widget.headerColor,
      headerTextColor: widget.headerTextColor,
      backgroundColor: widget.backgroundColor,
      buttonTextColor: widget.buttonTextColor,
      maxLongSide: widget.maxLongSide,
      maxShortSide: widget.maxLongSide,
      confirmText: widget.confirmText,
      cancelText: widget.cancelText,
      child: ScrollPicker(
        itemHeight: itemHeight,
        fontSizeValue: widget.fontSizeValue,
        items: widget.items,
        initialValue: selectedItem,
        showDivider: widget.showDivider ?? true,
        onChanged: (value) => setState(() => selectedItem = value),
      ),
      okPressed: () => Navigator.of(context).pop(selectedItem),
    );
  }
}

class ScrollPicker extends StatefulWidget {
  ScrollPicker({
    Key? key,
    required this.items,
    this.initialValue,
    this.onChanged,
    this.itemHeight,
    required this.fontSizeValue,
    this.showDivider = true,
  }) : super(key: key);

  // Events
  final ValueChanged<String>? onChanged;

  // Variables
  final List<String> items;
  final String? initialValue;
  final bool showDivider;
  final double? itemHeight;
  double fontSizeValue;

  @override
  _ScrollPickerState createState() =>
      _ScrollPickerState(initialValue, fontSizeValue);
}

class _ScrollPickerState extends State<ScrollPicker> {
  _ScrollPickerState(this.selectedValue, this.fontSizeValue);

  // Constants

  // Variables
  double? widgetHeight;
  int? numberOfVisibleItems;
  int? numberOfPaddingRows;
  double? visibleItemsHeight;
  double? offset;
  double fontSizeValue;
  String? selectedValue;

  ScrollController? scrollController;

  @override
  void initState() {
    super.initState();
    if (selectedValue != null) {
      int initialItem = widget.items.indexOf(selectedValue!);
      scrollController = FixedExtentScrollController(initialItem: initialItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(fontSize: fontSizeValue);
    TextStyle selectedStyle =
        TextStyle(fontSize: (fontSizeValue), fontWeight: FontWeight.w700);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        widgetHeight = constraints.maxHeight;
        return Stack(
          children: <Widget>[
            GestureDetector(
              onTapUp: _itemTapped,
              child: ListWheelScrollView.useDelegate(
                childDelegate: ListWheelChildBuilderDelegate(
                    builder: (BuildContext context, int index) {
                  if (index < 0 || index > widget.items.length - 1) {
                    return null;
                  }
                  var value = widget.items[index];
                  final TextStyle itemStyle =
                      (value == selectedValue) ? selectedStyle : defaultStyle;

                  return Center(
                    child: Text(
                      value,
                      style: itemStyle,
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
                controller: scrollController,
                itemExtent: widget.itemHeight ?? 30,
                onSelectedItemChanged: _onSelectedItemChanged,
                physics: const FixedExtentScrollPhysics(),
              ),
            ),
            Center(child: widget.showDivider ? Divider() : Container()),
            Center(
              child: Container(
                height: widget.itemHeight ?? 30,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: BLUEKALM, width: 1.0),
                    bottom: BorderSide(color: BLUEKALM, width: 1.0),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _itemTapped(TapUpDetails? details) {
    if (details != null && widgetHeight != null && scrollController != null) {
      Offset position = details.localPosition;
      double center = widgetHeight! / 2;
      double changeBy = position.dy - center;
      double? newPosition = scrollController!.offset + changeBy;

      // animate to and center on the selected item
      scrollController?.animateTo(newPosition,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  void _onSelectedItemChanged(int index) {
    String newValue = widget.items[index];
    if (newValue != selectedValue && widget.onChanged != null) {
      selectedValue = newValue;
      widget.onChanged!(newValue);
    }
  }
}
