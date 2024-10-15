enum DeviceLayout {
  mobile,
  tablet,
  desktop,
}

DeviceLayout getResponsiveLayout(double width) {
  if (width < 600) {
    return DeviceLayout.mobile;
  } else if (width < 1200) {
    return DeviceLayout.tablet;
  } else {
    return DeviceLayout.desktop;
  }
}
