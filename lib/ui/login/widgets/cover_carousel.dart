import 'dart:async';
import 'package:flutter/material.dart';

class CoverCarousel extends StatefulWidget {
  final List<String> covers;
  final double height;
  final Duration interval;
  final Duration animDuration;

  const CoverCarousel({
    super.key,
    required this.covers,
    this.height = 120,
    this.interval = const Duration(seconds: 2),
    this.animDuration = const Duration(milliseconds: 500),
  });

  @override
  State<CoverCarousel> createState() => _CoverCarouselState();
}

class _CoverCarouselState extends State<CoverCarousel> {
  late final PageController _page =
  PageController(viewportFraction: 0.28, initialPage: 1000 * (widget.covers.length));
  Timer? _timer;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.interval, (_) {
      _current++;
      if (!mounted) return;
      _page.animateToPage(
        _page.page!.toInt() + 1,
        duration: widget.animDuration,
        curve: Curves.easeOutCubic,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _page,
        padEnds: false,
        itemBuilder: (_, i) {
          final url = widget.covers[i % widget.covers.length];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                url,
                width: 86, height: 86, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
              ),
            ),
          );
        },
      ),
    );
  }
}
