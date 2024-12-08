import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PDFViewerCachedFromURL extends StatelessWidget {
  final String url;
  // final String error;
  const PDFViewerCachedFromURL({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return PDF(
      // enableSwipe: true,
      // swipeHorizontal: true,
      // autoSpacing: false,
      // pageFling: false,
      onError: (error) {
        print(error.toString());
      },
      onPageError: (page, error) {
        print('$page: ${error.toString()}');
      },
      onPageChanged: (int? page, int? total) {
        print('page change: $page/$total');
      },
    ).cachedFromUrl(url,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())));
  }
}
