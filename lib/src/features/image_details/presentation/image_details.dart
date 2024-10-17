import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../../core/helpers/layout_helpers.dart';
import '../../home/domain/entities/item.dart';
import '../../home/presentation/widgets/full_screen_image.dart';
import 'image_loader.dart';

class ImageDetails extends StatelessWidget {
  const ImageDetails(
    this.item, {
    super.key,
    this.isRoot = false,
  });

  final Item item;
  final bool isRoot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isRoot
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
      body: SingleChildScrollView(
        child: Padding(
          padding: isRoot
              ? const EdgeInsets.all(16.0)
              : const EdgeInsets.only(
                  left: 16.0,
                  top: 8.0,
                  right: 16.0,
                  bottom: 16.0,
                ),
          child: LayoutBuilder(builder: (_, constraints) {
            final deviceLayout = getResponsiveLayout(constraints.maxWidth);

            return AnimatedSwitcher(
              duration: kThemeAnimationDuration,
              child: deviceLayout == DeviceLayout.desktop
                  ? _buildDesktopLayout(context)
                  : _buildMobileLayout(context),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 1920,
          maxHeight: MediaQuery.of(context).size.height - 16 * 4,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64.0),
                child: _buildText(context, isDesktopLayout: true),
              ),
            ),
            const SizedBox(width: 32.0),
            Expanded(
              flex: 2,
              child: _buildImage(
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final maxHeight = (MediaQuery.of(context).size.height / 2) - 16 * 4;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 1200,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildImage(width: double.infinity, height: maxHeight),
          const SizedBox(height: 16.0),
          _buildText(context),
        ],
      ),
    );
  }

  Widget _buildImage({double? width, double? height}) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(11.0),
      ),
      child: OpenContainer(
        closedColor: Colors.transparent,
        middleColor: Colors.transparent,
        openColor: Colors.transparent,
        closedElevation: 0,
        closedBuilder: (_, __) => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: ImageLoader(
            item.imageUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        ),
        openBuilder: (_, action) => FullScreenImage(item.imageUrl),
      ),
    );
  }

  Widget _buildText(BuildContext context, {bool isDesktopLayout = false}) {
    final titleStyle = isDesktopLayout
        ? Theme.of(context).textTheme.headlineMedium
        : Theme.of(context).textTheme.titleLarge;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: titleStyle,
        ),
        const SizedBox(height: 16.0),
        Text(item.description),
      ],
    );
  }
}
