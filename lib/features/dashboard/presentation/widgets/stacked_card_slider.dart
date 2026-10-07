import 'package:flutter/material.dart';
import '../../../../shared/theme/app_theme.dart';

class StackedCardSlider extends StatefulWidget {
  final List<Widget> cards;

  const StackedCardSlider({super.key, required this.cards});

  @override
  State<StackedCardSlider> createState() => _StackedCardSliderState();
}

class _StackedCardSliderState extends State<StackedCardSlider> {
  late PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Visual stacked cards
              ...List.generate(widget.cards.length, (index) {
                double offset = index - _currentPage;
                if (offset < -1 || offset > 2) return const SizedBox.shrink(); // Optimization
                
                double scale = 1.0;
                double dy = 0.0;
                double dx = 0.0;
                double opacity = 1.0;

                if (offset > 0) {
                  // Cards that are behind the current card
                  scale = 1.0 - (offset * 0.08); // Scale down
                  dy = -(offset * 20.0); // Move up
                  opacity = 1.0;
                } else {
                  // Swiping away to the left
                  scale = 1.0;
                  dy = 0.0;
                  dx = offset * MediaQuery.of(context).size.width; // Slide left
                  opacity = 1.0 + offset; 
                  if (opacity < 0) opacity = 0;
                }

                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.bottomCenter,
                    child: Opacity(
                      opacity: opacity,
                      child: widget.cards[index],
                    ),
                  ),
                );
              }).reversed,

              // The invisible PageView to handle gestures smoothly
              PageView.builder(
                controller: _pageController,
                itemCount: widget.cards.length,
                itemBuilder: (context, index) {
                  return Container(color: Colors.transparent);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.cards.length, (index) {
            bool isActive = (index == _currentPage.round());
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? AppTheme.primaryColor : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
