import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:emulator/database/wallpaper_storage.dart';

class Addwallpaper extends StatefulWidget
{
    const Addwallpaper({super.key});

    @override
    State<Addwallpaper> createState() => _AddWallPaper();
}

class _AddWallPaper extends State<Addwallpaper>
{
    final StoreCurrentWallPaper _storage = StoreCurrentWallPaper();

    String currentWallpaper = "";

    @override
    void initState()
    {
        super.initState();
        _loadCurrentWallpaper();
    }

    Future<void> _loadCurrentWallpaper() async
    {
        String? path = await _storage.getWallpaper();
        if (!mounted) return;

        setState(()
            {
                currentWallpaper = path ?? "";
            });
    }

    /// 🔥 OPEN GALLERY
    Future<void> _openGallery() async
    {
        final PermissionState ps =
            await PhotoManager.requestPermissionExtend();

        if (!ps.isAuth && !ps.isLimited)
        {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Gallery permission required")
                )
            );
            return;
        }

        final albums = await PhotoManager.getAssetPathList(
            type: RequestType.image
        );

        if (albums.isEmpty) return;

        final recent = albums.first;

        final photos = await recent.getAssetListPaged(
            page: 0,
            size: 100
        );

        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_)
            {
                return SizedBox(
                    height: 500,
                    child: GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4
                        ),
                        itemCount: photos.length,
                        itemBuilder: (context, index)
                        {
                            return FutureBuilder<Uint8List?>(
                                future: photos[index].thumbnailDataWithSize(
                                    const ThumbnailSize(300, 300)
                                ),
                                builder: (context, snapshot)
                                {
                                    if (!snapshot.hasData)
                                    {
                                        return const SizedBox();
                                    }

                                    return InkWell(
                                        onTap: () async
                                        {
                                            final file = await photos[index].originFile;

                                            if (file == null) 
                                            {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text("Failed to load image"))
                                                );
                                                return;
                                            }

                                            await _saveWallpaper(file);
                                        },
                                        child: Image.memory(
                                            snapshot.data!,
                                            fit: BoxFit.cover
                                        )
                                    );
                                }
                            );
                        }
                    )
                );
            }
        );
    }

    /// 🔥 SAVE WALLPAPER SAFELY
    Future<void> _saveWallpaper(File originalFile) async {
      final appDir = await getApplicationDocumentsDirectory();

      try {
        final oldPath = await _storage.getWallpaper();

        if (oldPath != null) {
          final oldFile = File(oldPath);

          // 🔥 Only delete if file exists AND inside app directory
          if (await oldFile.exists() &&
              oldPath.startsWith(appDir.path)) {
            await oldFile.delete();
          }
        }
      } catch (e) {
        debugPrint("Old wallpaper delete failed: $e");
      }

      // 🔥 Create new file in app storage
      final fileName =
          "wallpaper_${DateTime.now().millisecondsSinceEpoch}.jpg";

      final newPath = "${appDir.path}/$fileName";

      final newFile = await originalFile.copy(newPath);

      await _storage.setWallpaper(newFile.path);

      if (!mounted) return;

      Navigator.pop(context, true);
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: CupertinoColors.black,
                title: const Text(
                    "Wallpaper",
                    style: TextStyle(fontSize: 24, color: Colors.white)
                )
            ),
            body: Column(
                children: [
                    const SizedBox(height: 30),

                    const Text(
                        "Current Wallpaper",
                        style: TextStyle(fontSize: 20)
                    ),

                    const SizedBox(height: 20),

                    currentWallpaper.isEmpty
                        ? const Icon(Icons.image, size: 100)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                                File(currentWallpaper),
                                width: 200,
                                height: 150,
                                fit: BoxFit.cover
                            )
                        ),

                    const SizedBox(height: 40),

                    ElevatedButton(
                        onPressed: _openGallery,
                        child: const Text("Choose From Gallery")
                    )
                ]
            )
        );
    }
}