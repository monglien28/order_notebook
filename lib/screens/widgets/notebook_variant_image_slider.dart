import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NotebookVariantImageSlider extends StatefulWidget {
  final List<String> imageUrls;

  const NotebookVariantImageSlider({super.key, required this.imageUrls});

  @override
  State<NotebookVariantImageSlider> createState() =>
      _NotebookVariantImageSliderState();
}

class _NotebookVariantImageSliderState
    extends State<NotebookVariantImageSlider> {
  final PageController _controller = PageController();

  @override
  void initState() {
    // print(widget.imageUrls);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.bottomCenter,
      children: [
        // Image Carousel
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.imageUrls[index],
                  fit: BoxFit.scaleDown,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image, size: 50)),
                ),
              );
            },
          ),
        ),


        // Dots Indicator
        SmoothPageIndicator(
          controller: _controller,
          count: widget.imageUrls.length,
          effect: const ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.blueAccent,
            dotColor: Colors.grey,
          ),
        ),SizedBox(height: 10,)
      ],
    );
  }
}
