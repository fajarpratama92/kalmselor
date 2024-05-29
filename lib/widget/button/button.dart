// ignore_for_file: use_key_in_widget_constructors

import 'package:counselor/color/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  VoidCallback? onPressed;
  String? title;
  double? heigth;
  double? radius;
  bool? isIconButton;
  bool? accIcon;
  bool? isGreenColor;
  double? padHorizontal;
  double? padvertical;
  double? radiusCircular;
  TextStyle? titleStyle;
  Color? color;
  Color? highlightColor;
  Color? splashColor;
  Widget? titleRow;
  CustomButton({
    Key? key,
    required this.onPressed,
    this.title,
    this.heigth,
    this.radius,
    this.isIconButton = false,
    this.accIcon = true,
    this.padHorizontal,
    this.titleStyle,
    this.isGreenColor = false,
    this.highlightColor,
    this.splashColor,
    this.titleRow,
    this.padvertical,
    this.color,
    this.radiusCircular,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: padHorizontal ?? 0, vertical: padvertical ?? 0),
      child: ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(radiusCircular ?? 30.0))),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return BLUEKALM;
                } else if (states.contains(MaterialState.disabled)) {
                  return Colors.grey;
                }
                return ORANGEKALM; // Use the component's default.
              },
            )),

        onPressed: onPressed,
        child: SizedBox(
          height: heigth ?? 50,
          child: Center(child: Builder(builder: (context) {
            switch (isIconButton) {
              case true:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      accIcon!
                          ? 'assets/others/accept.png'
                          : 'assets/others/decline.png',
                      scale: 6,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      title ?? "",
                      style: titleStyle ??
                          const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              case false:
                return titleRow ??
                    Text(
                      title ?? "",
                      style: titleStyle ??
                          const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    );
              default:
                return Container();
            }
          })),
        ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(radius ?? 30),
        // ),
      ),
    );
  }
}

class CustomOutlineButton extends StatelessWidget {
  final Widget? child;
  final Function? onPress;
  final double? padHorizontal;
  final double? padVertical;
  final double? radiusCircular;
  final double? borderWidth;
  final Color? borderColor;
  final Color? fillColor;
  const CustomOutlineButton(
      {this.child,
      this.onPress,
      this.padHorizontal,
      this.padVertical,
      this.radiusCircular,
      this.borderColor,
      this.fillColor,
      this.borderWidth,
      Key? key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: padHorizontal ?? 0, vertical: padVertical ?? 0),
      child: TextButton(
        onPressed: () => onPress!(),
        child: child ?? Container(),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return BLUEKALM;
                else if (states.contains(MaterialState.disabled))
                  return Colors.grey;
                return (fillColor ?? Colors.white);
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radiusCircular ?? 30.0),
                    side: BorderSide(
                        width: borderWidth ?? 1,
                        color: borderColor ?? ORANGEKALM)))),
      ),
    );
  }
}

class RefreshIndicatorAnimation extends StatefulWidget {
  final bool forward;
  const RefreshIndicatorAnimation({required this.forward, Key? key});

  @override
  _RefreshIndicatorAnimation createState() => _RefreshIndicatorAnimation();
}

class _RefreshIndicatorAnimation extends State<RefreshIndicatorAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation;
  @override
  void didUpdateWidget(RefreshIndicatorAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.forward) && oldWidget.forward) {
      print("forward");
      controller?.forward();
    } else {
      controller?.stop();
      print("stop ");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 0, end: 2)
        .animate(CurvedAnimation(parent: controller!, curve: Curves.easeInOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller?.reset();
          print("reset ");
        } else if (status == AnimationStatus.dismissed) {
          controller?.forward();
          print("forward");
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: animation!,
      child: const Icon(Icons.refresh),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  /// Default  fillColor.
  /// ```dart
  /// MaterialStateProperty.resolveWith<Color>(
  /// Set<MaterialState> states) {
  /// if (states.contains(MaterialState.pressed))
  /// return BLUEKALM;
  /// else if (states.contains(MaterialStatedisabled)
  /// return Colors.grey;
  /// return Colors.white;})
  /// ```

  final Color? textColor;
  final Color? colorPressed;
  final String? title;
  final Function() onPress;
  FontWeight? fontWeight;
  Widget? customChild;
  CustomTextButton({
    this.textColor,
    required this.onPress,
    this.title,
    this.fontWeight,
    this.colorPressed,
    this.customChild,
  });
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: customChild ??
          Text(
            title ?? "",
            style: TextStyle(
                color: textColor ?? Colors.black,
                fontWeight: fontWeight ?? FontWeight.bold),
          ),
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return colorPressed ?? BLUEKALM;
          } else if (states.contains(MaterialState.disabled)) {
            return Colors.grey;
          }
          return Colors.transparent;
        },
      )),
    );
  }
}
