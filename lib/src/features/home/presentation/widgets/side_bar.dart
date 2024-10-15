import 'package:flutter/material.dart';

import '../../../../core/helpers/assets.dart';
import '../../../../core/helpers/layout_helpers.dart';
import '../../../image_details/presentation/image_details.dart';
import '../../../settings/settings_controller.dart';
import '../../domain/entities/selected_image.dart';
import '../states/side_bar_state.dart';

class SideBar extends StatefulWidget {
  const SideBar({
    super.key,
    required this.settingsController,
    required this.imagesUrls,
    this.onDockedChange,
    this.onTap,
  });

  final SettingsController settingsController;
  final List<String> imagesUrls;
  final ValueChanged<bool>? onDockedChange;
  final ValueChanged<SelectedImage>? onTap;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final state = SideBarState();

  @override
  void initState() {
    super.initState();
    state.sideBarState.addListener(_onDockedChange);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.updateSelectedIndex(0);
      widget.onTap!(SelectedImage(0, widget.imagesUrls[0]));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenSize = MediaQuery.of(context).size;
    state.togglePinByScreenSize(
      getResponsiveLayout(screenSize.width) == DeviceLayout.desktop,
    );
  }

  @override
  void dispose() {
    super.dispose();
    state.sideBarState.removeListener(_onDockedChange);
  }

  void _onDockedChange() {
    if (widget.onDockedChange != null) {
      widget.onDockedChange?.call(state.isDocked);

      if (!state.isExpanded) {
        state.showHeaderActions.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder(
      valueListenable: state.sideBarState,
      builder: (_, sideBarState, __) {
        final isExpanded = state.isExpanded;
        final logoPadding = isExpanded ? 24.0 : 8.0;

        return MouseRegion(
          onEnter: state.isDocked
              ? null
              : (_) => state.setSideBarState(SideBarStates.expanded),
          onExit: state.isDocked
              ? null
              : (_) => state.setSideBarState(SideBarStates.collapsed),
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            width: isExpanded ? 250 : 80,
            color: theme.colorScheme.secondaryContainer,
            onEnd: () {
              state.showHeaderActions.value = isExpanded;
            },
            child: Column(
              children: [
                _buildHeader(logoPadding, isExpanded, theme),
                Expanded(child: _buildList()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    double logoPadding,
    bool isExpanded,
    ThemeData theme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: logoPadding,
                bottom: logoPadding,
              ),
              child: Image.asset(
                Assets.logo,
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: state.showHeaderActions,
          builder: (_, showActions, __) {
            return AnimatedSwitcher(
              duration: kThemeAnimationDuration,
              child: showActions
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              theme.brightness == Brightness.light
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                            ),
                            onPressed: () {
                              widget.settingsController.updateThemeMode(
                                theme.brightness == Brightness.light
                                    ? ThemeMode.dark
                                    : ThemeMode.light,
                              );
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: state.sideBarState,
                            builder: (_, barState, __) {
                              return AnimatedSwitcher(
                                duration: kThemeAnimationDuration,
                                child:
                                    barState == SideBarStates.dockedByScreenSize
                                        ? const SizedBox.shrink()
                                        : IconButton(
                                            onPressed: () => state.togglePin(),
                                            icon: AnimatedRotation(
                                              turns: state.isDocked ? 0.0 : 0.1,
                                              duration: kThemeAnimationDuration,
                                              child: const Icon(Icons.push_pin),
                                            ),
                                          ),
                              );
                            },
                          )
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          },
        )
      ],
    );
  }

  Widget _buildList() {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: widget.imagesUrls.length,
      itemBuilder: (_, int index) {
        String url = widget.imagesUrls[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: InkWell(
            onTap: widget.onTap != null
                ? () {
                    state.updateSelectedIndex(index);
                    widget.onTap!(SelectedImage(index, url));
                  }
                : null,
            onHover: (isHovered) =>
                state.updateHoveredIndex(isHovered ? index : null),
            child: ValueListenableBuilder(
              valueListenable: state.selectedImage,
              builder: (_, itemState, __) {
                final isHovered = itemState.hoveredIndex == index ||
                    itemState.selectedIndex == index;

                return Card(
                  elevation: isHovered ? 8.0 : 0.0,
                  shadowColor: theme.colorScheme.primary,
                  borderOnForeground: false,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0.0,
                      color: theme.colorScheme.secondary,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ImageDetails(url),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
