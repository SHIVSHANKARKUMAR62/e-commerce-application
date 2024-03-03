import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ZoomPage extends StatefulWidget {
  final String imageIndex,name;
  const ZoomPage({Key? key,required this.imageIndex,required this.name}) : super(key: key);

  @override
  State<ZoomPage> createState() => _ZoomPageState();
}

class _ZoomPageState extends State<ZoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: SizedBox(
        child: Zoom(
            maxScale: 5,
            doubleTapZoom: true,
            initTotalZoomOut: true,
            child: CachedNetworkImage(imageUrl: widget.imageIndex,)),
      ),
    );
  }
}
