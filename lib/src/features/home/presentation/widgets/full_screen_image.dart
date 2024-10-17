import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/skeleton_loader.dart';

class FullScreenImage extends StatefulWidget {
  const FullScreenImage(this.imageUrl, {super.key});

  final String imageUrl;

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  static const _defaultMargin = 8.0;
  int reloadAttempt = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.contain,
            placeholder: (_, __) => const SkeletonLoading(
              child: SkeletonContainer(
                width: double.infinity,
                height: double.infinity,
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
                    onPressed: () => setState(() {
                      reloadAttempt++;
                    }),
                    child: const Text('Recarregar'),
                  ),
                ],
              ),
            ),
          )),
          Positioned(
            top: _defaultMargin,
            right: _defaultMargin,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
