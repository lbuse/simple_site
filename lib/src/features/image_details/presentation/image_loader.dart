import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/skeleton_loader.dart';

class ImageLoader extends StatefulWidget {
  const ImageLoader(
    this.imageUrl, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  State<ImageLoader> createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  final key = GlobalKey();
  // NOTE: Useful when the request can use the space available to get images with the right size
  final ValueNotifier<Size> size = ValueNotifier(const Size(0, 0));
  int _reloadAttempt = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = key.currentContext;
      if (context != null) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        size.value = renderBox.size;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder(
      valueListenable: size,
      builder: (_, Size size, __) {
        Widget child;

        if (widget.imageUrl == null) {
          child = SkeletonLoading(
              child: SkeletonContainer(
            width: widget.width,
            height: widget.height,
          ));
        } else {
          child = CachedNetworkImage(
            imageUrl: widget.imageUrl!,
            fit: widget.fit,
            width: widget.width,
            height: widget.height,
            fadeInDuration: kThemeAnimationDuration,
            fadeOutDuration: kThemeAnimationDuration,
            placeholder: (_, __) => const SkeletonLoading(
              child: SkeletonContainer(),
            ),
            errorWidget: (_, __, ___) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  "Falha ao carregar imagem",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _reloadAttempt++;
                    });
                  },
                  label: const Text("Tentar novamente"),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          );
        }

        return AnimatedSwitcher(
          duration: kThemeAnimationDuration,
          child: child,
        );
      },
    );
  }
}
