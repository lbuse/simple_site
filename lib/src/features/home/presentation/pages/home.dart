import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/helpers/assets.dart';
import '../../../../core/helpers/layout_helpers.dart';
import '../../../image_details/presentation/image_details.dart';
import '../../../settings/settings_controller.dart';
import '../../domain/entities/selected_image.dart';
import '../widgets/full_screen_carousel.dart';
import '../widgets/side_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final settingsController = GetIt.I.get<SettingsController>();
  final sideBarKey = GlobalKey();
  final ValueNotifier<bool> _isDocked = ValueNotifier(false);
  final ValueNotifier<double> collapsedSideBarWidth = ValueNotifier(0.0);
  final selectedImage = ValueNotifier<SelectedImage?>(null);
  final images = List.generate(
    Random().nextInt(10) + 2,
    (index) =>
        'https://picsum.photos/${Random().nextInt(2000) + 600}/${Random().nextInt(2000) + 400}?random=0',
  );
  static const double itemWidth = 400.0;
  // static const double itemHeight = 280.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = sideBarKey.currentContext;
      if (context != null) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        collapsedSideBarWidth.value = renderBox.size.width;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile =
        getResponsiveLayout(screenSize.width) == DeviceLayout.mobile;

    return Scaffold(
      body: isMobile ? _buildMobileLayout() : _buildLargeScreenLayout(),
    );
  }

  Widget _buildMobileLayout() {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          floating: true,
          leading: Image.asset(
            Assets.logo,
            width: 60,
            height: 60,
            fit: BoxFit.contain,
          ),
          actions: [
            IconButton(
              icon: Icon(
                theme.brightness == Brightness.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              onPressed: () {
                settingsController.updateThemeMode(
                  theme.brightness == Brightness.light
                      ? ThemeMode.dark
                      : ThemeMode.light,
                );
              },
            ),
          ],
        ),
        SliverFillRemaining(
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: itemWidth,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemCount: images.length,
            itemBuilder: (_, index) {
              return OpenContainer(
                closedColor: Colors.transparent,
                middleColor: Colors.transparent,
                openColor: Colors.transparent,
                closedShape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                openBuilder: (_, __) => FullScreenCarousel(
                  imagesUrls: images,
                  initialIndex: index,
                ),
                closedBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ImageDetails(
                        images[index],
                        desiredSize: Size(double.infinity, double.infinity),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLargeScreenLayout() {
    final sidebar = SideBar(
      key: sideBarKey,
      settingsController: settingsController,
      imagesUrls: images,
      onDockedChange: (isDocked) => _isDocked.value = isDocked,
      onTap: (value) => selectedImage.value = value,
    );

    final mainView = Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: ValueListenableBuilder(
              valueListenable: selectedImage,
              builder: (_, image, __) => ImageDetails(image?.url),
            )),
      ),
    );

    return ValueListenableBuilder<bool>(
      valueListenable: _isDocked,
      builder: (context, isDocked, child) {
        return isDocked
            ? Row(
                children: [
                  sidebar,
                  Expanded(child: mainView),
                ],
              )
            : Stack(
                children: [
                  ValueListenableBuilder(
                    valueListenable: collapsedSideBarWidth,
                    builder: (_, sideBarWidth, __) {
                      return AnimatedPositioned(
                        left: sideBarWidth,
                        top: 0,
                        right: 0,
                        bottom: 0,
                        duration: kThemeAnimationDuration,
                        child: mainView,
                      );
                    },
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: sidebar,
                  ),
                ],
              );
      },
    );
  }
}
