import 'package:flutter/material.dart';

/// Helper to create a skeleton loader effect on multiple widgets, if you want to apply to a single widget use [SkeletonLoading]
class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({
    super.key,
    required this.child,
    this.isLoading = true,
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return SkeletonLoading(
      isLoading: isLoading,
      child: child,
    );

    // NOTE: this should adda wave effect to the loading effect, but it's not working
    // final colorScheme = Theme.of(context).colorScheme;
    // final highlightColor = this.highlightColor ?? colorScheme.surface;
    // final baseColor = this.baseColor ??
    //     (colorScheme.brightness == Brightness.light
    //         ? colorScheme.onSurface.withOpacity(0.3)
    //         : colorScheme.surfaceContainerHighest);

    // return Skeleton(
    //   linearGradient: LinearGradient(
    //     colors: [baseColor, highlightColor, baseColor],
    //     stops: const [0.0, 0.5, 1.0],
    //     begin: Alignment.topLeft,
    //     end: Alignment.bottomRight,
    //   ),
    //   child: SkeletonLoading(
    //     isLoading: isLoading,
    //     child: child,
    //   ),
    // );
  }
}

class SkeletonLoading extends StatefulWidget {
  const SkeletonLoading({
    super.key,
    this.isLoading = true,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  State<SkeletonLoading> createState() => _SkeletonLoadingState();
}

class _SkeletonLoadingState extends State<SkeletonLoading>
    with SingleTickerProviderStateMixin {
  Listenable? _skeletonChanges;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_skeletonChanges != null) {
      _skeletonChanges!.removeListener(_onSkeletonChange);
    }
    if (_skeletonChanges != null) {
      _skeletonChanges!.addListener(_onSkeletonChange);
    }

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color surfaceContainer = colorScheme.brightness == Brightness.light
        ? colorScheme.onSurface.withOpacity(0.3)
        : colorScheme.surfaceContainerHighest;

    _colorAnimation = ColorTween(
      begin: surfaceContainer,
      end: colorScheme.surface,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _skeletonChanges?.removeListener(_onSkeletonChange);
    super.dispose();
  }

  void _onSkeletonChange() {
    if (widget.isLoading) {
      setState(() {
        // update the shimmer painting.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return ColorFiltered(
          colorFilter: ColorFilter.mode(
            _colorAnimation.value!,
            BlendMode.srcATop,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class SkeletonContainer extends StatelessWidget {
  const SkeletonContainer({
    super.key,
    this.width,
    this.height,
    this.margin = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  final double? width;
  final double? height;
  final EdgeInsets margin;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: borderRadius,
      ),
      child: const Center(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Icon(
          Icons.image_rounded,
          color: Colors.red,
        ),
      )),
    );
  }
}
