import 'dart:math';

import 'package:animations/animations.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/helpers/assets.dart';
import '../../../../core/helpers/layout_helpers.dart';
import '../../../image_details/presentation/image_details.dart';
import '../../../image_details/presentation/image_resumed.dart';
import '../../../settings/settings_controller.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/selected_image.dart';
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
  late final ValueNotifier<SelectedImage> selectedImage;
  final images = List.generate(
    Random().nextInt(10) + 2,
    (index) {
      final randomWord = WordPair.random();
      return Item(
        title: '${randomWord.first} ${randomWord.second}',
        description: lorem(paragraphs: Random().nextInt(3) + 1, words: 60),
        imageUrl:
            'https://picsum.photos/${Random().nextInt(2000) + 600}/${Random().nextInt(2000) + 400}?random=0',
      );
    },
  );
  static const double itemWidth = 600.0;
  // static const double itemHeight = 280.0;

  @override
  void initState() {
    super.initState();
    selectedImage = ValueNotifier(SelectedImage(0, images[0]));

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
              final item = images[index];
              return OpenContainer(
                closedColor: Colors.transparent,
                middleColor: Colors.transparent,
                openColor: Colors.transparent,
                closedElevation: 0,
                openBuilder: (_, __) => ImageDetails(item),
                closedBuilder: (_, __) => MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: ImageResumed(item),
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
      items: images,
      onDockedChange: (isDocked) => _isDocked.value = isDocked,
      onTap: (value) => selectedImage.value = value,
    );

    final mainView = Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: selectedImage,
          builder: (_, selectedImage, __) {
            final item = selectedImage.imageData;
            return OpenContainer(
              closedColor: Colors.transparent,
              middleColor: Colors.transparent,
              openColor: Colors.transparent,
              closedElevation: 0,
              openBuilder: (_, __) => ImageDetails(item),
              closedBuilder: (_, __) => MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ImageDetails(item, isRoot: true),
              ),
            );
          },
        ),
      ),
    );

    return Row(
      children: [
        sidebar,
        Expanded(child: mainView),
      ],
    );
  }
}
