import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/skeleton_loader.dart';

class FullScreenCarousel extends StatefulWidget {
  const FullScreenCarousel({
    super.key,
    required this.imagesUrls,
    required this.initialIndex,
  });

  final List<String> imagesUrls;
  final int initialIndex;
  static const _defaultMargin = 8.0;

  @override
  State<FullScreenCarousel> createState() => _FullScreenCarouselState();
}

class _FullScreenCarouselState extends State<FullScreenCarousel> {
  late final CarouselController carouselController;

  @override
  void initState() {
    super.initState();
    carouselController = CarouselController(initialItem: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CarouselView(
              controller: carouselController,
              itemExtent: double.infinity,
              shrinkExtent: screenWidth,
              itemSnapping: true,
              padding: EdgeInsets.zero,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              shape: const ContinuousRectangleBorder(),
              children: widget.imagesUrls.map((imageUrl) {
                return CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (_, __) => const SkeletonLoading(
                    child: SkeletonContainer(
                      size: Size(double.infinity, double.infinity),
                    ),
                  ),
                  errorWidget: (_, __, error) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          error.toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => setState(() {}),
                          child: const Text('Recarregar'),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: FullScreenCarousel._defaultMargin,
            right: FullScreenCarousel._defaultMargin,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            left: FullScreenCarousel._defaultMargin,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: CarouselControlButton(
                carouselController: carouselController,
                icon: const Icon(Icons.keyboard_arrow_left_rounded),
                onPressed: () {
                  final position = carouselController.position;
                  double offset;

                  if (position.minScrollExtent == position.pixels) {
                    offset = carouselController.offset - 10;
                  } else {
                    offset = carouselController.offset - screenWidth;
                  }

                  carouselController.animateTo(
                    offset,
                    duration: kThemeAnimationDuration,
                    curve: Curves.easeIn,
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: FullScreenCarousel._defaultMargin,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerRight,
              child: CarouselControlButton(
                carouselController: carouselController,
                icon: const Icon(Icons.keyboard_arrow_right_rounded),
                onPressed: () {
                  final position = carouselController.position;
                  double offset;

                  if (position.maxScrollExtent == position.pixels) {
                    offset = carouselController.offset + 10;
                  } else {
                    offset = carouselController.offset + screenWidth;
                  }

                  carouselController.animateTo(
                    offset,
                    duration: kThemeAnimationDuration,
                    curve: Curves.easeIn,
                  );
                },
              ),
            ),
          ),
          // TODO: maybe show a list of thumbnails at the bottom so the user que see an jump to the image he wants
        ],
      ),
    );
  }
}

class CarouselControlButton extends StatelessWidget {
  const CarouselControlButton({
    super.key,
    required this.carouselController,
    required this.icon,
    this.onPressed,
  });

  final CarouselController carouselController;
  final Icon icon;
  final VoidCallback? onPressed;
  // final _controller = WidgetStatesController();
  // final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.3),
      ),
    );
    // TODO: como o iconbutton does not have stateController we need to handle the state ourselves with CircleAvatar and a hover variable
    // return ValueListenableBuilder(
    //     valueListenable: _controller,
    //     builder: (context, states, _) {
    //       return InkWell(
    //         statesController: _controller,
    //         onTap: () {},
    //         hoverColor: WidgetStateColor.resolveWith((state) {
    //           if (states.contains(WidgetState.hovered)) {
    //             return Theme.of(context).colorScheme.error;
    //           } else {
    //             return Theme.of(context).colorScheme.secondaryFixed;
    //             //.withOpacity(0.4);
    //           }
    //         }),
    //         child: icon,
    //       );
    //     });

    // @override
    // Widget build(BuildContext context) {
    //   // final ValueNotifier<bool> _isHovered = ValueNotifier(false);

    //   return ValueListenableBuilder(
    //     valueListenable: _controller,
    //     builder: (_, states, __) {
    //       return InkWell(
    //         statesController: _controller,
    //         hoverColor: WidgetStateColor.resolveWith((state) {
    //           if (states.contains(WidgetState.hovered)) {
    //             return Theme.of(context).buttonTheme.colorScheme!.secondaryFixed;
    //           } else {
    //             return Theme.of(context)
    //                 .buttonTheme
    //                 .colorScheme!
    //                 .primary
    //                 .withOpacity(0.4);
    //           }
    //         }),
    //         child: CircleAvatar(child: icon),
    //       );
    //     },
    //   );
    // return FilledButton.icon(
    //   icon: icon,
    //   style: IconButton.styleFrom(
    //     backgroundColor: WidgetStateColor.resolveWith((state) {
    //       if (state.contains(WidgetState.hovered)) {
    //         return Theme.of(context).buttonTheme.colorScheme!.secondaryFixed;
    //       } else {
    //         return Theme.of(context)
    //             .buttonTheme
    //             .colorScheme!
    //             .primary
    //             .withOpacity(0.4);
    //       }
    //     }),
    //   ),
    //   onPressed: () {
    //     carouselController.animateTo(
    //       carouselController.offset - 1,
    //       duration: kThemeAnimationDuration,
    //       curve: Curves.bounceIn,
    //     );
    //   },
    //   label: Text(''),
    // );

    // return ValueListenableBuilder(
    //   valueListenable: _controller,
    //   builder: (_, isHovered, __) {
    //     return IconButton(
    //       icon: icon,
    //       style: IconButton.styleFrom(
    //         backgroundColor: WidgetStateColor.resolveWith((state) {
    //           if (state.contains(WidgetState.hovered)) {
    //             return Theme.of(context)
    //                 .buttonTheme
    //                 .colorScheme!
    //                 .secondaryFixed;
    //           } else {
    //             return Theme.of(context)
    //                 .buttonTheme
    //                 .colorScheme!
    //                 .primary
    //                 .withOpacity(0.4);
    //           }
    //         }),
    //       ),
    //       onPressed: () {
    //         carouselController.animateTo(
    //           carouselController.offset - 1,
    //           duration: kThemeAnimationDuration,
    //           curve: Curves.bounceIn,
    //         );
    //       },
    //     );
    //   },
    // );
  }
}
