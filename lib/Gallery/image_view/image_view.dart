import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';
import '../PhotoEdit/photoediting.dart';

class ImageView extends StatefulWidget {
  final List<AssetEntity> images;
  final int initialIndex;

  const ImageView({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late PageController _controller;
  late int _currentIndex;

  final Map<int, TransformationController> _zoomControllers = {};
  final Map<int, double> _currentScales = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    for (var c in _zoomControllers.values) {
      c.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  TransformationController _getZoomController(int index) {
    return _zoomControllers.putIfAbsent(
      index,
          () => TransformationController(),
    );
  }

  void _handleDoubleTap(
      TapDownDetails details, int index) {
    final controller = _getZoomController(index);
    final position = details.localPosition;
    final scale = _currentScales[index] ?? 1.0;

    if (scale == 1.0) {
      controller.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);

      _currentScales[index] = 3.0;
    } else {
      controller.value = Matrix4.identity();
      _currentScales[index] = 1.0;
    }

    setState(() {});
  }

  bool _isZoomed() {
    final scale = _currentScales[_currentIndex] ?? 1.0;
    return scale > 1.0;
  }

  Future<void> _shareImage() async {
    final file = await widget.images[_currentIndex].file;
    if (file != null) {
      await Share.shareXFiles([XFile(file.path)]);
    }
  }

  Future<void> _deleteImage() async {
    final image = widget.images[_currentIndex];
    await PhotoManager.editor.deleteWithIds([image.id]);

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _editImage() async {
    final file = await widget.images[_currentIndex].file;
    if (file == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoEdit(imagePath: file.path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          /// Swipe + Zoom + Double Tap
          PageView.builder(
            controller: _controller,
            physics: _isZoomed()
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              return FutureBuilder<File?>(
                future: widget.images[index].file,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final zoomController =
                  _getZoomController(index);

                  return GestureDetector(
                    onDoubleTapDown: (details) =>
                        _handleDoubleTap(details, index),
                    onDoubleTap: () {},
                    child: InteractiveViewer(
                      transformationController:
                      zoomController,
                      minScale: 1,
                      maxScale: 5,
                      onInteractionEnd: (_) {
                        final scale =
                        zoomController.value
                            .getMaxScaleOnAxis();

                        if (scale <= 1.0) {
                          _currentScales[index] = 1.0;
                        } else {
                          _currentScales[index] = scale;
                        }

                        setState(() {});
                      },
                      child: Center(
                        child: Image.file(
                          snapshot.data!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),

          /// Bottom Action Box (UNCHANGED)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 15, horizontal: 30),
              color: Colors.black.withOpacity(0.7),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _editImage,
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: _shareImage,
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: _deleteImage,
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}