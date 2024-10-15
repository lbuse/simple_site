import 'dart:math';

import 'package:flutter/foundation.dart';

enum SideBarStates {
  expanded,
  collapsed,
  dockedByScreenSize,
  dockedByUser,
}

class SideBarState {
  SideBarState() {
    selectedImage.value = ImageListState(hoveredIndex: null, selectedIndex: 0);
  }

  final sideBarState = ValueNotifier(SideBarStates.collapsed);
  final showHeaderActions = ValueNotifier(false);
  final ValueNotifier<ImageListState> selectedImage = ValueNotifier(
    ImageListState(hoveredIndex: null, selectedIndex: 1),
  );

  bool get isDocked =>
      sideBarState.value == SideBarStates.dockedByScreenSize ||
      sideBarState.value == SideBarStates.dockedByUser;
  bool get isExpanded =>
      sideBarState.value == SideBarStates.expanded || isDocked;

  void setSideBarState(SideBarStates state) {
    sideBarState.value = state;
  }

  void togglePin() {
    sideBarState.value = sideBarState.value == SideBarStates.dockedByUser
        ? SideBarStates.expanded
        : SideBarStates.dockedByUser;
  }

  void togglePinByScreenSize(bool isLargeScreen) {
    if (sideBarState.value != SideBarStates.dockedByUser) {
      sideBarState.value = isLargeScreen
          ? SideBarStates.dockedByScreenSize
          : SideBarStates.collapsed;
    }
  }

  void updateHoveredIndex(int? newHoveredIndex) {
    selectedImage.value = ImageListState(
      hoveredIndex: newHoveredIndex,
      selectedIndex: selectedImage.value.selectedIndex,
    );
  }

  void updateSelectedIndex(int newSelectedIndex) {
    selectedImage.value = ImageListState(
      hoveredIndex: selectedImage.value.hoveredIndex,
      selectedIndex: newSelectedIndex,
    );
  }
}

class ImageListState {
  ImageListState({this.hoveredIndex, required this.selectedIndex});

  final int? hoveredIndex;
  final int selectedIndex;
}
