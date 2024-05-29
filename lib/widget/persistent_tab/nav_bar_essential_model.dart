import 'package:flutter/material.dart';
import 'package:counselor/widget/persistent_tab/nav_padding.dart';
import 'package:counselor/widget/persistent_tab/persitent_nav_item.dart';
import 'package:counselor/widget/persistent_tab/screen_transistion_animation.dart';

class NavBarEssentials {
  final int? selectedIndex;
  final int? previousIndex;
  final Color? backgroundColor;
  final List<PersistentBottomNavBarItem>? items;
  final ValueChanged<int>? onItemSelected;
  final double? navBarHeight;
  final NavBarPadding? padding;
  final bool? popScreensOnTapOfSelectedTab;
  final ItemAnimationProperties? itemAnimationProperties;
  final BuildContext? selectedScreenBuildContext;

  const NavBarEssentials({
    Key? key,
    this.selectedIndex,
    this.previousIndex,
    this.backgroundColor,
    this.popScreensOnTapOfSelectedTab,
    this.itemAnimationProperties,
    this.navBarHeight = 0.0,
    required this.items,
    this.onItemSelected,
    this.padding,
    this.selectedScreenBuildContext,
  });

  NavBarEssentials copyWith({
    int? selectedIndex,
    int? previousIndex,
    double? iconSize,
    Color? backgroundColor,
    List<PersistentBottomNavBarItem>? items,
    ValueChanged<int>? onItemSelected,
    double? navBarHeight,
    NavBarPadding? padding,
    Function(int)? popAllScreensForTheSelectedTab,
    bool? popScreensOnTapOfSelectedTab,
    ItemAnimationProperties? itemAnimationProperties,
  }) {
    return NavBarEssentials(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      previousIndex: previousIndex ?? this.previousIndex,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      items: items ?? this.items,
      onItemSelected: onItemSelected ?? this.onItemSelected,
      navBarHeight: navBarHeight ?? this.navBarHeight,
      padding: padding ?? this.padding,
      popScreensOnTapOfSelectedTab:
          popScreensOnTapOfSelectedTab ?? this.popScreensOnTapOfSelectedTab,
      itemAnimationProperties:
          itemAnimationProperties ?? this.itemAnimationProperties,
    );
  }
}
