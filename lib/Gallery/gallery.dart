import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:emulator/Gallery/image_view/image_view.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<Gallery>
    with WidgetsBindingObserver {

  List<AssetEntity> _images = [];
  bool _isLoading = true;
  String? _errorMessage;

  // ================= INIT =================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    PhotoManager.addChangeCallback(_onGalleryChange);
    PhotoManager.startChangeNotify();

    _initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    PhotoManager.removeChangeCallback(_onGalleryChange);
    PhotoManager.stopChangeNotify();

    super.dispose();
  }

  // ================= AUTO REFRESH =================

  void _onGalleryChange(MethodCall call) {
    if (mounted) {
      _loadImages();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initialize();
    }
  }

  // ================= PERMISSION =================

  Future<void> _initialize() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final PermissionState permission =
      await PhotoManager.getPermissionState(
        requestOption: const PermissionRequestOption(),
      );

      PermissionState finalPermission = permission;

      if (!permission.hasAccess) {
        finalPermission =
        await PhotoManager.requestPermissionExtend(
          requestOption: const PermissionRequestOption(),
        );
      }

      if (!finalPermission.hasAccess) {
        setState(() {
          _isLoading = false;
          _errorMessage =
          "Permission denied.\nPlease allow photo access.";
        });
        return;
      }

      await _loadImages();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Error: $e";
        });
      }
    }
  }

  // ================= LOAD IMAGES =================

  Future<void> _loadImages() async {
    try {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: false,
        filterOption: FilterOptionGroup(
          orders: [
            const OrderOption(
              type: OrderOptionType.createDate,
              asc: false, // 🔥 NEWEST FIRST
            ),
          ],
        ),
      );

      if (albums.isEmpty) {
        setState(() {
          _images = [];
          _isLoading = false;
          _errorMessage = "No albums found.";
        });
        return;
      }

      final photos = await albums.first.getAssetListPaged(
        page: 0,
        size: 500,
      );

      if (mounted) {
        setState(() {
          _images = photos;
          _isLoading = false;
          _errorMessage =
          photos.isEmpty ? "No images found." : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage =
          "Failed to load images: $e";
        });
      }
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Device Gallery"),
        backgroundColor: Colors.grey[900],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 70,
                  color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _initialize,
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: _images.length,
      itemBuilder: (context, index) {
        return FutureBuilder<Uint8List?>(
          future: _images[index]
              .thumbnailDataWithSize(
            const ThumbnailSize(200, 200),
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                color: Colors.grey[800],
              );
            }

            return InkWell(
              onTap: () async {
                final file =
                await _images[index].file;
                if (file != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ImageView(
                            images: _images,
                            initialIndex: index,
                          ),
                    ),
                  );
                }
              },
              child: Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
            );
          },
        );
      },
    );
  }
}