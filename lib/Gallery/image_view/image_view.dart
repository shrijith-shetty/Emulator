import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
import '../PhotoEdit/photoediting.dart';

class ImageView extends StatefulWidget
{
    final List<AssetEntity> images;
    final int initialIndex;

    const ImageView({
        super.key,
        required this.images,
        required this.initialIndex
    });

    @override
    State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView>
{
    late PageController _controller;
    late int _currentIndex;

    @override
    void initState() 
    {
        super.initState();
        _currentIndex = widget.initialIndex;
        _controller = PageController(initialPage: _currentIndex);
    }

    Future<File?> _getCurrentFile() async
    {
        return await widget.images[_currentIndex].file;
    }

    Future<void> _shareImage() async
    {
        final file = await _getCurrentFile();
        if (file != null) 
        {
            await Share.shareXFiles([XFile(file.path)]);
        }
    }

    Future<void> _deleteImage() async
    {
        final image = widget.images[_currentIndex];
        await PhotoManager.editor.deleteWithIds([image.id]);

        if (!mounted) return;
        Navigator.pop(context);
    }

    Future<void> _editImage() async
    {
        final file = await _getCurrentFile();
        if (file == null) return;

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => PhotoEdit(imagePath: file.path)
            )
        );
    }

    @override
    Widget build(BuildContext context) 
    {
        return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
                children: [
                    PhotoViewGallery.builder(
                        pageController: _controller,
                        itemCount: widget.images.length,
                        backgroundDecoration:
                        const BoxDecoration(color: Colors.black),
                        onPageChanged: (index)
                        {
                            setState(() => _currentIndex = index);
                        },
                        builder: (context, index)
                        {
                            return PhotoViewGalleryPageOptions(
                                imageProvider: AssetEntityImageProvider(
                                    widget.images[index],
                                    isOriginal: true
                                ),
                                minScale: PhotoViewComputedScale.contained,
                                maxScale: PhotoViewComputedScale.covered * 3
                            );
                        }
                    ),

                    /// Bottom Bar
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
                                            color: Colors.white
                                        )
                                    ),
                                    IconButton(
                                        onPressed: _shareImage,
                                        icon: const Icon(
                                            Icons.share,
                                            color: Colors.white
                                        )
                                    ),
                                    IconButton(
                                        onPressed: _deleteImage,
                                        icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red
                                        )
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
        );
    }
}