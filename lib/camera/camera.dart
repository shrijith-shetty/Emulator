import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:photo_manager/photo_manager.dart';
import '../Gallery/gallery.dart';

class CameraPage extends StatefulWidget
{
    const CameraPage({super.key});

    @override
    State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
{
    CameraController? _controller;
    bool _loading = true;
    bool _isFront = false;

    Uint8List? _recentImage;

    @override
    void initState() 
    {
        super.initState();
        _initCamera();
        _loadRecentImage();
    }

    Future<void> _initCamera() async
    {
        final cameras = await availableCameras();

        final camera = _isFront
            ? cameras.firstWhere(
                (c) =>
                c.lensDirection ==
                    CameraLensDirection.front,
                orElse: () => cameras.first)
            : cameras.firstWhere(
                (c) =>
                c.lensDirection ==
                    CameraLensDirection.back,
                orElse: () => cameras.first);

        _controller =
        CameraController(camera, ResolutionPreset.high);

        await _controller!.initialize();

        setState(() => _loading = false);
    }

    Future<void> _takePicture() async
    {
        final picture = await _controller!.takePicture();
        await Gal.putImage(picture.path);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Saved"))
        );

        _loadRecentImage(); // 🔥 refresh thumbnail
    }

    Future<void> _loadRecentImage() async
    {
        final permission =
            await PhotoManager.requestPermissionExtend();

        if (!permission.isAuth) return;

        final albums = await PhotoManager.getAssetPathList(
            type: RequestType.image,
            onlyAll: true
        );

        if (albums.isEmpty) return;

        final recent = await albums.first.getAssetListPaged(
            page: 0,
            size: 1
        );

        if (recent.isNotEmpty) 
        {
            final thumb =
                await recent.first.thumbnailDataWithSize(
                    const ThumbnailSize(150, 150)
                );

            setState(()
                {
                    _recentImage = thumb;
                });
        }
    }

    @override
    Widget build(BuildContext context) 
    {
        if (_loading || _controller == null) 
        {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator())
            );
        }

        return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
                children: [

                    /// 🔥 Camera Preview
                    Positioned.fill(
                        child: CameraPreview(_controller!)
                    ),

                    /// 🔥 Bottom Controls
                    Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [

                                /// Flip Camera
                                IconButton(
                                    icon: const Icon(
                                        Icons.flip_camera_ios,
                                        color: Colors.white
                                    ),
                                    onPressed: ()
                                    {
                                        setState(() => _isFront = !_isFront);
                                        _initCamera();
                                    }
                                ),

                                /// Capture Button
                                IconButton(
                                    icon: const Icon(
                                        Icons.camera,
                                        size: 60,
                                        color: Colors.red
                                    ),
                                    onPressed: _takePicture
                                ),

                                /// 🔥 Recent Photo Preview
                                GestureDetector(
                                    onTap: ()
                                    {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => const Gallery()
                                            )
                                        );
                                    },
                                    child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2
                                            ),
                                            color: Colors.grey[800]
                                        ),
                                        child: _recentImage != null
                                            ? ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                child: Image.memory(
                                                    _recentImage!,
                                                    fit: BoxFit.cover
                                                )
                                            )
                                            : const Icon(
                                                Icons.photo,
                                                color: Colors.white
                                            )
                                    )
                                )
                            ]
                        )
                    )
                ]
            )
        );
    }
}